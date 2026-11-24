import 'package:flutter_test/flutter_test.dart';
import 'package:shikshaedge/models/models.dart';

void main() {
  group('Domain Models & Offline Logic Tests', () {
    test('Student model serialization and copyWith', () {
      final now = DateTime.now();
      final student = Student(
        id: 'std_01',
        name: 'Ramesh Kumar',
        classId: 'class_6',
        preferredLanguage: 'kn',
        avatarId: 'avatar_owl',
        classroomCode: 'KA-06',
        createdAt: now,
        lastActiveAt: now,
      );

      final map = student.toMap();
      final restored = Student.fromMap(map);

      expect(restored.id, 'std_01');
      expect(restored.name, 'Ramesh Kumar');
      expect(restored.classId, 'class_6');
      expect(restored.preferredLanguage, 'kn');
      expect(restored.classroomCode, 'KA-06');

      final updated = student.copyWith(name: 'Suresh Kumar', preferredLanguage: 'en');
      expect(updated.name, 'Suresh Kumar');
      expect(updated.preferredLanguage, 'en');
      expect(updated.id, 'std_01');
    });

    test('Question and Options model validation', () {
      final question = Question(
        id: 'q_test_1',
        topicId: 'math_mult',
        skillId: 'skill_mult_concept',
        difficulty: 'easy',
        questionText: 'What is 3 x 4?',
        questionTextKn: '3 x 4 ರ ಮೊತ್ತ ಎಷ್ಟು?',
        explanation: '3 x 4 = 12',
        explanationKn: '3 x 4 = 12',
        hint: 'Add 4 three times',
        hintKn: '4 ನ್ನು 3 ಬಾರಿ ಕೂಡಿ',
        options: [
          QuestionOption(
            id: 'opt_1',
            questionId: 'q_test_1',
            optionText: '12',
            optionTextKn: '12',
            isCorrect: true,
            orderIndex: 0,
          ),
          QuestionOption(
            id: 'opt_2',
            questionId: 'q_test_1',
            optionText: '10',
            optionTextKn: '10',
            isCorrect: false,
            orderIndex: 1,
          ),
        ],
      );

      expect(question.options.length, 2);
      expect(question.options.first.isCorrect, isTrue);
      expect(question.options.last.isCorrect, isFalse);
    });

    test('SyncQueueItem serialization and status verification', () {
      final now = DateTime.now();
      final syncItem = SyncQueueItem(
        id: 'sync_01',
        entityType: 'attempt',
        entityId: 'att_01',
        payloadJson: '{"student_id": "std_01", "is_correct": true}',
        createdAt: now,
        status: 'pending',
      );

      final map = syncItem.toMap();
      final restored = SyncQueueItem.fromMap(map);

      expect(restored.id, 'sync_01');
      expect(restored.entityType, 'attempt');
      expect(restored.status, 'pending');
      expect(restored.retryCount, 0);
    });
  });
}
