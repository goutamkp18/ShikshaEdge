import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const String keySupabaseUrl = 'supabase_url';
  static const String keySupabaseAnonKey = 'supabase_anon_key';
  static const String keyActiveStudentId = 'active_student_id';
  static const String keyDarkMode = 'dark_mode';
  static const String keyLanguage = 'selected_language';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyCloudOwnerId = 'cloud_owner_id';
  static const String keyPersistedSession = 'persisted_supabase_session';

  // Configured Supabase backend for TEAMAPEX
  static const String defaultSupabaseUrl = 'https://ckvjmsctfuzhykxxjqbh.supabase.co';
  static const String defaultSupabaseAnonKey = 'sb_publishable_EKnrIqc-Eh45NmtQtjHRpA_LEWg2Xkn';

  static Future<String?> getSavedSupabaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keySupabaseUrl) ?? defaultSupabaseUrl;
  }

  static Future<String?> getSavedSupabaseAnonKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keySupabaseAnonKey) ?? defaultSupabaseAnonKey;
  }

  static Future<void> saveSupabaseCredentials({
    required String url,
    required String anonKey,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keySupabaseUrl, url);
    await prefs.setString(keySupabaseAnonKey, anonKey);
  }

  static Future<String?> getSavedCloudOwnerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyCloudOwnerId);
  }

  static Future<void> saveCloudOwnerId(String ownerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyCloudOwnerId, ownerId);
  }

  static Future<String?> getSavedPersistedSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyPersistedSession);
  }

  static Future<void> savePersistedSession(String sessionJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyPersistedSession, sessionJson);
  }

  static Future<void> clearPersistedSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyPersistedSession);
  }
}
