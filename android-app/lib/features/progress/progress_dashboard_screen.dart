import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../repositories/progress_repository.dart';
import '../../shared/providers/app_providers.dart';

class ProgressDashboardScreen extends ConsumerWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final student = ref.watch(activeStudentProvider).value;
    final progressRepo = ref.watch(progressRepositoryProvider);

    if (student == null) {
      return const Scaffold(
        body: Center(child: Text('No active student profile.')),
      );
    }

    final lang = student.preferredLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('nav_progress')),
      ),
      body: FutureBuilder<StudentAnalytics>(
        future: progressRepo.getAnalyticsForStudent(student.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;
          if (data == null) {
            return const Center(child: Text('No progress data yet.'));
          }

          final overallMasteryPercent = (data.overallMastery * 100).toInt();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Metrics Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricBox(
                        title: 'Overall Mastery',
                        subtitle: 'Bayesian AI Estimate',
                        value: '$overallMasteryPercent%',
                        color: AppColors.primaryIndigo,
                        icon: Icons.psychology_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricBox(
                        title: 'Quiz Accuracy',
                        subtitle: '${data.correctAttempts}/${data.totalAttempts} correct',
                        value: '${data.accuracyPercentage.toStringAsFixed(0)}%',
                        color: AppColors.successGreen,
                        icon: Icons.check_circle_outline_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricBox(
                        title: 'Day Streak',
                        subtitle: 'Consecutive active days',
                        value: '${data.streakDays} Days',
                        color: AppColors.warmYellow,
                        icon: Icons.local_fire_department_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricBox(
                        title: 'Lessons Read',
                        subtitle: 'Completed offline modules',
                        value: '${data.completedLessonsCount}',
                        color: AppColors.skyBlue,
                        icon: Icons.menu_book_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Bayesian Knowledge Tracing Chart
                Text(
                  'Mastery Trajectory (BKT Engine)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Shows how your knowledge probability evolves with each practice attempt.',
                  style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                ),
                const SizedBox(height: 14),

                Container(
                  height: 200,
                  padding: const EdgeInsets.fromLTRB(16, 20, 20, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: LineChart(
                    LineChartData(
                      minY: 0.0,
                      maxY: 1.0,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: const Color(0xFFF1F5F9),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 34,
                            interval: 0.25,
                            getTitlesWidget: (val, _) => Text(
                              '${(val * 100).toInt()}%',
                              style: const TextStyle(fontSize: 10, color: AppColors.secondaryText),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 5,
                            getTitlesWidget: (val, _) => Text(
                              '#${val.toInt()}',
                              style: const TextStyle(fontSize: 10, color: AppColors.secondaryText),
                            ),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data.masteryHistorySpots,
                          isCurved: true,
                          color: AppColors.primaryIndigo,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primaryIndigo.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Topic-wise Mastery Breakdown
                Text(
                  'Topic-Wise Mastery Levels',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),

                ...data.topicSummaries.map((topic) {
                  final title = lang == 'kn' ? topic.titleKn : topic.title;
                  final percent = (topic.averageMastery * 100).toInt();

                  Color tierColor = AppColors.masteryNeedsPractice;
                  if (topic.tier == 'Proficient') {
                    tierColor = AppColors.masteryProficient;
                  } else if (topic.tier == 'Developing') {
                    tierColor = AppColors.masteryDeveloping;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: tierColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                topic.tier,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: tierColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          topic.subjectName,
                          style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: topic.averageMastery.clamp(0.0, 1.0),
                                  backgroundColor: const Color(0xFFF1F5F9),
                                  valueColor: AlwaysStoppedAnimation<Color>(tierColor),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '$percent%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: tierColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Recent Quiz Attempts Table
                Text(
                  'Recent Quiz Attempts',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),

                if (data.recentAttempts.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Center(
                      child: Text(
                        'No attempts recorded yet. Practice a quiz to see live updates!',
                        style: TextStyle(color: AppColors.secondaryText, fontSize: 13),
                      ),
                    ),
                  )
                else
                  ...data.recentAttempts.map((att) {
                    final isCorrect = (att['is_correct'] as int) == 1;
                    final qText = lang == 'kn' ? (att['question_text_kn'] ?? att['question_text']) : att['question_text'];
                    final diff = (att['difficulty'] as String).toUpperCase();
                    final mAfter = ((att['mastery_after'] as num).toDouble() * 100).toInt();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                            color: isCorrect ? AppColors.successGreen : AppColors.errorRed,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  qText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$diff • Mastery: $mAfter%',
                                  style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricBox({
    required String title,
    required String subtitle,
    required String value,
    required Color color,
    required IconData icon,
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
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondaryText),
              ),
              Icon(icon, size: 20, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }
}
