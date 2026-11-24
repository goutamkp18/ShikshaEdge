import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shikshaedge.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _createDB,
    );
  }

  Future<void> _onConfigure(Database db) async {
    // Enable foreign key constraints
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. students
    await db.execute('''
      CREATE TABLE students (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        class_id TEXT NOT NULL,
        preferred_language TEXT NOT NULL,
        avatar_id TEXT NOT NULL,
        classroom_code TEXT,
        created_at TEXT NOT NULL,
        last_active_at TEXT NOT NULL
      )
    ''');

    // 2. classes
    await db.execute('''
      CREATE TABLE classes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        grade_level INTEGER NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // 3. subjects
    await db.execute('''
      CREATE TABLE subjects (
        id TEXT PRIMARY KEY,
        class_id TEXT NOT NULL,
        name TEXT NOT NULL,
        name_kn TEXT NOT NULL,
        icon_name TEXT NOT NULL,
        color_hex TEXT NOT NULL,
        order_index INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE
      )
    ''');

    // 4. topics
    await db.execute('''
      CREATE TABLE topics (
        id TEXT PRIMARY KEY,
        subject_id TEXT NOT NULL,
        title TEXT NOT NULL,
        title_kn TEXT NOT NULL,
        description TEXT,
        description_kn TEXT,
        order_index INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
      )
    ''');

    // 5. skills
    await db.execute('''
      CREATE TABLE skills (
        id TEXT PRIMARY KEY,
        topic_id TEXT NOT NULL,
        name TEXT NOT NULL,
        name_kn TEXT NOT NULL,
        initial_mastery REAL DEFAULT 0.30,
        FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE CASCADE
      )
    ''');

    // 6. skill_prerequisites
    await db.execute('''
      CREATE TABLE skill_prerequisites (
        id TEXT PRIMARY KEY,
        skill_id TEXT NOT NULL,
        prerequisite_skill_id TEXT NOT NULL,
        FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
        FOREIGN KEY (prerequisite_skill_id) REFERENCES skills(id) ON DELETE CASCADE
      )
    ''');

    // 7. lessons
    await db.execute('''
      CREATE TABLE lessons (
        id TEXT PRIMARY KEY,
        topic_id TEXT NOT NULL,
        skill_id TEXT NOT NULL,
        title TEXT NOT NULL,
        title_kn TEXT NOT NULL,
        content_json TEXT NOT NULL,
        audio_en_path TEXT,
        audio_kn_path TEXT,
        order_index INTEGER DEFAULT 0,
        FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE CASCADE,
        FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE
      )
    ''');

    // 8. questions
    await db.execute('''
      CREATE TABLE questions (
        id TEXT PRIMARY KEY,
        topic_id TEXT NOT NULL,
        skill_id TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        question_text TEXT NOT NULL,
        question_text_kn TEXT NOT NULL,
        illustration_type TEXT,
        illustration_data TEXT,
        explanation TEXT NOT NULL,
        explanation_kn TEXT NOT NULL,
        hint TEXT NOT NULL,
        hint_kn TEXT NOT NULL,
        audio_en_path TEXT,
        audio_kn_path TEXT,
        FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE CASCADE,
        FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE
      )
    ''');

    // 9. question_options
    await db.execute('''
      CREATE TABLE question_options (
        id TEXT PRIMARY KEY,
        question_id TEXT NOT NULL,
        option_text TEXT NOT NULL,
        option_text_kn TEXT NOT NULL,
        is_correct INTEGER NOT NULL,
        order_index INTEGER NOT NULL,
        FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
      )
    ''');

    // 10. attempts
    await db.execute('''
      CREATE TABLE attempts (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        question_id TEXT NOT NULL,
        topic_id TEXT NOT NULL,
        skill_id TEXT NOT NULL,
        selected_option_id TEXT NOT NULL,
        is_correct INTEGER NOT NULL,
        difficulty TEXT NOT NULL,
        mastery_before REAL NOT NULL,
        mastery_after REAL NOT NULL,
        answered_at TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
        FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
      )
    ''');

    // 11. mastery
    await db.execute('''
      CREATE TABLE mastery (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        skill_id TEXT NOT NULL,
        mastery_probability REAL NOT NULL,
        attempts_count INTEGER NOT NULL DEFAULT 0,
        correct_count INTEGER NOT NULL DEFAULT 0,
        last_updated_at TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
        FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
        UNIQUE(student_id, skill_id)
      )
    ''');

    // 12. mastery_history
    await db.execute('''
      CREATE TABLE mastery_history (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        skill_id TEXT NOT NULL,
        attempt_id TEXT,
        mastery_probability REAL NOT NULL,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
        FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE
      )
    ''');

    // 13. lesson_progress
    await db.execute('''
      CREATE TABLE lesson_progress (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        lesson_id TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        last_slide_index INTEGER NOT NULL DEFAULT 0,
        completed_at TEXT,
        FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
        FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
        UNIQUE(student_id, lesson_id)
      )
    ''');

    // 14. bookmarks
    await db.execute('''
      CREATE TABLE bookmarks (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        lesson_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
        FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
        UNIQUE(student_id, lesson_id)
      )
    ''');

    // 15. content_packs
    await db.execute('''
      CREATE TABLE content_packs (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        class_id TEXT NOT NULL,
        version TEXT NOT NULL,
        installed_at TEXT NOT NULL,
        is_bundled INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // 16. sync_queue
    await db.execute('''
      CREATE TABLE sync_queue (
        id TEXT PRIMARY KEY,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        created_at TEXT NOT NULL,
        retry_count INTEGER NOT NULL DEFAULT 0,
        last_attempt_at TEXT,
        status TEXT NOT NULL DEFAULT 'pending'
      )
    ''');

    // Indexes for high performance on low-end smartphones
    await db.execute('CREATE INDEX idx_attempts_student ON attempts(student_id);');
    await db.execute('CREATE INDEX idx_attempts_topic ON attempts(topic_id);');
    await db.execute('CREATE INDEX idx_mastery_student_skill ON mastery(student_id, skill_id);');
    await db.execute('CREATE INDEX idx_questions_topic ON questions(topic_id);');
    await db.execute('CREATE INDEX idx_questions_skill ON questions(skill_id);');
    await db.execute('CREATE INDEX idx_sync_queue_status ON sync_queue(status);');

    // Seed default supported classes (Class 5 to Class 10)
    for (int g = 5; g <= 10; g++) {
      await db.insert('classes', {
        'id': 'class_$g',
        'name': 'Class $g',
        'grade_level': g,
        'is_active': g == 6 ? 1 : 0, // Class 6 is prioritized for MVP
      });
    }
  }

  // Load and seed bundled content pack from assets without duplicates
  Future<void> seedInitialContentPack() async {
    final db = await database;

    final existing = await db.query(
      'content_packs',
      where: 'id = ?',
      whereArgs: ['pack_class_6_v1'],
    );
    if (existing.isNotEmpty) {
      // Already installed
      return;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/content/class_6_default_pack.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      await db.transaction((txn) async {
        // Record content pack
        await txn.insert('content_packs', {
          'id': data['pack_id'],
          'name': data['name'],
          'class_id': data['class_id'],
          'version': data['version'],
          'installed_at': DateTime.now().toIso8601String(),
          'is_bundled': 1,
        }, conflictAlgorithm: ConflictAlgorithm.replace);

        final subjects = data['subjects'] as List<dynamic>;
        for (var s in subjects) {
          await txn.insert('subjects', {
            'id': s['id'],
            'class_id': s['class_id'],
            'name': s['name'],
            'name_kn': s['name_kn'],
            'icon_name': s['icon_name'],
            'color_hex': s['color_hex'],
            'order_index': s['order_index'],
          }, conflictAlgorithm: ConflictAlgorithm.replace);

          final topics = s['topics'] as List<dynamic>;
          for (var t in topics) {
            await txn.insert('topics', {
              'id': t['id'],
              'subject_id': t['subject_id'],
              'title': t['title'],
              'title_kn': t['title_kn'],
              'description': t['description'] ?? '',
              'description_kn': t['description_kn'] ?? '',
              'order_index': t['order_index'],
            }, conflictAlgorithm: ConflictAlgorithm.replace);

            // Skills
            if (t['skills'] != null) {
              for (var sk in t['skills']) {
                await txn.insert('skills', {
                  'id': sk['id'],
                  'topic_id': t['id'],
                  'name': sk['name'],
                  'name_kn': sk['name_kn'],
                  'initial_mastery': sk['initial_mastery'] ?? 0.30,
                }, conflictAlgorithm: ConflictAlgorithm.replace);
              }
            }

            // Prerequisites
            if (t['prerequisites'] != null) {
              for (var pr in t['prerequisites']) {
                await txn.insert('skill_prerequisites', {
                  'id': '${pr['skill_id']}_${pr['prerequisite_skill_id']}',
                  'skill_id': pr['skill_id'],
                  'prerequisite_skill_id': pr['prerequisite_skill_id'],
                }, conflictAlgorithm: ConflictAlgorithm.replace);
              }
            }

            // Lessons
            if (t['lessons'] != null) {
              for (var l in t['lessons']) {
                await txn.insert('lessons', {
                  'id': l['id'],
                  'topic_id': l['topic_id'],
                  'skill_id': l['skill_id'],
                  'title': l['title'],
                  'title_kn': l['title_kn'],
                  'content_json': json.encode(l['slides']),
                  'audio_en_path': l['audio_en_path'],
                  'audio_kn_path': l['audio_kn_path'],
                  'order_index': l['order_index'] ?? 1,
                }, conflictAlgorithm: ConflictAlgorithm.replace);
              }
            }

            // Questions & Options
            if (t['questions'] != null) {
              for (var q in t['questions']) {
                await txn.insert('questions', {
                  'id': q['id'],
                  'topic_id': q['topic_id'],
                  'skill_id': q['skill_id'],
                  'difficulty': q['difficulty'],
                  'question_text': q['question_text'],
                  'question_text_kn': q['question_text_kn'],
                  'illustration_type': q['illustration_type'],
                  'illustration_data': q['illustration_data'],
                  'explanation': q['explanation'],
                  'explanation_kn': q['explanation_kn'],
                  'hint': q['hint'],
                  'hint_kn': q['hint_kn'],
                  'audio_en_path': q['audio_en_path'],
                  'audio_kn_path': q['audio_kn_path'],
                }, conflictAlgorithm: ConflictAlgorithm.replace);

                if (q['options'] != null) {
                  int optIdx = 0;
                  for (var opt in q['options']) {
                    await txn.insert('question_options', {
                      'id': opt['id'],
                      'question_id': q['id'],
                      'option_text': opt['text'],
                      'option_text_kn': opt['text_kn'],
                      'is_correct': opt['is_correct'] == true ? 1 : 0,
                      'order_index': optIdx++,
                    }, conflictAlgorithm: ConflictAlgorithm.replace);
                  }
                }
              }
            }
          }
        }
      });
    } catch (e) {
      // Content seeding will fail silently or be retried if asset unbundled
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
