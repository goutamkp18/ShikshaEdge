import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/app_config.dart';
import '../../core/database/database_helper.dart';
import '../../models/models.dart';
import '../../repositories/content_repository.dart';
import '../../repositories/progress_repository.dart';
import '../../repositories/student_repository.dart';
import '../../services/adaptive_learning/adaptive_quiz_service.dart';
import '../../services/adaptive_learning/bkt_engine.dart';
import '../../services/audio/audio_service.dart';
import '../../services/connectivity/connectivity_service.dart';
import '../../services/synchronization/sync_service.dart';

// Service & Repository singletons
final databaseHelperProvider = Provider<DatabaseHelper>((ref) => DatabaseHelper.instance);

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository(dbHelper: ref.watch(databaseHelperProvider));
});

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository(dbHelper: ref.watch(databaseHelperProvider));
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(dbHelper: ref.watch(databaseHelperProvider));
});

final bktEngineProvider = Provider<BktEngine>((ref) => const BktEngine());

final adaptiveQuizServiceProvider = Provider<AdaptiveQuizService>((ref) {
  return AdaptiveQuizService(
    dbHelper: ref.watch(databaseHelperProvider),
    bktEngine: ref.watch(bktEngineProvider),
  );
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    dbHelper: ref.watch(databaseHelperProvider),
    connectivity: ref.watch(connectivityServiceProvider),
  );
});

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Active Student State
class ActiveStudentNotifier extends StateNotifier<AsyncValue<Student?>> {
  final StudentRepository _repository;

  ActiveStudentNotifier(this._repository) : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> refresh() async {
    try {
      final student = await _repository.getActiveStudent();
      state = AsyncValue.data(student);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> selectStudent(String studentId) async {
    await _repository.setActiveStudent(studentId);
    await refresh();
  }

  Future<void> updateCurrentStudent(Student student) async {
    await _repository.updateStudent(student);
    state = AsyncValue.data(student);
  }
}

final activeStudentProvider = StateNotifierProvider<ActiveStudentNotifier, AsyncValue<Student?>>((ref) {
  return ActiveStudentNotifier(ref.watch(studentRepositoryProvider));
});

// Theme Mode State
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(AppConfig.keyDarkMode) ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConfig.keyDarkMode, newMode == ThemeMode.dark);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

// Locale State
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(AppConfig.keyLanguage) ?? 'en';
    state = Locale(code);
  }

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.keyLanguage, languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
