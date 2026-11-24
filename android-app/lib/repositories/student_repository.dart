import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../core/config/app_config.dart';
import '../core/database/database_helper.dart';
import '../models/models.dart';

class StudentRepository {
  final DatabaseHelper _dbHelper;
  final Uuid _uuid = const Uuid();

  StudentRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<Student>> getAllStudents() async {
    final db = await _dbHelper.database;
    final rows = await db.query('students', orderBy: 'last_active_at DESC');
    return rows.map((r) => Student.fromMap(r)).toList();
  }

  Future<Student?> getActiveStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final activeId = prefs.getString(AppConfig.keyActiveStudentId);

    final db = await _dbHelper.database;
    if (activeId != null) {
      final rows = await db.query(
        'students',
        where: 'id = ?',
        whereArgs: [activeId],
      );
      if (rows.isNotEmpty) {
        return Student.fromMap(rows.first);
      }
    }

    // Fallback: pick the most recently active student if any exists
    final all = await getAllStudents();
    if (all.isNotEmpty) {
      await setActiveStudent(all.first.id);
      return all.first;
    }
    return null;
  }

  Future<void> setActiveStudent(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.keyActiveStudentId, studentId);

    final db = await _dbHelper.database;
    await db.update(
      'students',
      {'last_active_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [studentId],
    );
  }

  Future<Student> createStudent({
    required String name,
    required String classId,
    required String preferredLanguage,
    required String avatarId,
    String? classroomCode,
  }) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final student = Student(
      id: _uuid.v4(),
      name: name.trim(),
      classId: classId,
      preferredLanguage: preferredLanguage,
      avatarId: avatarId,
      classroomCode: classroomCode?.trim().isNotEmpty == true ? classroomCode!.trim() : null,
      createdAt: now,
      lastActiveAt: now,
    );

    await db.insert('students', student.toMap());
    await setActiveStudent(student.id);

    // Save language preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.keyLanguage, preferredLanguage);

    return student;
  }

  Future<void> updateStudent(Student student) async {
    final db = await _dbHelper.database;
    await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }
}
