import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../core/database/database_helper.dart';
import '../../models/models.dart';
import 'bkt_engine.dart';

class AdaptiveQuizService {
  final DatabaseHelper _dbHelper;
  final BktEngine _bktEngine;
  final Uuid _uuid = const Uuid();

  AdaptiveQuizService({
    DatabaseHelper? dbHelper,
    BktEngine? bktEngine,
  })  : _dbHelper = dbHelper ?? DatabaseHelper.instance,
        _bktEngine = bktEngine ?? const BktEngine();

  /// Retrieve current mastery for a student on a specific skill
  Future<double> getSkillMastery({
    required String studentId,
    required String skillId,
  }) async {
    final db = await _dbHelper.database;
    final res = await db.query(
      'mastery',
      where: 'student_id = ? AND skill_id = ?',
      whereArgs: [studentId, skillId],
    );

    if (res.isNotEmpty) {
      return (res.first['mastery_probability'] as num).toDouble();
    }
    // Default initial mastery if not attempted yet
    return _bktEngine.parameters.initialMastery;
  }

  /// Select next adaptive question for a topic and student
  Future<Question?> getNextAdaptiveQuestion({
    required String studentId,
    required String topicId,
    required List<String> excludedQuestionIds,
  }) async {
    final db = await _dbHelper.database;

    // 1. Fetch skills for this topic
    final skillRows = await db.query(
      'skills',
      where: 'topic_id = ?',
      whereArgs: [topicId],
    );

    if (skillRows.isEmpty) return null;

    // 2. Determine target skill and current mastery
    // Check skills in order of prerequisites, choose earliest skill below 0.75 or default to first
    String targetSkillId = skillRows.first['id'] as String;
    double currentMastery = 0.30;

    for (var sk in skillRows) {
      final sId = sk['id'] as String;
      final m = await getSkillMastery(studentId: studentId, skillId: sId);
      if (m < 0.75) {
        targetSkillId = sId;
        currentMastery = m;
        break;
      }
      currentMastery = m;
    }

    // 3. Determine target difficulty using BKT policy
    final targetDifficulty = _bktEngine.getDifficultyForMastery(currentMastery);

    // 4. Query questions matching target difficulty not yet answered in this session
    Question? selectedQuestion = await _queryQuestion(
      topicId: topicId,
      skillId: targetSkillId,
      difficulty: targetDifficulty,
      excludedIds: excludedQuestionIds,
    );

    // 5. Intelligent question exhaustion fallback:
    // If no questions in target difficulty, fallback to medium, then easy, then hard
    if (selectedQuestion == null) {
      final fallbackDifficulties = ['medium', 'easy', 'hard']
        ..remove(targetDifficulty);

      for (var diff in fallbackDifficulties) {
        selectedQuestion = await _queryQuestion(
          topicId: topicId,
          skillId: targetSkillId,
          difficulty: diff,
          excludedIds: excludedQuestionIds,
        );
        if (selectedQuestion != null) break;
      }
    }

    // 6. If still exhausted for target skill, look across any skill in the topic
    if (selectedQuestion == null) {
      final allRemaining = await _queryQuestion(
        topicId: topicId,
        skillId: null,
        difficulty: null,
        excludedIds: excludedQuestionIds,
      );
      selectedQuestion = allRemaining;
    }

    return selectedQuestion;
  }

