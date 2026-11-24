import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../models/models.dart';
import '../../repositories/progress_repository.dart';
import '../../services/synchronization/sync_service.dart';
import '../../shared/providers/app_providers.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final studentAsync = ref.watch(activeStudentProvider);
    final contentRepo = ref.watch(contentRepositoryProvider);
    final progressRepo = ref.watch(progressRepositoryProvider);
    final syncService = ref.watch(syncServiceProvider);

    return Scaffold(
      body: SafeArea(
        child: studentAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error loading profile: $err')),
          data: (student) {
            if (student == null) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => context.go('/register'),
                  child: Text(loc.translate('create_profile')),
                ),
              );
            }

            return FutureBuilder<List<dynamic>>(
              future: Future.wait([
                contentRepo.getSubjectsForClass(student.classId),
                progressRepo.getAnalyticsForStudent(student.id),
                syncService.getSyncState(),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final subjects = (snapshot.data?[0] as List<Subject>?) ?? [];
                final analytics = snapshot.data?[1] as StudentAnalytics?;
                final syncResult = snapshot.data?[2] as SyncResult?;

                final overallMasteryPercent = ((analytics?.overallMastery ?? 0.30) * 100).toInt();
                final streak = analytics?.streakDays ?? 0;

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(activeStudentProvider.notifier).refresh();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Bar: Avatar, Name, Class & Sync Status
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.primaryIndigo.withOpacity(0.12),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primaryIndigo, width: 1.5),
                              ),
                              child: Center(
                                child: Text(
                                  _getAvatarEmoji(student.avatarId),
                                  style: const TextStyle(fontSize: 26),
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
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${student.classId.toUpperCase().replaceAll('_', ' ')} • ${_getLanguageLabel(student.preferredLanguage)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.secondaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Sync status pill
                            _buildSyncBadge(syncResult),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Continue Learning Hero Card
                        _buildContinueLearningCard(context, loc, student),
                        const SizedBox(height: 20),

                        // Stats Summary Row (Streak & Overall Mastery)
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.local_fire_department_rounded,
                                iconColor: AppColors.warmYellow,
                                value: '$streak Days',
                                label: loc.translate('streak'),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.psychology_rounded,
                                iconColor: AppColors.primaryIndigo,
                                value: '$overallMasteryPercent%',
                                label: loc.translate('mastery'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Quick Practice Quiz Card
                        _buildQuickQuizCard(context, loc),
                        const SizedBox(height: 24),

                        // Subjects Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              loc.translate('subjects'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${subjects.length} Available',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.secondaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Subject List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subjects.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final sub = subjects[index];
                            return _buildSubjectCard(context, sub, student.preferredLanguage);
                          },
                        ),
                        const SizedBox(height: 24),

                        // Adaptive AI Demonstration Callout
                        _buildDevDemoCallout(context, loc),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSyncBadge(SyncResult? sync) {
    Color bg = const Color(0xFFF1F5F9);
    Color fg = AppColors.secondaryText;
    IconData icon = Icons.cloud_off_rounded;
    String text = 'Offline';

    if (sync != null) {
      switch (sync.status) {
        case SyncStatus.offline:
          bg = const Color(0xFFEFF6FF);
          fg = AppColors.skyBlue;
          icon = Icons.cloud_off_rounded;
          text = 'Offline';
          break;
        case SyncStatus.pending:
          bg = const Color(0xFFFFFBEB);
          fg = AppColors.warmYellow;
          icon = Icons.sync_problem_rounded;
          text = '${sync.pendingCount} Pending';
          break;
        case SyncStatus.synced:
          bg = const Color(0xFFF0FDF4);
          fg = AppColors.successGreen;
          icon = Icons.cloud_done_rounded;
          text = 'Synced';
          break;
        case SyncStatus.syncing:
          bg = const Color(0xFFEEF2FF);
          fg = AppColors.primaryIndigo;
          icon = Icons.sync_rounded;
          text = 'Syncing...';
          break;
        case SyncStatus.failed:
          bg = const Color(0xFFFEF2F2);
          fg = AppColors.errorRed;
          icon = Icons.error_outline_rounded;
          text = 'Sync Error';
          break;
        case SyncStatus.unconfigured:
          bg = const Color(0xFFF8FAFC);
          fg = AppColors.secondaryText;
          icon = Icons.offline_pin_rounded;
          text = 'Offline DB';
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueLearningCard(BuildContext context, AppLocalizations loc, Student student) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryIndigo, AppColors.deepIndigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryIndigo.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'CONTINUE LEARNING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Multiplication: Equal Groups',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Understand repeated addition with diagrams and audio.',
            style: TextStyle(
              color: Color(0xFFC7D2FE),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryIndigo,
              minimumSize: const Size(double.infinity, 44),
            ),
            onPressed: () {
              context.push('/lesson/lesson_mult_1');
            },
            icon: const Icon(Icons.play_circle_fill_rounded, size: 20),
            label: Text(
              loc.translate('read_lesson'),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickQuizCard(BuildContext context, AppLocalizations loc) {
    return InkWell(
      onTap: () {
        context.push('/quiz/math_mult');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFA7F3D0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.successGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.translate('start_quiz'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF065F46),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Multiplication • Offline Adaptive AI',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF047857),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.successGreen, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Subject subject, String lang) {
    Color cardColor = AppColors.primaryIndigo;
    try {
      cardColor = Color(int.parse(subject.colorHex.replaceFirst('#', '0xFF')));
    } catch (_) {}

    final title = lang == 'kn' ? subject.nameKn : subject.name;

    return InkWell(
      onTap: () {
        context.push('/subject/${subject.id}', extra: subject);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  _getSubjectIcon(subject.iconName),
                  color: cardColor,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Topics • Lessons • Quizzes',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  Widget _buildDevDemoCallout(BuildContext context, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology_outlined, color: AppColors.primaryIndigo, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bayesian Knowledge Tracing (BKT)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Offline adaptive difficulty runs entirely on your phone.',
                  style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.push('/progress');
            },
            child: const Text('View BKT'),
          ),
        ],
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

  String _getLanguageLabel(String code) {
    switch (code) {
      case 'kn': return 'ಕನ್ನಡ';
      case 'hi': return 'हिन्दी';
      default: return 'English';
    }
  }

  IconData _getSubjectIcon(String icon) {
    switch (icon) {
      case 'calculate': return Icons.calculate_rounded;
      case 'science': return Icons.biotech_rounded;
      case 'menu_book': return Icons.menu_book_rounded;
      case 'translate': return Icons.translate_rounded;
      default: return Icons.school_rounded;
    }
  }
}
