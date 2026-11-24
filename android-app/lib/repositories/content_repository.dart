import 'package:sqflite/sqflite.dart';
import '../core/database/database_helper.dart';
import '../models/models.dart';

class ContentRepository {
  final DatabaseHelper _dbHelper;

  ContentRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> getClasses() async {
    final db = await _dbHelper.database;
    return await db.query('classes', orderBy: 'grade_level ASC');
  }

  Future<List<Subject>> getSubjectsForClass(String classId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'subjects',
      where: 'class_id = ?',
      whereArgs: [classId],
      orderBy: 'order_index ASC',
    );
    return rows.map((r) => Subject.fromMap(r)).toList();
  }

  Future<List<Topic>> getTopicsForSubject(String subjectId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'topics',
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'order_index ASC',
    );
    return rows.map((r) => Topic.fromMap(r)).toList();
  }

  Future<Topic?> getTopicById(String topicId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'topics',
      where: 'id = ?',
      whereArgs: [topicId],
    );
    if (rows.isEmpty) return null;
    return Topic.fromMap(rows.first);
  }

  Future<List<Lesson>> getLessonsForTopic(String topicId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'lessons',
      where: 'topic_id = ?',
      whereArgs: [topicId],
      orderBy: 'order_index ASC',
    );
    return rows.map((r) => Lesson.fromMap(r)).toList();
  }

  Future<Lesson?> getLessonById(String lessonId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'lessons',
      where: 'id = ?',
      whereArgs: [lessonId],
    );
    if (rows.isEmpty) return null;
    return Lesson.fromMap(rows.first);
  }

  Future<Map<String, dynamic>?> getLessonProgress({
    required String studentId,
    required String lessonId,
  }) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'lesson_progress',
      where: 'student_id = ? AND lesson_id = ?',
      whereArgs: [studentId, lessonId],
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<void> saveLessonProgress({
    required String studentId,
    required String lessonId,
    required int lastSlideIndex,
    required bool isCompleted,
  }) async {
    final db = await _dbHelper.database;
    await db.insert(
      'lesson_progress',
      {
        'id': '${studentId}_$lessonId',
        'student_id': studentId,
        'lesson_id': lessonId,
        'last_slide_index': lastSlideIndex,
        'is_completed': isCompleted ? 1 : 0,
        'completed_at': isCompleted ? DateTime.now().toIso8601String() : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isLessonBookmarked({
    required String studentId,
    required String lessonId,
  }) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'bookmarks',
      where: 'student_id = ? AND lesson_id = ?',
      whereArgs: [studentId, lessonId],
    );
    return rows.isNotEmpty;
  }

  Future<bool> toggleBookmark({
    required String studentId,
    required String lessonId,
  }) async {
    final db = await _dbHelper.database;
    final isBookmarked = await isLessonBookmarked(studentId: studentId, lessonId: lessonId);

    if (isBookmarked) {
      await db.delete(
        'bookmarks',
        where: 'student_id = ? AND lesson_id = ?',
        whereArgs: [studentId, lessonId],
      );
      return false;
    } else {
      await db.insert('bookmarks', {
        'id': '${studentId}_$lessonId',
        'student_id': studentId,
        'lesson_id': lessonId,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    }
  }

  Future<List<Map<String, dynamic>>> getContentPacks() async {
    final db = await _dbHelper.database;
    return await db.query('content_packs', orderBy: 'installed_at DESC');
  }
}
