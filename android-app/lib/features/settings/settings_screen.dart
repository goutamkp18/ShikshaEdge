import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../models/models.dart';
import '../../services/synchronization/sync_service.dart';
import '../../shared/providers/app_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isSyncing = false;

  Future<void> _triggerManualSync() async {
    setState(() => _isSyncing = true);
    final syncService = ref.read(syncServiceProvider);
    final result = await syncService.synchronize();

    if (!mounted) return;
    setState(() => _isSyncing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: result.status == SyncStatus.synced ? AppColors.successGreen : AppColors.errorRed,
      ),
    );
  }

  void _showSwitchStudentDialog(List<Student> allStudents, Student? current) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Switch Student Profile'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: allStudents.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, idx) {
              final s = allStudents[idx];
              final isCurrent = s.id == current?.id;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryIndigo.withOpacity(0.12),
                  child: Text(_getAvatarEmoji(s.avatarId)),
                ),
                title: Text(s.name, style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
                subtitle: Text('${s.classId.toUpperCase()} • ${s.preferredLanguage.toUpperCase()}'),
                trailing: isCurrent ? const Icon(Icons.check_circle_rounded, color: AppColors.successGreen) : null,
                onTap: () async {
                  await ref.read(activeStudentProvider.notifier).selectStudent(s.id);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.push('/register');
            },
            child: const Text('+ Add New Student'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final student = ref.watch(activeStudentProvider).value;
    final studentRepo = ref.watch(studentRepositoryProvider);
    final themeMode = ref.watch(themeModeProvider);
    final syncService = ref.watch(syncServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('settings')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Header Card
            if (student != null)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primaryIndigo.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getAvatarEmoji(student.avatarId),
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${student.classId.toUpperCase()} • ID: ${student.id.substring(0, 8)}...',
                            style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onPressed: () async {
                        final all = await studentRepo.getAllStudents();
                        _showSwitchStudentDialog(all, student);
                      },
                      child: const Text('Switch', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Preferences Section
            const Text(
              'App Preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  // Language Setting
                  ListTile(
                    leading: const Icon(Icons.language_rounded, color: AppColors.primaryIndigo),
                    title: const Text('Learning Language'),
                    subtitle: Text(student?.preferredLanguage == 'kn' ? 'ಕನ್ನಡ (Kannada)' : 'English'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showLanguageSelector(student),
                  ),
                  const Divider(height: 1),
                  // Dark Mode Setting
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primaryIndigo),
                    title: const Text('Dark Theme'),
                    subtitle: const Text('Comfortable night reading'),
                    value: themeMode == ThemeMode.dark,
                    onChanged: (val) {
                      ref.read(themeModeProvider.notifier).toggleTheme();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Content & Storage Section
            const Text(
              'Offline Storage & Curriculum',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.inventory_2_outlined, color: AppColors.primaryIndigo),
                    title: const Text('Offline Learning Packs'),
                    subtitle: const Text('Manage bundled & downloaded lessons'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      context.push('/content-packs');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.storage_rounded, color: AppColors.primaryIndigo),
                    title: const Text('Local SQLite Database'),
                    subtitle: const Text('shikshaedge.db • Healthy & Encrypted'),
                    trailing: const Icon(Icons.check_circle_rounded, color: AppColors.successGreen, size: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Backend Synchronization Section
            const Text(
              'Cloud Synchronization',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            FutureBuilder<SyncResult>(
              future: syncService.getSyncState(),
              builder: (context, snapshot) {
                final state = snapshot.data;
                final pending = state?.pendingCount ?? 0;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.cloud_sync_rounded, color: AppColors.primaryIndigo, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state?.message ?? 'Sync queue operational.',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Queue contains $pending pending attempt records.',
                                  style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryIndigo,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isSyncing ? null : _triggerManualSync,
                          icon: _isSyncing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.cloud_sync_rounded, size: 20),
                          label: Text(
                            _isSyncing ? 'Syncing...' : 'Sync Progress Now',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            // About & Credits Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ShikshaEdge • TEAMAPEX',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primaryText),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'wHACKiest 2026 • Track 4: UnlockED\nLow-Bandwidth Adaptive Learning for Rural Schools.\nOffline Bayesian Knowledge Tracing Engine powered by Google Antigravity.',
                    style: TextStyle(fontSize: 12, height: 1.5, color: AppColors.secondaryText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(Student? student) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Preferred Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('English'),
              onTap: () async {
                await ref.read(localeProvider.notifier).setLocale('en');
                if (student != null) {
                  await ref.read(studentRepositoryProvider).updateStudent(
                    student.copyWith(preferredLanguage: 'en'),
                  );
                  ref.read(activeStudentProvider.notifier).refresh();
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('ಕನ್ನಡ (Kannada)'),
              onTap: () async {
                await ref.read(localeProvider.notifier).setLocale('kn');
                if (student != null) {
                  await ref.read(studentRepositoryProvider).updateStudent(
                    student.copyWith(preferredLanguage: 'kn'),
                  );
                  ref.read(activeStudentProvider.notifier).refresh();
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('हिन्दी (Hindi)'),
              onTap: () async {
                await ref.read(localeProvider.notifier).setLocale('hi');
                if (student != null) {
                  await ref.read(studentRepositoryProvider).updateStudent(
                    student.copyWith(preferredLanguage: 'hi'),
                  );
                  ref.read(activeStudentProvider.notifier).refresh();
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getAvatarEmoji(String id) {
    switch (id) {
      case 'avatar_owl': return '🦉';
      case 'avatar_lion': return '🦁';
      case 'avatar_elephant': return '🐘';
      case 'avatar_fox': return '🦊';
      case 'avatar_rocket': return '🚀';
      case 'avatar_star': return '🌟';
      default: return '🎓';
    }
  }
}
