// Domain models for ShikshaEdge offline-first architecture

class Student {
  final String id;
  final String name;
  final String classId;
  final String preferredLanguage; // 'en', 'kn', 'hi'
  final String avatarId;
  final String? classroomCode;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  Student({
    required this.id,
    required this.name,
    required this.classId,
    required this.preferredLanguage,
    required this.avatarId,
    this.classroomCode,
    required this.createdAt,
    required this.lastActiveAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'class_id': classId,
      'preferred_language': preferredLanguage,
      'avatar_id': avatarId,
      'classroom_code': classroomCode,
      'created_at': createdAt.toIso8601String(),
      'last_active_at': lastActiveAt.toIso8601String(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      classId: map['class_id'] as String,
      preferredLanguage: map['preferred_language'] as String,
      avatarId: map['avatar_id'] as String,
      classroomCode: map['classroom_code'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      lastActiveAt: DateTime.parse(map['last_active_at'] as String),
    );
  }

  Student copyWith({
    String? name,
    String? classId,
    String? preferredLanguage,
    String? avatarId,
    String? classroomCode,
    DateTime? lastActiveAt,
  }) {
    return Student(
      id: id,
      name: name ?? this.name,
      classId: classId ?? this.classId,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      avatarId: avatarId ?? this.avatarId,
      classroomCode: classroomCode ?? this.classroomCode,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
}

class Subject {
  final String id;
  final String classId;
  final String name;
  final String nameKn;
  final String iconName;
  final String colorHex;
  final int orderIndex;

  Subject({
    required this.id,
    required this.classId,
    required this.name,
    required this.nameKn,
    required this.iconName,
    required this.colorHex,
    required this.orderIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'class_id': classId,
      'name': name,
      'name_kn': nameKn,
      'icon_name': iconName,
      'color_hex': colorHex,
      'order_index': orderIndex,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] as String,
      classId: map['class_id'] as String,
      name: map['name'] as String,
      nameKn: map['name_kn'] as String,
      iconName: map['icon_name'] as String,
      colorHex: map['color_hex'] as String,
      orderIndex: (map['order_index'] as num).toInt(),
    );
  }
}

class Topic {
  final String id;
  final String subjectId;
  final String title;
  final String titleKn;
  final String description;
  final String descriptionKn;
  final int orderIndex;

  Topic({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.titleKn,
    required this.description,
    required this.descriptionKn,
    required this.orderIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject_id': subjectId,
      'title': title,
      'title_kn': titleKn,
      'description': description,
      'description_kn': descriptionKn,
      'order_index': orderIndex,
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'] as String,
      subjectId: map['subject_id'] as String,
      title: map['title'] as String,
      titleKn: map['title_kn'] as String,
      description: (map['description'] as String?) ?? '',
      descriptionKn: (map['description_kn'] as String?) ?? '',
      orderIndex: (map['order_index'] as num).toInt(),
    );
  }
}

class Skill {
  final String id;
  final String topicId;
  final String name;
  final String nameKn;
  final double initialMastery;

  Skill({
    required this.id,
    required this.topicId,
    required this.name,
    required this.nameKn,
    this.initialMastery = 0.30,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic_id': topicId,
      'name': name,
      'name_kn': nameKn,
      'initial_mastery': initialMastery,
    };
  }

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      id: map['id'] as String,
      topicId: map['topic_id'] as String,
      name: map['name'] as String,
      nameKn: map['name_kn'] as String,
      initialMastery: (map['initial_mastery'] as num?)?.toDouble() ?? 0.30,
    );
  }
}

class Lesson {
  final String id;
  final String topicId;
  final String skillId;
  final String title;
  final String titleKn;
  final String contentJson;
  final String? audioEnPath;
  final String? audioKnPath;
  final int orderIndex;

  Lesson({
    required this.id,
    required this.topicId,
    required this.skillId,
    required this.title,
    required this.titleKn,
    required this.contentJson,
    this.audioEnPath,
    this.audioKnPath,
    this.orderIndex = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic_id': topicId,
      'skill_id': skillId,
      'title': title,
      'title_kn': titleKn,
      'content_json': contentJson,
      'audio_en_path': audioEnPath,
      'audio_kn_path': audioKnPath,
      'order_index': orderIndex,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as String,
      topicId: map['topic_id'] as String,
      skillId: map['skill_id'] as String,
      title: map['title'] as String,
      titleKn: map['title_kn'] as String,
      contentJson: map['content_json'] as String,
      audioEnPath: map['audio_en_path'] as String?,
      audioKnPath: map['audio_kn_path'] as String?,
      orderIndex: (map['order_index'] as num?)?.toInt() ?? 1,
    );
  }
}

class QuestionOption {
  final String id;
  final String questionId;
  final String optionText;
  final String optionTextKn;
  final bool isCorrect;
  final int orderIndex;

  QuestionOption({
    required this.id,
    required this.questionId,
    required this.optionText,
    required this.optionTextKn,
    required this.isCorrect,
    required this.orderIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_id': questionId,
      'option_text': optionText,
      'option_text_kn': optionTextKn,
      'is_correct': isCorrect ? 1 : 0,
      'order_index': orderIndex,
    };
  }

  factory QuestionOption.fromMap(Map<String, dynamic> map) {
    return QuestionOption(
      id: map['id'] as String,
      questionId: map['question_id'] as String,
      optionText: map['option_text'] as String,
      optionTextKn: map['option_text_kn'] as String,
      isCorrect: (map['is_correct'] as int) == 1,
      orderIndex: (map['order_index'] as num).toInt(),
    );
  }
}

class Question {
  final String id;
  final String topicId;
  final String skillId;
  final String difficulty; // 'easy', 'medium', 'hard'
  final String questionText;
  final String questionTextKn;
  final String? illustrationType;
  final String? illustrationData;
  final String explanation;
  final String explanationKn;
  final String hint;
  final String hintKn;
  final String? audioEnPath;
  final String? audioKnPath;
  final List<QuestionOption> options;

