import 'dart:async';
import 'dart:convert';
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

  Future<int> getPendingSyncCount() async {
    final db = await _dbHelper.database;
    final res = await db.rawQuery(
      "SELECT COUNT(*) as count FROM sync_queue WHERE status = 'pending' OR status = 'failed'",
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  /// Check current synchronization state
  Future<SyncResult> getSyncState() async {
    final pending = await getPendingSyncCount();
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
        message: pending > 0 ? '$pending changes pending sync.' : 'Offline mode active. Learning is ready.',
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
      await AppConfig.saveCloudOwnerId(inMemoryUser.id);
      await AppConfig.savePersistedSession(json.encode(inMemorySession.toJson()));
      return inMemoryUser;
    }

    final savedOwnerId = await AppConfig.getSavedCloudOwnerId();
    final savedSessionJson = await AppConfig.getSavedPersistedSession();

    // 2. If a session was previously saved, attempt to recover it
    if (savedSessionJson != null && savedSessionJson.isNotEmpty) {
      try {
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
          return restoredUser;
        }
      } catch (e) {
        // Session restoration failed
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
    final authResponse = await client.auth.signInAnonymously();
    final newUser = authResponse.user;
    final newSession = authResponse.session;

    if (newUser == null) {
      throw Exception('Supabase anonymous sign-in failed: no user returned.');
    }

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

    try {
      final pendingCount = await getPendingSyncCount();
      final isOnline = await _connectivity.checkIsOnline();

    if (!isOnline) {
      return SyncResult(
        status: SyncStatus.offline,
        pendingCount: pendingCount,
        message: 'Internet connection is unavailable. Progress saved locally.',
      );
    }

    final url = await AppConfig.getSavedSupabaseUrl();
    final anonKey = await AppConfig.getSavedSupabaseAnonKey();

    if (url == null || url.isEmpty || anonKey == null || anonKey.isEmpty) {
      return SyncResult(
        status: SyncStatus.unconfigured,
        pendingCount: pendingCount,
        message: 'Supabase backend credentials not set. Offline mode continues.',
      );
    }

    // Initialize Supabase client dynamically if needed
    try {
      _supabaseClient ??= SupabaseClient(url, anonKey);
    } catch (e) {
      return SyncResult(
        status: SyncStatus.failed,
        pendingCount: pendingCount,
        message: 'Failed to connect to backend: ${e.toString()}',
      );
    }

    // Authenticate using Supabase Anonymous Authentication
    final User authenticatedUser;
    try {
      authenticatedUser = await getOrCreateAuthenticatedUser(_supabaseClient!);
    } catch (authError) {
      return SyncResult(
        status: SyncStatus.failed,
        pendingCount: pendingCount,
        message: 'Cloud authentication failed: ${authError.toString()}',
      );
    }

    final db = await _dbHelper.database;
    final queueItems = await db.query(
      'sync_queue',
      where: "status = 'pending' OR status = 'failed'",
      orderBy: 'created_at ASC',
      limit: 100,
    );

    if (queueItems.isEmpty) {
      return SyncResult(
        status: SyncStatus.synced,
        pendingCount: 0,
        authenticatedOwnerId: authenticatedUser.id,
        message: 'All records are up to date.',
      );
    }

    int syncedSuccess = 0;

    // Strict Ordering (Requirement 6):
    // Synchronize student_profiles BEFORE uploading student_attempts
    final profileItems = queueItems.where((r) => r['entity_type'] == 'student_profile').toList();
    final attemptItems = queueItems.where((r) => r['entity_type'] == 'attempt').toList();
    final otherItems = queueItems.where((r) => r['entity_type'] != 'student_profile' && r['entity_type'] != 'attempt').toList();

    // 1. Sync Student Profiles first
    for (var row in profileItems) {
      final itemId = row['id'] as String;
      final payloadJson = row['payload_json'] as String;
      final Map<String, dynamic> payload = json.decode(payloadJson);

      try {
        await _supabaseClient!.from('student_profiles').upsert({
          'id': payload['id'],
          'owner_id': authenticatedUser.id, // Strictly uses authenticated user's UUID
          'name': payload['name'],
          'class_id': payload['class_id'],
          'preferred_language': payload['preferred_language'],
          'avatar_id': payload['avatar_id'],
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
        syncedSuccess++;
      } catch (e) {
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

    // 2. Sync Student Attempts second (Strict requirement: ignoreDuplicates: true)
    for (var row in attemptItems) {
      final itemId = row['id'] as String;
      final payloadJson = row['payload_json'] as String;
      final Map<String, dynamic> payload = json.decode(payloadJson);

      try {
        await _supabaseClient!.from('student_attempts').upsert(
          {
            'id': payload['attempt_id'],
            'student_id': payload['student_id'],
            'question_id': payload['question_id'],
            'topic_id': payload['topic_id'],
            'skill_id': payload['skill_id'],
            'selected_option_id': payload['selected_option_id'],
            'is_correct': payload['is_correct'],
            'difficulty': payload['difficulty'],
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
      } catch (e) {
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
      // Mark as synced locally
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
      return SyncResult(
        status: SyncStatus.synced,
        pendingCount: 0,
        syncedCount: syncedSuccess,
        authenticatedOwnerId: authenticatedUser.id,
        message: 'Successfully synchronized $syncedSuccess records.',
      );
    } else {
      return SyncResult(
        status: SyncStatus.failed,
        pendingCount: remaining,
        syncedCount: syncedSuccess,
        authenticatedOwnerId: authenticatedUser.id,
        message: 'Synced $syncedSuccess records, $remaining remaining.',
      );
    }
  } finally {
    _isSynchronizing = false;
  }
}
}
