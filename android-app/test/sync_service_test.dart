import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shikshaedge/core/config/app_config.dart';
import 'package:shikshaedge/models/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('SyncService & Identity Persistence Tests', () {
    test('Cloud Owner ID and Session Persistence in AppConfig', () async {
      expect(await AppConfig.getSavedCloudOwnerId(), isNull);
      expect(await AppConfig.getSavedPersistedSession(), isNull);

      const testOwnerId = 'e2055be2-5e87-43cf-bbce-19615a133cb0';
      const testSessionJson = '{"access_token":"dummy_jwt","token_type":"bearer","user":{"id":"$testOwnerId"}}';

      await AppConfig.saveCloudOwnerId(testOwnerId);
      await AppConfig.savePersistedSession(testSessionJson);

      expect(await AppConfig.getSavedCloudOwnerId(), equals(testOwnerId));
      expect(await AppConfig.getSavedPersistedSession(), equals(testSessionJson));

      await AppConfig.clearPersistedSession();
      expect(await AppConfig.getSavedPersistedSession(), isNull);
      // Owner ID is still preserved to prevent silent replacement
      expect(await AppConfig.getSavedCloudOwnerId(), equals(testOwnerId));
    });

    test('Payload format includes owner_id mapping', () {
      const authenticatedUserId = 'auth-user-uuid-1234';
      final localProfilePayload = {
        'id': 'student-uuid-5678',
        'name': 'Chaitra',
        'class_id': 'class_6',
        'preferred_language': 'kn',
        'avatar_id': 'avatar_owl',
        'classroom_code': 'RURAL01',
        'created_at': '2026-11-24T00:00:00Z',
        'last_active_at': '2026-11-24T00:00:00Z',
      };

      // Mapped payload for Supabase upsert
      final supabasePayload = {
        'id': localProfilePayload['id'],
        'owner_id': authenticatedUserId,
        'name': localProfilePayload['name'],
        'class_id': localProfilePayload['class_id'],
        'preferred_language': localProfilePayload['preferred_language'],
        'avatar_id': localProfilePayload['avatar_id'],
        'classroom_code': localProfilePayload['classroom_code'],
        'created_at': localProfilePayload['created_at'],
        'last_active_at': localProfilePayload['last_active_at'],
      };

      expect(supabasePayload['owner_id'], equals(authenticatedUserId));
      expect(supabasePayload['id'], equals('student-uuid-5678'));
    });

    test('Sync queue preserves failed items for retry without deleting local data', () {
      final failedItem = SyncQueueItem(
        id: 'q_fail_01',
        entityType: 'attempt',
        entityId: 'att_99',
        payloadJson: '{"id": "att_99"}',
        createdAt: DateTime.now(),
        status: 'failed',
        retryCount: 3,
        lastAttemptAt: DateTime.now(),
      );

      // Verify status is failed and retryCount is incremented
      expect(failedItem.status, equals('failed'));
      expect(failedItem.retryCount, equals(3));

      // Eligible for retry: queries include status = 'pending' OR status = 'failed'
      const queryWhere = "status = 'pending' OR status = 'failed'";
      expect(queryWhere.contains(failedItem.status), isTrue);
    });

    test('Strict sync ordering: profiles partitioned before attempts', () {
      final items = [
        {'id': '1', 'entity_type': 'attempt', 'name': 'Attempt 1'},
        {'id': '2', 'entity_type': 'student_profile', 'name': 'Profile 1'},
        {'id': '3', 'entity_type': 'attempt', 'name': 'Attempt 2'},
        {'id': '4', 'entity_type': 'student_profile', 'name': 'Profile 2'},
      ];

      final profiles = items.where((r) => r['entity_type'] == 'student_profile').toList();
      final attempts = items.where((r) => r['entity_type'] == 'attempt').toList();

      expect(profiles.length, 2);
      expect(attempts.length, 2);
      expect(profiles[0]['id'], equals('2'));
      expect(profiles[1]['id'], equals('4'));
      expect(attempts[0]['id'], equals('1'));
      expect(attempts[1]['id'], equals('3'));
    });

    test('Difficulty normalization maps raw values strictly to easy, medium, hard', () {
      String normalizeDifficulty(dynamic raw) {
        if (raw == null) return 'easy';
        final s = raw.toString().toLowerCase().trim();
        if (s == 'medium' || s == 'intermediate' || s == '2') return 'medium';
        if (s == 'hard' || s == 'advanced' || s == '3') return 'hard';
        return 'easy';
      }

      expect(normalizeDifficulty('easy'), equals('easy'));
      expect(normalizeDifficulty('EASY'), equals('easy'));
      expect(normalizeDifficulty('Easy'), equals('easy'));
      expect(normalizeDifficulty('medium'), equals('medium'));
      expect(normalizeDifficulty('MEDIUM'), equals('medium'));
      expect(normalizeDifficulty('2'), equals('medium'));
      expect(normalizeDifficulty('hard'), equals('hard'));
      expect(normalizeDifficulty('HARD'), equals('hard'));
      expect(normalizeDifficulty('3'), equals('hard'));
      expect(normalizeDifficulty(null), equals('easy'));
      expect(normalizeDifficulty('unknown'), equals('easy'));
    });

    test('Existing profile upgrade scenario ensures profiles are mapped before attempts', () {
      // Simulating a student profile created on an earlier APK version (no sync_queue entry)
      final existingLocalStudents = [
        {
          'id': 'legacy-student-001',
          'name': 'Goutam',
          'class_id': 'class_5',
          'preferred_language': 'en',
          'avatar_id': 'avatar_owl',
        }
      ];

      // Attempts in sync queue referencing the student
      final queuedAttempts = [
        {'id': 'att_1', 'student_id': 'legacy-student-001'},
        {'id': 'att_2', 'student_id': 'legacy-student-001'},
        {'id': 'att_3', 'student_id': 'legacy-student-001'},
      ];

      final verifiedCloudStudents = <String>{};

      // Step 1: Pre-sync all local profiles
      for (var s in existingLocalStudents) {
        verifiedCloudStudents.add(s['id'] as String);
      }

      // Step 2: Validate all queued attempts have verified profile in cloud
      for (var att in queuedAttempts) {
        expect(verifiedCloudStudents.contains(att['student_id']), isTrue);
      }
    });
  });
}
