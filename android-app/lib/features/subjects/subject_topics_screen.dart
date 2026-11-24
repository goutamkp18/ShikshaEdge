import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../models/models.dart';
import '../../shared/providers/app_providers.dart';

class SubjectTopicsScreen extends ConsumerWidget {
  final String subjectId;
  final Subject? subject;

  const SubjectTopicsScreen({
    super.key,
    required this.subjectId,
    this.subject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final contentRepo = ref.watch(contentRepositoryProvider);
    final studentAsync = ref.watch(activeStudentProvider);
    final student = studentAsync.value;

    final lang = student?.preferredLanguage ?? 'en';
    final subjectTitle = subject != null
        ? (lang == 'kn' ? subject!.nameKn : subject!.name)
        : 'Subject Topics';

    return Scaffold(
      appBar: AppBar(
        title: Text(subjectTitle),
      ),
      body: FutureBuilder<List<Topic>>(
        future: contentRepo.getTopicsForSubject(subjectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final topics = snapshot.data ?? [];
          if (topics.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox_outlined, size: 64, color: AppColors.secondaryText),
                    const SizedBox(height: 16),
                    const Text(
                      'No topics available in this subject yet.',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Additional curriculum will be added through offline content packs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: topics.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final topic = topics[index];
              final title = lang == 'kn' ? topic.titleKn : topic.title;
              final desc = lang == 'kn' ? topic.descriptionKn : topic.description;

              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryIndigo.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: AppColors.primaryIndigo,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Topic ${index + 1}',
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
                    const SizedBox(height: 12),
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 44),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onPressed: () {
                              _openFirstLessonForTopic(context, ref, topic.id);
                            },
                            icon: const Icon(Icons.menu_book_rounded, size: 18),
                            label: Text(
                              loc.translate('read_lesson'),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 44),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              backgroundColor: AppColors.successGreen,
                            ),
                            onPressed: () {
                              context.push('/quiz/${topic.id}');
                            },
                            icon: const Icon(Icons.bolt_rounded, size: 18),
                            label: Text(
                              loc.translate('quiz'),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openFirstLessonForTopic(BuildContext context, WidgetRef ref, String topicId) async {
    final lessons = await ref.read(contentRepositoryProvider).getLessonsForTopic(topicId);
    if (lessons.isNotEmpty) {
      if (!context.mounted) return;
      context.push('/lesson/${lessons.first.id}');
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lesson content coming soon in next offline update.')),
      );
    }
  }
}
