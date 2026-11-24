import 'package:fl_chart/fl_chart.dart';
import '../core/database/database_helper.dart';

class StudentAnalytics {
  final double overallMastery;
  final int totalAttempts;
  final int correctAttempts;
  final double accuracyPercentage;
  final int streakDays;
  final int completedLessonsCount;
  final List<TopicMasterySummary> topicSummaries;
  final List<Map<String, dynamic>> recentAttempts;
  final List<FlSpot> masteryHistorySpots;

  StudentAnalytics({
    required this.overallMastery,
    required this.totalAttempts,
    required this.correctAttempts,
    required this.accuracyPercentage,
    required this.streakDays,
    required this.completedLessonsCount,
    required this.topicSummaries,
    required this.recentAttempts,
    required this.masteryHistorySpots,
  });
}

class TopicMasterySummary {
  final String topicId;
  final String title;
  final String titleKn;
  final String subjectName;
  final double averageMastery;
  final String tier; // 'Needs Practice', 'Developing', 'Proficient'

  TopicMasterySummary({
    required this.topicId,
    required this.title,
    required this.titleKn,
    required this.subjectName,
    required this.averageMastery,
    required this.tier,
  });
}

class ProgressRepository {
  final DatabaseHelper _dbHelper;

  ProgressRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<StudentAnalytics> getAnalyticsForStudent(String studentId) async {
    final db = await _dbHelper.database;

    // 1. Attempts count and accuracy
    final attemptsResult = await db.rawQuery('''
      SELECT 
        COUNT(*) as total,
        SUM(is_correct) as correct
      FROM attempts
      WHERE student_id = ?
    ''', [studentId]);

    final totalAttempts = (attemptsResult.first['total'] as int?) ?? 0;
    final correctAttempts = (attemptsResult.first['correct'] as int?) ?? 0;
    final accuracyPercentage = totalAttempts > 0 ? (correctAttempts / totalAttempts) * 100.0 : 0.0;

    // 2. Overall mastery across student's skills
    final masteryResult = await db.rawQuery('''
      SELECT AVG(mastery_probability) as avg_mastery
      FROM mastery
      WHERE student_id = ?
    ''', [studentId]);

    final overallMastery = (masteryResult.first['avg_mastery'] as num?)?.toDouble() ?? 0.30;

    // 3. Completed lessons count
    final lessonsResult = await db.rawQuery('''
      SELECT COUNT(*) as completed_count
      FROM lesson_progress
      WHERE student_id = ? AND is_completed = 1
    ''', [studentId]);
    final completedLessonsCount = (lessonsResult.first['completed_count'] as int?) ?? 0;

    // 4. Learning streak calculation from attempts
    final streakDays = await _calculateStreakDays(studentId);

    // 5. Topic summaries
    final topicRows = await db.rawQuery('''
      SELECT 
        t.id as topic_id,
        t.title,
        t.title_kn,
        s.name as subject_name,
        COALESCE(AVG(m.mastery_probability), 0.30) as avg_mastery
      FROM topics t
      JOIN subjects s ON t.subject_id = s.id
      LEFT JOIN skills sk ON sk.topic_id = t.id
      LEFT JOIN mastery m ON m.skill_id = sk.id AND m.student_id = ?
      GROUP BY t.id
      ORDER BY avg_mastery ASC
    ''', [studentId]);

    final topicSummaries = topicRows.map((r) {
      final avgM = (r['avg_mastery'] as num).toDouble();
      String tier = 'Needs Practice';
      if (avgM > 0.75) {
        tier = 'Proficient';
      } else if (avgM >= 0.40) {
        tier = 'Developing';
      }
      return TopicMasterySummary(
        topicId: r['topic_id'] as String,
        title: r['title'] as String,
        titleKn: r['title_kn'] as String,
        subjectName: r['subject_name'] as String,
        averageMastery: avgM,
        tier: tier,
      );
    }).toList();

    // 6. Recent attempts
    final recentAttempts = await db.rawQuery('''
      SELECT 
        a.id,
        a.is_correct,
        a.difficulty,
        a.mastery_before,
        a.mastery_after,
        a.answered_at,
        q.question_text,
        q.question_text_kn,
        t.title as topic_title
      FROM attempts a
      JOIN questions q ON a.question_id = q.id
      JOIN topics t ON a.topic_id = t.id
      WHERE a.student_id = ?
      ORDER BY a.answered_at DESC
      LIMIT 10
    ''', [studentId]);

    // 7. Mastery History Spots for fl_chart
    final historyRows = await db.rawQuery('''
      SELECT mastery_probability, timestamp
      FROM mastery_history
      WHERE student_id = ?
      ORDER BY timestamp ASC
      LIMIT 30
    ''', [studentId]);

    final List<FlSpot> spots = [];
    if (historyRows.isEmpty) {
      // Default starting point
      spots.add(const FlSpot(0, 0.30));
    } else {
      for (int i = 0; i < historyRows.length; i++) {
        final prob = (historyRows[i]['mastery_probability'] as num).toDouble();
        spots.add(FlSpot(i.toDouble(), prob));
      }
    }

    return StudentAnalytics(
      overallMastery: overallMastery,
      totalAttempts: totalAttempts,
      correctAttempts: correctAttempts,
      accuracyPercentage: accuracyPercentage,
      streakDays: streakDays,
      completedLessonsCount: completedLessonsCount,
      topicSummaries: topicSummaries,
      recentAttempts: recentAttempts,
      masteryHistorySpots: spots,
    );
  }

  Future<int> _calculateStreakDays(String studentId) async {
    final db = await _dbHelper.database;
    final rows = await db.rawQuery('''
      SELECT DISTINCT substr(answered_at, 1, 10) as day
      FROM attempts
      WHERE student_id = ?
      ORDER BY day DESC
    ''', [studentId]);

    if (rows.isEmpty) return 0;

    final dates = rows.map((r) => DateTime.parse(r['day'] as String)).toList();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // If student didn't practice today or yesterday, streak is broken
    final mostRecent = dates.first;
    if (mostRecent.isBefore(yesterday)) {
      return 0;
    }

    int streak = 0;
    DateTime currentCheck = mostRecent;

    for (var d in dates) {
      if (d == currentCheck) {
        streak++;
        currentCheck = currentCheck.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }
}
