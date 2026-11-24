import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/app_config.dart';
import '../../core/database/database_helper.dart';
import '../connectivity/connectivity_service.dart';

enum SyncStatus {
  offline,
  pending,
  syncing,
  synced,
  failed,
  unconfigured,
}

class SyncResult {
  final SyncStatus status;
  final int pendingCount;
  final int syncedCount;
  final String message;
  final String? authenticatedOwnerId;

  SyncResult({
    required this.status,
    required this.pendingCount,
    this.syncedCount = 0,
    required this.message,
    this.authenticatedOwnerId,
  });
}

class SyncService {
  final DatabaseHelper _dbHelper;
  final ConnectivityService _connectivity;
  SupabaseClient? _supabaseClient;
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isSynchronizing = false;
  SyncResult? _lastSyncResult;
  final List<String> _diagnosticLogs = [];

  SyncResult? get lastSyncResult => _lastSyncResult;
  List<String> get diagnosticLogs => List.unmodifiable(_diagnosticLogs);

  void _log(String message) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    final entry = '[$timeStr] $message';
    _diagnosticLogs.add(entry);
    if (_diagnosticLogs.length > 50) {
      _diagnosticLogs.removeAt(0);
    }
    debugPrint('[SyncService] $message');
  }

  SyncService({
    DatabaseHelper? dbHelper,
    ConnectivityService? connectivity,
    SupabaseClient? supabaseClient,
    bool autoSync = true,
  })  : _dbHelper = dbHelper ?? DatabaseHelper.instance,
        _connectivity = connectivity ?? ConnectivityService(),
        _supabaseClient = supabaseClient {
    if (autoSync) {
      _startAutoSyncListener();
    }
  }

  void _startAutoSyncListener() {
    _connectivitySubscription = _connectivity.isOnlineStream.listen((isOnline) {
      if (isOnline && !_isSynchronizing) {
        synchronize();
      }
    });
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }

  /// Logs errors with full PostgREST diagnostics without exposing secret keys/tokens
  void _logError(String operation, dynamic error) {
    if (error is PostgrestException) {
      _log('PostgREST Error in $operation: Code ${error.code}: ${error.message} (Hint: ${error.hint ?? "none"})');
      debugPrint('[SyncService][$operation] PostgREST Error:');
      debugPrint('  Status/Code: ${error.code}');
      debugPrint('  Message: ${error.message}');
      debugPrint('  Details: ${error.details}');
      debugPrint('  Hint: ${error.hint}');
    } else {
      _log('Error in $operation: $error');
      debugPrint('[SyncService][$operation] Error: $error');
    }
  }

  /// Extracts clean, informative message for PostgREST errors
  String _extractPostgrestErrorMessage(dynamic error) {
    if (error is PostgrestException) {
      final code = error.code ?? '';
      if (code == '42501') {
        return 'Permission check failed (RLS 42501). Profile must be synced first.';
      }
      if (code == '23503') {
        return 'Referenced student ID does not exist in cloud database (FK 23503).';
      }
      if (code == '23514') {
        return 'Check constraint failed (${error.message}).';
      }
      if (code == '23505') {
        return 'Duplicate record detected on server.';
      }
      return 'Server error ($code: ${error.message})';
    }
    return _toUserFriendlyError(error);
  }

  /// Strictly normalizes question difficulty to Postgres check constraint requirements
  String _normalizeDifficulty(dynamic raw) {
    if (raw == null) return 'easy';
    final s = raw.toString().toLowerCase().trim();
    if (s == 'medium' || s == 'intermediate' || s == '2') return 'medium';
    if (s == 'hard' || s == 'advanced' || s == '3') return 'hard';
    return 'easy';
  }

  String _toUserFriendlyError(dynamic error) {
    final errStr = error.toString().toLowerCase();
    if (errStr.contains('socketexception') ||
        errStr.contains('failed host lookup') ||
        errStr.contains('no address associated with hostname') ||
        errStr.contains('network is unreachable') ||
        errStr.contains('connection refused') ||
        errStr.contains('connection timed out') ||
        errStr.contains('handshakeexception') ||
        errStr.contains('errno = 7')) {
      return 'Unable to reach cloud server. Please check internet connection.';
    }
    if (errStr.contains('anonymous_provider_disabled') ||
        errStr.contains('invalid api key') ||
        errStr.contains('jwt')) {
      return 'Cloud service is currently undergoing maintenance. Local progress is safe.';
    }
    if (errStr.contains('restoration failed') || errStr.contains('cannot silently replace')) {
      return 'Cloud identity could not be verified. Local learning data remains secure.';
    }
    return 'Unable to complete cloud sync. All learning progress is preserved locally.';
  }

  Future<int> getPendingSyncCount() async {
    final db = await _dbHelper.database;
    final res = await db.rawQuery(
      "SELECT COUNT(*) as count FROM sync_queue WHERE status = 'pending' OR status = 'failed'",
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  Future<int> getFailedSyncCount() async {
    final db = await _dbHelper.database;
    final res = await db.rawQuery(
      "SELECT COUNT(*) as count FROM sync_queue WHERE status = 'failed'",
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  /// Check current synchronization state
  Future<SyncResult> getSyncState() async {
    final pending = await getPendingSyncCount();
    final failed = await getFailedSyncCount();
    final isOnline = await _connectivity.checkIsOnline();

    final url = await AppConfig.getSavedSupabaseUrl();
    final anonKey = await AppConfig.getSavedSupabaseAnonKey();

    if (url == null || url.isEmpty || anonKey == null || anonKey.isEmpty) {
      return SyncResult(
        status: SyncStatus.unconfigured,
        pendingCount: pending,
        message: 'All learning progress is securely stored offline.',
      );
    }

    if (!isOnline) {
      return SyncResult(
        status: SyncStatus.offline,
        pendingCount: pending,
        message: pending > 0 ? '$pending records waiting to sync.' : 'Offline mode active. Learning is ready.',
      );
    }

    // If the last synchronization failed, reflect the failure accurately
    if (_lastSyncResult != null && _lastSyncResult!.status == SyncStatus.failed) {
      return SyncResult(
        status: SyncStatus.failed,
        pendingCount: pending,
        message: _lastSyncResult!.message,
      );
    }

    if (failed > 0) {
      return SyncResult(
        status: SyncStatus.failed,
        pendingCount: pending,
        message: '$failed records could not be synced. Tap below to retry.',
      );
    }

    if (pending > 0) {
      return SyncResult(
        status: SyncStatus.pending,
        pendingCount: pending,
        message: '$pending records ready to synchronize.',
      );
    }

    return SyncResult(
      status: SyncStatus.synced,
      pendingCount: 0,
      message: 'All learning progress synchronized with cloud.',
    );
  }

  /// Restores an existing session or creates a new anonymous session.
  /// Strict rule: If an identity was previously created on this device,
  /// do NOT silently create a new one if session restoration fails.
  Future<User> getOrCreateAuthenticatedUser(SupabaseClient client) async {
    // 1. Check if current client in-memory session is already valid
    final inMemoryUser = client.auth.currentUser;
    final inMemorySession = client.auth.currentSession;
    if (inMemoryUser != null && inMemorySession != null) {
      debugPrint('[SyncService] Using active in-memory session for UID: ${inMemoryUser.id}');
      await AppConfig.saveCloudOwnerId(inMemoryUser.id);
      await AppConfig.savePersistedSession(json.encode(inMemorySession.toJson()));
      return inMemoryUser;
    }

    final savedOwnerId = await AppConfig.getSavedCloudOwnerId();
    final savedSessionJson = await AppConfig.getSavedPersistedSession();

    // 2. If a session was previously saved, attempt to recover it
    if (savedSessionJson != null && savedSessionJson.isNotEmpty) {
      try {
        debugPrint('[SyncService] Recovering saved session for expected owner: $savedOwnerId');
        final res = await client.auth.recoverSession(savedSessionJson);
        final restoredUser = res.user ?? client.auth.currentUser;
        final restoredSession = res.session ?? client.auth.currentSession;

        if (restoredUser != null) {
          if (savedOwnerId != null && restoredUser.id != savedOwnerId) {
            throw Exception('Restored cloud identity mismatch ($savedOwnerId vs ${restoredUser.id}).');
          }
          await AppConfig.saveCloudOwnerId(restoredUser.id);
          if (restoredSession != null) {
            await AppConfig.savePersistedSession(json.encode(restoredSession.toJson()));
          }
          debugPrint('[SyncService] Successfully restored session for UID: ${restoredUser.id}');
          return restoredUser;
        }
      } catch (e) {
        _logError('auth.recoverSession', e);
        if (savedOwnerId != null) {
          throw Exception('Existing cloud identity ($savedOwnerId) restoration failed: ${e.toString()}. Cannot silently replace identity.');
        }
      }
    }

    // 3. If an identity was previously registered on this device, do NOT silently replace it
    if (savedOwnerId != null && savedOwnerId.isNotEmpty) {
      throw Exception('Device is bound to cloud identity $savedOwnerId, but authentication session could not be restored. Cannot silently replace cloud identity.');
    }

    // 4. First cloud connection for this device: authenticate anonymously
    debugPrint('[SyncService] Creating new anonymous authentication session...');
    final authResponse = await client.auth.signInAnonymously();
    final newUser = authResponse.user;
    final newSession = authResponse.session;

    if (newUser == null) {
      throw Exception('Supabase anonymous sign-in failed: no user returned.');
    }

    debugPrint('[SyncService] Successfully signed in anonymously as UID: ${newUser.id}');

    // Securely persist new identity and session across restarts
    await AppConfig.saveCloudOwnerId(newUser.id);
    if (newSession != null) {
      await AppConfig.savePersistedSession(json.encode(newSession.toJson()));
    }

    return newUser;
  }

  /// Perform synchronization of queued records with strict ordering and security
  Future<SyncResult> synchronize() async {
    if (_isSynchronizing) {
      final pendingCount = await getPendingSyncCount();
      return SyncResult(
        status: SyncStatus.syncing,
        pendingCount: pendingCount,
        message: 'Synchronization already in progress...',
      );
    }
    _isSynchronizing = true;
    String? lastServerErrorMessage;

    try {
      final pendingCount = await getPendingSyncCount();
      _log('Starting synchronization. Pending items: $pendingCount');
      final isOnline = await _connectivity.checkIsOnline();

      if (!isOnline) {
        _log('Device is offline. Aborting sync.');
        final res = SyncResult(
          status: SyncStatus.offline,
          pendingCount: pendingCount,
          message: 'Internet connection is unavailable. Progress saved locally.',
        );
        _lastSyncResult = res;
        return res;
      }

      final url = await AppConfig.getSavedSupabaseUrl();
      final anonKey = await AppConfig.getSavedSupabaseAnonKey();

      if (url == null || url.isEmpty || anonKey == null || anonKey.isEmpty) {
        final res = SyncResult(
          status: SyncStatus.unconfigured,
          pendingCount: pendingCount,
          message: 'Supabase backend credentials not set. Offline mode continues.',
        );
        _lastSyncResult = res;
        return res;
      }

      // Initialize Supabase client dynamically if needed
      try {
        _supabaseClient ??= SupabaseClient(url, anonKey);
      } catch (e) {
        _logError('client.init', e);
        final res = SyncResult(
          status: SyncStatus.failed,
          pendingCount: pendingCount,
          message: _toUserFriendlyError(e),
        );
        _lastSyncResult = res;
        return res;
      }

      // Authenticate using Supabase Anonymous Authentication
      final User authenticatedUser;
      try {
        authenticatedUser = await getOrCreateAuthenticatedUser(_supabaseClient!);
      } catch (authError) {
        _logError('auth.signInAnonymously', authError);
        final res = SyncResult(
          status: SyncStatus.failed,
          pendingCount: pendingCount,
          message: _toUserFriendlyError(authError),
        );
        _lastSyncResult = res;
        return res;
      }

      final db = await _dbHelper.database;
      int syncedSuccess = 0;

      // =========================================================================
      // STEP 1: Pre-synchronize ALL local student profiles
      // Requirement 6 & 7: Guarantees offline profiles created in earlier APK
      // versions are uploaded to Supabase before their quiz attempts are sent.
      // =========================================================================
      final localStudents = await db.query('students');
      _log('Found ${localStudents.length} local student profile(s) in SQLite.');

      final Set<String> verifiedCloudStudentIds = {};

      for (var s in localStudents) {
        final studentId = s['id'] as String;
        try {
          _log('Ensuring profile for student $studentId (${s['name']}) is synced in Supabase...');
          await _supabaseClient!.from('student_profiles').upsert({
            'id': studentId,
            'owner_id': authenticatedUser.id,
            'name': s['name'],
            'class_id': s['class_id'],
            'preferred_language': s['preferred_language'] ?? 'en',
            'avatar_id': s['avatar_id'] ?? 'avatar_owl',
            'classroom_code': s['classroom_code'],
            'created_at': s['created_at'],
            'last_active_at': s['last_active_at'] ?? DateTime.now().toIso8601String(),
          });
          verifiedCloudStudentIds.add(studentId);
          _log('Student profile $studentId successfully confirmed in cloud.');

          // Mark any corresponding student_profile items in sync_queue as synced
          await db.update(
            'sync_queue',
            {
              'status': 'synced',
              'last_attempt_at': DateTime.now().toIso8601String(),
            },
            where: "entity_type = 'student_profile' AND (entity_id = ? OR payload_json LIKE ?)",
            whereArgs: [studentId, '%$studentId%'],
          );
        } catch (profileError) {
          _logError('student_profiles.upsert ($studentId)', profileError);
          lastServerErrorMessage = _extractPostgrestErrorMessage(profileError);
        }
      }

      // =========================================================================
      // STEP 2: Query queue items (pending or failed)
      // =========================================================================
      final queueItems = await db.query(
        'sync_queue',
        where: "status = 'pending' OR status = 'failed'",
        orderBy: 'created_at ASC',
        limit: 100,
      );

      debugPrint('[SyncService] Queue contains ${queueItems.length} items to process.');

      if (queueItems.isEmpty) {
        final res = SyncResult(
          status: SyncStatus.synced,
          pendingCount: 0,
          authenticatedOwnerId: authenticatedUser.id,
          message: 'All records are up to date.',
        );
        _lastSyncResult = res;
        return res;
      }

      // Strict Ordering (Requirement 6):
      // Profiles are processed first, then attempts
      final profileItems = queueItems.where((r) => r['entity_type'] == 'student_profile').toList();
      final attemptItems = queueItems.where((r) => r['entity_type'] == 'attempt').toList();
      final otherItems = queueItems.where((r) => r['entity_type'] != 'student_profile' && r['entity_type'] != 'attempt').toList();

      // 1. Process profile items from queue
      for (var row in profileItems) {
        final itemId = row['id'] as String;
        final payloadJson = row['payload_json'] as String;
        final Map<String, dynamic> payload = json.decode(payloadJson);
        final studentId = payload['id'] as String;

        try {
          await _supabaseClient!.from('student_profiles').upsert({
            'id': studentId,
            'owner_id': authenticatedUser.id,
            'name': payload['name'],
            'class_id': payload['class_id'],
            'preferred_language': payload['preferred_language'] ?? 'en',
            'avatar_id': payload['avatar_id'] ?? 'avatar_owl',
            'classroom_code': payload['classroom_code'],
            'created_at': payload['created_at'],
            'last_active_at': payload['last_active_at'],
          });

          await db.update(
            'sync_queue',
            {
              'status': 'synced',
              'last_attempt_at': DateTime.now().toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [itemId],
          );
          verifiedCloudStudentIds.add(studentId);
          syncedSuccess++;
          debugPrint('[SyncService] Synced profile queue item: $itemId (Student: $studentId)');
        } catch (e) {
          _logError('student_profiles.queue_upsert ($itemId)', e);
          lastServerErrorMessage = _extractPostgrestErrorMessage(e);
          final retries = (row['retry_count'] as int) + 1;
          await db.update(
            'sync_queue',
            {
              'status': 'failed',
              'retry_count': retries,
              'last_attempt_at': DateTime.now().toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [itemId],
          );
        }
      }

      // 2. Process attempt items with student verification & ignoreDuplicates: true
      for (var row in attemptItems) {
        final itemId = row['id'] as String;
        final payloadJson = row['payload_json'] as String;
        final Map<String, dynamic> payload = json.decode(payloadJson);
        final studentId = payload['student_id'] as String?;

        // Requirement 8: Verify referenced student_id exists in Supabase before inserting
        if (studentId == null || !verifiedCloudStudentIds.contains(studentId)) {
          bool studentExistsInCloud = false;
          if (studentId != null) {
            try {
              final check = await _supabaseClient!
                  .from('student_profiles')
                  .select('id')
                  .eq('id', studentId)
                  .maybeSingle();
              if (check != null) {
                studentExistsInCloud = true;
                verifiedCloudStudentIds.add(studentId);
              }
            } catch (e) {
              _logError('student_profiles.check ($studentId)', e);
            }
          }

          if (!studentExistsInCloud) {
            debugPrint('[SyncService] Cannot sync attempt $itemId: student_id $studentId is not in Supabase.');
            lastServerErrorMessage = 'Student profile must exist in cloud before uploading quiz attempts.';
            final retries = (row['retry_count'] as int) + 1;
            await db.update(
              'sync_queue',
              {
                'status': 'failed',
                'retry_count': retries,
                'last_attempt_at': DateTime.now().toIso8601String(),
              },
              where: 'id = ?',
              whereArgs: [itemId],
            );
            continue;
          }
        }

        try {
          final normalizedDiff = _normalizeDifficulty(payload['difficulty']);
          _log('Upserting attempt ${payload['attempt_id']} for student $studentId (diff: $normalizedDiff)');

          await _supabaseClient!.from('student_attempts').upsert(
            {
              'id': payload['attempt_id'],
              'student_id': payload['student_id'],
              'question_id': payload['question_id'],
              'topic_id': payload['topic_id'],
              'skill_id': payload['skill_id'],
              'selected_option_id': payload['selected_option_id'],
              'is_correct': payload['is_correct'],
              'difficulty': normalizedDiff,
              'mastery_before': payload['mastery_before'],
              'mastery_after': payload['mastery_after'],
              'answered_at': payload['answered_at'],
              'created_at': payload['created_at'],
            },
            ignoreDuplicates: true,
          );

          await db.update(
            'sync_queue',
            {
              'status': 'synced',
              'last_attempt_at': DateTime.now().toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [itemId],
          );
          syncedSuccess++;
          _log('Attempt ${payload['attempt_id']} successfully synced.');
        } catch (e) {
          _logError('student_attempts.upsert ($itemId)', e);
          lastServerErrorMessage = _extractPostgrestErrorMessage(e);
          final retries = (row['retry_count'] as int) + 1;
          await db.update(
            'sync_queue',
            {
              'status': 'failed',
              'retry_count': retries,
              'last_attempt_at': DateTime.now().toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [itemId],
          );
        }
      }

      // 3. Sync any other remaining items
      for (var row in otherItems) {
        final itemId = row['id'] as String;
        await db.update(
          'sync_queue',
          {
            'status': 'synced',
            'last_attempt_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [itemId],
        );
        syncedSuccess++;
      }

      final remaining = await getPendingSyncCount();
      if (remaining == 0) {
        final res = SyncResult(
          status: SyncStatus.synced,
          pendingCount: 0,
          syncedCount: syncedSuccess,
          authenticatedOwnerId: authenticatedUser.id,
          message: syncedSuccess > 0 
              ? 'Successfully synchronized $syncedSuccess records.'
              : 'All records are up to date.',
        );
        _lastSyncResult = res;
        return res;
      } else {
        // Requirement 18: Distinguish server rejection from connectivity failure
        final String failMessage;
        if (syncedSuccess > 0) {
          failMessage = 'Synced $syncedSuccess records, $remaining remaining. (Server: ${lastServerErrorMessage ?? "in progress"})';
        } else if (lastServerErrorMessage != null) {
          failMessage = 'Cloud rejected sync: $lastServerErrorMessage. Local data safe.';
        } else {
          failMessage = 'Could not sync $remaining records. Progress is safely saved locally.';
        }

        final res = SyncResult(
          status: SyncStatus.failed,
          pendingCount: remaining,
          syncedCount: syncedSuccess,
          authenticatedOwnerId: authenticatedUser.id,
          message: failMessage,
        );
        _lastSyncResult = res;
        return res;
      }
    } catch (unexpectedError) {
      _logError('sync.unexpected', unexpectedError);
      final res = SyncResult(
        status: SyncStatus.failed,
        pendingCount: await getPendingSyncCount(),
        message: _toUserFriendlyError(unexpectedError),
      );
      _lastSyncResult = res;
      return res;
    } finally {
      _isSynchronizing = false;
    }
  }
}
