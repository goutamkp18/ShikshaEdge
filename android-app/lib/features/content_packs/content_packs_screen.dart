import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/providers/app_providers.dart';

class ContentPacksScreen extends ConsumerWidget {
  const ContentPacksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentRepo = ref.watch(contentRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Learning Packs'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: contentRepo.getContentPacks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final installedPacks = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header description
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryIndigo.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryIndigo.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.offline_bolt_rounded, color: AppColors.primaryIndigo, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Content packs store full lessons, diagrams, questions, and regional voice locally for zero-bandwidth learning.',
                        style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.primaryIndigo),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Installed Packs Section
              const Text(
                'Installed Learning Packs',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              if (installedPacks.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No packs recorded in SQLite yet.'),
                  ),
                )
              else
                ...installedPacks.map((pack) {
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
                            Text(
                              pack['name'] as String,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'INSTALLED',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Version: ${pack['version']} • Class: ${(pack['class_id'] as String).toUpperCase()}',
                          style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Subjects: Mathematics, Science, English • Languages: EN, KN',
                          style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.successGreen),
                            const SizedBox(width: 6),
                            Text(
                              'Bundled inside APK • Ready 100% Offline',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 24),

              // Available Additional Packs (Downloadable via Teammate Backend)
              const Text(
                'Available Additional Curriculum Packs',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              _buildAvailablePackItem(
                title: 'Class 7 Advanced Science & Math Pack',
                classTag: 'CLASS 7',
                size: '14.2 MB',
                description: 'Light, Sound, Algebraic Expressions, Fractions with Kannada voice.',
              ),
              const SizedBox(height: 12),
              _buildAvailablePackItem(
                title: 'Class 8 Science Experiments & Grammar',
                classTag: 'CLASS 8',
                size: '18.5 MB',
                description: 'Cell structure, Chemical reactions, Tenses, Advanced Vocabulary.',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvailablePackItem({
    required String title,
    required String classTag,
    required String size,
    required String description,
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  classTag,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.skyBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Download Size: $size',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.secondaryText),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: () {
                  // Connects to teammate's Supabase storage when backend configured
                },
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('Download', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