  Question({
    required this.id,
    required this.topicId,
    required this.skillId,
    required this.difficulty,
    required this.questionText,
    required this.questionTextKn,
    this.illustrationType,
    this.illustrationData,
    required this.explanation,
    required this.explanationKn,
    required this.hint,
    required this.hintKn,
    this.audioEnPath,
    this.audioKnPath,
    this.options = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic_id': topicId,
      'skill_id': skillId,
      'difficulty': difficulty,
      'question_text': questionText,
      'question_text_kn': questionTextKn,
      'illustration_type': illustrationType,
      'illustration_data': illustrationData,
      'explanation': explanation,
      'explanation_kn': explanationKn,
      'hint': hint,
      'hint_kn': hintKn,
      'audio_en_path': audioEnPath,
      'audio_kn_path': audioKnPath,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map, [List<QuestionOption> options = const []]) {
    return Question(
      id: map['id'] as String,
      topicId: map['topic_id'] as String,
      skillId: map['skill_id'] as String,
      difficulty: map['difficulty'] as String,
      questionText: map['question_text'] as String,
      questionTextKn: map['question_text_kn'] as String,
      illustrationType: map['illustration_type'] as String?,
      illustrationData: map['illustration_data'] as String?,
      explanation: map['explanation'] as String,
      explanationKn: map['explanation_kn'] as String,
      hint: map['hint'] as String,
      hintKn: map['hint_kn'] as String,
      audioEnPath: map['audio_en_path'] as String?,
      audioKnPath: map['audio_kn_path'] as String?,
      options: options,
    );
  }
}

class Attempt {
  final String id;
  final String studentId;
  final String questionId;
  final String topicId;
  final String skillId;
  final String selectedOptionId;
  final bool isCorrect;
  final String difficulty;
  final double masteryBefore;
  final double masteryAfter;
  final DateTime answeredAt;
  final DateTime createdAt;

  Attempt({
    required this.id,
    required this.studentId,
    required this.questionId,
    required this.topicId,
    required this.skillId,
    required this.selectedOptionId,
    required this.isCorrect,
    required this.difficulty,
    required this.masteryBefore,
    required this.masteryAfter,
    required this.answeredAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'question_id': questionId,
      'topic_id': topicId,
      'skill_id': skillId,
      'selected_option_id': selectedOptionId,
      'is_correct': isCorrect ? 1 : 0,
      'difficulty': difficulty,
      'mastery_before': masteryBefore,
      'mastery_after': masteryAfter,
      'answered_at': answeredAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Attempt.fromMap(Map<String, dynamic> map) {
    return Attempt(
      id: map['id'] as String,
      studentId: map['student_id'] as String,
      questionId: map['question_id'] as String,
      topicId: map['topic_id'] as String,
      skillId: map['skill_id'] as String,
      selectedOptionId: map['selected_option_id'] as String,
      isCorrect: (map['is_correct'] as int) == 1,
      difficulty: map['difficulty'] as String,
      masteryBefore: (map['mastery_before'] as num).toDouble(),
      masteryAfter: (map['mastery_after'] as num).toDouble(),
      answeredAt: DateTime.parse(map['answered_at'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

class MasteryRecord {
  final String id;
  final String studentId;
  final String skillId;
  final double masteryProbability;
  final int attemptsCount;
  final int correctCount;
  final DateTime lastUpdatedAt;

  MasteryRecord({
    required this.id,
    required this.studentId,
    required this.skillId,
    required this.masteryProbability,
    required this.attemptsCount,
    required this.correctCount,
    required this.lastUpdatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'skill_id': skillId,
      'mastery_probability': masteryProbability,
      'attempts_count': attemptsCount,
      'correct_count': correctCount,
      'last_updated_at': lastUpdatedAt.toIso8601String(),
    };
  }

  factory MasteryRecord.fromMap(Map<String, dynamic> map) {
    return MasteryRecord(
      id: map['id'] as String,
      studentId: map['student_id'] as String,
      skillId: map['skill_id'] as String,
      masteryProbability: (map['mastery_probability'] as num).toDouble(),
      attemptsCount: (map['attempts_count'] as int?) ?? 0,
      correctCount: (map['correct_count'] as int?) ?? 0,
      lastUpdatedAt: DateTime.parse(map['last_updated_at'] as String),
    );
  }
}

class SyncQueueItem {
  final String id;
  final String entityType; // 'attempt', 'mastery', 'student_profile', 'lesson_progress'
  final String entityId;
  final String payloadJson;
  final DateTime createdAt;
  final int retryCount;
  final DateTime? lastAttemptAt;
  final String status; // 'pending', 'syncing', 'synced', 'failed'

  SyncQueueItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.payloadJson,
    required this.createdAt,
    this.retryCount = 0,
    this.lastAttemptAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'payload_json': payloadJson,
      'created_at': createdAt.toIso8601String(),
      'retry_count': retryCount,
      'last_attempt_at': lastAttemptAt?.toIso8601String(),
      'status': status,
    };
  }

  factory SyncQueueItem.fromMap(Map<String, dynamic> map) {
    return SyncQueueItem(
      id: map['id'] as String,
      entityType: map['entity_type'] as String,
      entityId: map['entity_id'] as String,
      payloadJson: map['payload_json'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      retryCount: (map['retry_count'] as int?) ?? 0,
      lastAttemptAt: map['last_attempt_at'] != null ? DateTime.parse(map['last_attempt_at'] as String) : null,
      status: (map['status'] as String?) ?? 'pending',
    );
  }
}