  Future<Question?> _queryQuestion({
    required String topicId,
    String? skillId,
    String? difficulty,
    required List<String> excludedIds,
  }) async {
    final db = await _dbHelper.database;

    final whereClauses = ['topic_id = ?'];
    final whereArgs = <dynamic>[topicId];

    if (skillId != null) {
      whereClauses.add('skill_id = ?');
      whereArgs.add(skillId);
    }
    if (difficulty != null) {
      whereClauses.add('difficulty = ?');
      whereArgs.add(difficulty);
    }
    if (excludedIds.isNotEmpty) {
      final placeholders = List.filled(excludedIds.length, '?').join(',');
      whereClauses.add('id NOT IN ($placeholders)');
      whereArgs.addAll(excludedIds);
    }

    final rows = await db.query(
      'questions',
      where: whereClauses.join(' AND '),
      whereArgs: whereArgs,
      orderBy: 'RANDOM()',
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final qMap = rows.first;
    final qId = qMap['id'] as String;

    // Fetch options
    final optRows = await db.query(
      'question_options',
      where: 'question_id = ?',
      whereArgs: [qId],
      orderBy: 'order_index ASC',
    );

    final options = optRows.map((o) => QuestionOption.fromMap(o)).toList();
    return Question.fromMap(qMap, options);
  }

  /// Process answer submission, apply BKT calculation, and atomically record attempt and sync item
  Future<BktCalculationResult> submitAnswer({
    required String studentId,
    required Question question,
    required String selectedOptionId,
  }) async {
    final db = await _dbHelper.database;

    // Validate correctness
    final isCorrect = question.options.any(
      (opt) => opt.id == selectedOptionId && opt.isCorrect,
    );

    // 1. Get prior mastery
    final priorMastery = await getSkillMastery(
      studentId: studentId,
      skillId: question.skillId,
    );

    // 2. Calculate BKT update
    final bktResult = _bktEngine.updateMastery(
      currentMastery: priorMastery,
      isCorrect: isCorrect,
    );

    final now = DateTime.now();
    final attemptId = _uuid.v4();

    // 3. Atomic transaction: Save attempt, update mastery, append history, queue sync item
    await db.transaction((txn) async {
      // a) Insert attempt record
      final attempt = Attempt(
        id: attemptId,
        studentId: studentId,
        questionId: question.id,
        topicId: question.topicId,
        skillId: question.skillId,
        selectedOptionId: selectedOptionId,
        isCorrect: isCorrect,
        difficulty: question.difficulty,
        masteryBefore: priorMastery,
        masteryAfter: bktResult.updatedMastery,
        answeredAt: now,
        createdAt: now,
      );
      await txn.insert('attempts', attempt.toMap());

      // b) Upsert mastery table
      final existingMastery = await txn.query(
        'mastery',
        where: 'student_id = ? AND skill_id = ?',
        whereArgs: [studentId, question.skillId],
      );

      int attemptsCount = 1;
      int correctCount = isCorrect ? 1 : 0;
      if (existingMastery.isNotEmpty) {
        attemptsCount = (existingMastery.first['attempts_count'] as int) + 1;
        correctCount = (existingMastery.first['correct_count'] as int) + (isCorrect ? 1 : 0);
      }

      await txn.insert(
        'mastery',
        {
          'id': '${studentId}_${question.skillId}',
          'student_id': studentId,
          'skill_id': question.skillId,
          'mastery_probability': bktResult.updatedMastery,
          'attempts_count': attemptsCount,
          'correct_count': correctCount,
          'last_updated_at': now.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // c) Append mastery history
      await txn.insert('mastery_history', {
        'id': _uuid.v4(),
        'student_id': studentId,
        'skill_id': question.skillId,
        'attempt_id': attemptId,
        'mastery_probability': bktResult.updatedMastery,
        'timestamp': now.toIso8601String(),
      });

      // d) Add to persistent sync queue
      final syncPayload = {
        'attempt_id': attemptId,
        'student_id': studentId,
        'question_id': question.id,
        'topic_id': question.topicId,
        'skill_id': question.skillId,
        'selected_option_id': selectedOptionId,
        'is_correct': isCorrect,
        'difficulty': question.difficulty,
        'mastery_before': priorMastery,
        'mastery_after': bktResult.updatedMastery,
        'answered_at': now.toIso8601String(),
        'created_at': now.toIso8601String(),
      };

      await txn.insert('sync_queue', {
        'id': _uuid.v4(),
        'entity_type': 'attempt',
        'entity_id': attemptId,
        'payload_json': json.encode(syncPayload),
        'created_at': now.toIso8601String(),
        'retry_count': 0,
        'status': 'pending',
      });
    });

    return bktResult;
  }
}
