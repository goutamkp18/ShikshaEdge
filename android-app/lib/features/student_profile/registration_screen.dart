import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/providers/app_providers.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  String _selectedClass = 'class_6';
  String _selectedLanguage = 'en';
  String _selectedAvatar = 'avatar_owl';
  bool _isLoading = false;

  final List<Map<String, String>> _avatars = const [
    {'id': 'avatar_owl', 'label': '🦉 Wise Owl'},
    {'id': 'avatar_lion', 'label': '🦁 Brave Lion'},
    {'id': 'avatar_elephant', 'label': '🐘 Strong Elephant'},
    {'id': 'avatar_fox', 'label': '🦊 Quick Fox'},
    {'id': 'avatar_rocket', 'label': '🚀 Explorer'},
    {'id': 'avatar_star', 'label': '🌟 Bright Star'},
  ];

  final List<Map<String, String>> _classes = const [
    {'id': 'class_5', 'label': 'Class 5'},
    {'id': 'class_6', 'label': 'Class 6 (Recommended)'},
    {'id': 'class_7', 'label': 'Class 7'},
    {'id': 'class_8', 'label': 'Class 8'},
    {'id': 'class_9', 'label': 'Class 9'},
    {'id': 'class_10', 'label': 'Class 10'},
  ];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(studentRepositoryProvider);
      await repo.createStudent(
        name: _nameController.text,
        classId: _selectedClass,
        preferredLanguage: _selectedLanguage,
        avatarId: _selectedAvatar,
        classroomCode: _codeController.text,
      );

      // Update locale
      ref.read(localeProvider.notifier).setLocale(_selectedLanguage);
      await ref.read(activeStudentProvider.notifier).refresh();

      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('create_profile')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryIndigo.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryIndigo.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: AppColors.primaryIndigo, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '100% Offline Profile. No phone number or email required.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryIndigo.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Name field
                Text(
                  loc.translate('student_name'),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: loc.translate('enter_name'),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter student name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Select Class
                Text(
                  loc.translate('select_class'),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedClass,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.class_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  items: _classes.map((c) {
                    return DropdownMenuItem<String>(
                      value: c['id'],
                      child: Text(c['label']!),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedClass = val);
                  },
                ),
                const SizedBox(height: 20),

                // Preferred Language
                Text(
                  loc.translate('select_language'),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildLanguageChip('en', 'English'),
                    const SizedBox(width: 10),
                    _buildLanguageChip('kn', 'ಕನ್ನಡ'),
                    const SizedBox(width: 10),
                    _buildLanguageChip('hi', 'हिन्दी'),
                  ],
                ),
                const SizedBox(height: 20),

                // Avatar Selection
                Text(
                  loc.translate('select_avatar'),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _avatars.map((av) {
                    final isSelected = _selectedAvatar == av['id'];
                    return InkWell(
                      onTap: () => setState(() => _selectedAvatar = av['id']!),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryIndigo.withOpacity(0.12) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryIndigo : const Color(0xFFE2E8F0),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          av['label']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.primaryIndigo : AppColors.primaryText,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Optional Classroom Code
                Text(
                  loc.translate('classroom_code'),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: 'e.g. RURAL-KA-06',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.qr_code_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(loc.translate('save_profile')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageChip(String code, String label) {
    final isSelected = _selectedLanguage == code;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedLanguage = code),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryIndigo : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryIndigo : const Color(0xFFCBD5E1),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.primaryText,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
