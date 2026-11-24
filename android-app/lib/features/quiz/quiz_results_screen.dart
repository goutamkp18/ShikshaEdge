import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../models/models.dart';
import '../../services/adaptive_learning/bkt_engine.dart';

class QuizResultsScreen extends ConsumerWidget {
  final String topicId;
  final List<Attempt> attempts;
  final BktCalculationResult? lastBkt;

  const QuizResultsScreen({
    super.key,
    required this.topicId,
    required this.attempts,
    this.lastBkt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final total = attempts.length;
    final correct = attempts.where((a) => a.isCorrect).length;
    final accuracy = total > 0 ? ((correct / total) * 100).toInt() : 0;

    final initialMastery = attempts.isNotEmpty ? attempts.first.masteryBefore : 0.30;
    final finalMastery = attempts.isNotEmpty ? attempts.last.masteryAfter : 0.30;
    final masteryChange = ((finalMastery - initialMastery) * 100);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('quiz_complete')),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Celebration Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryIndigo, AppColors.deepIndigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryIndigo.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        color: AppColors.warmYellow,
                        size: 56,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Session Completed!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'All student attempts & BKT updates saved to local SQLite.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Score Statistics Grid
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Accuracy',
                      value: '$accuracy%',
                      icon: Icons.track_changes_rounded,
                      color: AppColors.primaryIndigo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Correct / Total',
                      value: '$correct / $total',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.successGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Initial Mastery',
                      value: '${(initialMastery * 100).toInt()}%',
                      icon: Icons.timeline_rounded,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Current Mastery',
                      value: '${(finalMastery * 100).toInt()}%',
                      icon: Icons.psychology_rounded,
                      color: masteryChange >= 0 ? AppColors.successGreen : AppColors.errorRed,
                      badge: '${masteryChange >= 0 ? "+" : ""}${masteryChange.toStringAsFixed(1)}%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Recommendations Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_rounded, color: AppColors.warmYellow, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Learning Recommendation',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _getRecommendation(accuracy, finalMastery),
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Navigation Buttons
              ElevatedButton.icon(
                onPressed: () {
                  context.pushReplacement('/quiz/$topicId');
                },
                icon: const Icon(Icons.replay_rounded),
                label: Text(loc.translate('retry')),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  context.go('/home');
                },
                icon: const Icon(Icons.home_rounded),
                label: Text(loc.translate('back_to_home')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 2),
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
    );
  }

  String _getRecommendation(int accuracy, double mastery) {
    if (mastery > 0.75) {
      return 'Outstanding! You have reached Proficient mastery in this topic. Feel free to explore subsequent topics or take on Hard challenges.';
    } else if (mastery >= 0.40) {
      return 'Great progress! You are in the Developing tier. A little more practice with word problems will cement your understanding.';
    } else {
      return 'Good start! We recommend re-reading the lesson explanation or trying a few more foundational questions with audio explanations.';
    }
  }
}
