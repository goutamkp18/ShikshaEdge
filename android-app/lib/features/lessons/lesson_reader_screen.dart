import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../models/models.dart';
import '../../services/audio/audio_service.dart';
import '../../shared/providers/app_providers.dart';

class LessonReaderScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const LessonReaderScreen({
    super.key,
    required this.lessonId,
  });

  @override
  ConsumerState<LessonReaderScreen> createState() => _LessonReaderScreenState();
}

class _LessonReaderScreenState extends ConsumerState<LessonReaderScreen> {
  int _currentSlideIndex = 0;
  bool _isBookmarked = false;
  Lesson? _lesson;
  List<dynamic> _slides = [];
  bool _isLoading = true;

  late AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    final contentRepo = ref.read(contentRepositoryProvider);
    final student = ref.read(activeStudentProvider).value;

    final lesson = await contentRepo.getLessonById(widget.lessonId);
    if (lesson != null) {
      final decoded = json.decode(lesson.contentJson) as List<dynamic>;
      bool bookmarked = false;
      if (student != null) {
        bookmarked = await contentRepo.isLessonBookmarked(
          studentId: student.id,
          lessonId: lesson.id,
        );
        // Check saved slide progress
        final progress = await contentRepo.getLessonProgress(
          studentId: student.id,
          lessonId: lesson.id,
        );
        if (progress != null) {
          _currentSlideIndex = (progress['last_slide_index'] as int?) ?? 0;
        }
      }

      // Check audio path for student preferred language
      final audioPath = (student?.preferredLanguage == 'kn')
          ? lesson.audioKnPath ?? lesson.audioEnPath
          : lesson.audioEnPath ?? lesson.audioKnPath;

      if (audioPath != null && audioPath.isNotEmpty) {
        await _audioService.loadAssetAudio(audioPath);
      }

      setState(() {
        _lesson = lesson;
        _slides = decoded;
        _isBookmarked = bookmarked;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProgress() async {
    final student = ref.read(activeStudentProvider).value;
    if (student != null && _lesson != null) {
      final isLast = _currentSlideIndex >= _slides.length - 1;
      await ref.read(contentRepositoryProvider).saveLessonProgress(
        studentId: student.id,
        lessonId: _lesson!.id,
        lastSlideIndex: _currentSlideIndex,
        isCompleted: isLast,
      );
    }
  }

  Future<void> _toggleBookmark() async {
    final student = ref.read(activeStudentProvider).value;
    if (student != null && _lesson != null) {
      final res = await ref.read(contentRepositoryProvider).toggleBookmark(
        studentId: student.id,
        lessonId: _lesson!.id,
      );
      setState(() => _isBookmarked = res);
    }
  }

  @override
  void dispose() {
    _saveProgress();
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final student = ref.watch(activeStudentProvider).value;
    final lang = student?.preferredLanguage ?? 'en';

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_lesson == null || _slides.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Lesson could not be loaded.')),
      );
    }

    final currentSlide = _slides[_currentSlideIndex] as Map<String, dynamic>;
    final slideTitle = lang == 'kn' ? (currentSlide['title_kn'] ?? currentSlide['title']) : currentSlide['title'];
    final slideBody = lang == 'kn' ? (currentSlide['body_kn'] ?? currentSlide['body']) : currentSlide['body'];
    final visualType = currentSlide['visual_type'] as String?;
    final visualData = currentSlide['visual_data'] as Map<String, dynamic>?;

    final isFirstSlide = _currentSlideIndex == 0;
    final isLastSlide = _currentSlideIndex == _slides.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'kn' ? _lesson!.titleKn : _lesson!.title),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? AppColors.warmYellow : null,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Slide Progress Indicator
            LinearProgressIndicator(
              value: (_currentSlideIndex + 1) / _slides.length,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryIndigo),
              minHeight: 4,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryIndigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'STEP ${_currentSlideIndex + 1} OF ${_slides.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryIndigo,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      slideTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Educational Visual Diagram
                    if (visualType != null)
                      _buildVisualCard(visualType, visualData),

                    const SizedBox(height: 16),

                    // Body Explanation
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        slideBody,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Offline Audio Player Widget
                    _buildAudioPlayerWidget(loc),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  if (!isFirstSlide)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _currentSlideIndex--);
                          _saveProgress();
                        },
                        child: const Text('Previous'),
                      ),
                    ),
                  if (!isFirstSlide) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLastSlide ? AppColors.successGreen : AppColors.primaryIndigo,
                      ),
                      onPressed: () {
                        if (isLastSlide) {
                          _saveProgress();
                          // Launch adaptive quiz
                          context.push('/quiz/${_lesson!.topicId}');
                        } else {
                          setState(() => _currentSlideIndex++);
                          _saveProgress();
                        }
                      },
                      child: Text(isLastSlide ? 'Start Practice Quiz ⚡' : 'Next Step →'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayerWidget(AppLocalizations loc) {
    if (!_audioService.isAssetAvailable) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          children: [
            Icon(Icons.volume_off_rounded, color: AppColors.secondaryText, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Audio explanation will be provided via ElevenLabs pack update.',
                style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
              ),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<PlayerState>(
      stream: _audioService.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final isPlaying = state?.playing ?? false;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFC7D2FE)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                  color: AppColors.primaryIndigo,
                  size: 38,
                ),
                onPressed: () {
                  if (isPlaying) {
                    _audioService.pause();
                  } else {
                    _audioService.play();
                  }
                },
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voice Explanation (Offline)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryIndigo,
                      ),
                    ),
                    Text(
                      'Listen to step-by-step guidance',
                      style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.replay_rounded, color: AppColors.primaryIndigo),
                onPressed: () => _audioService.replay(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVisualCard(String type, Map<String, dynamic>? data) {
    Widget visualWidget;

    switch (type) {
      case 'group_diagram':
        final groups = (data?['groups'] as int?) ?? 3;
        final count = (data?['items_per_group'] as int?) ?? 4;
        visualWidget = Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: List.generate(
                groups,
                (g) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Text('Basket ${g + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('🥭 ' * count, style: const TextStyle(fontSize: 16)),
                      Text('$count items', style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$groups groups x $count items = ${groups * count} Total',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryIndigo, fontSize: 15),
            ),
          ],
        );
        break;

      case 'number_line':
        visualWidget = Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('0 ➡️ +2'),
              Text('2 ➡️ +2'),
              Text('4 ➡️ +2'),
              Text('6 ➡️ +2'),
              Text('8 ➡️ 10!'),
            ],
          ),
        );
        break;

      case 'plant_cycle':
      case 'leaf_diagram':
        visualWidget = Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: const Column(
            children: [
              Text(
                '☀️ Sunlight + 💨 Carbon Dioxide + 💧 Water',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
              ),
              SizedBox(height: 8),
              Icon(Icons.arrow_downward_rounded, color: AppColors.successGreen),
              SizedBox(height: 8),
              Text(
                '🍃 Chlorophyll (Leaf Factory)',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.successGreen),
              ),
              SizedBox(height: 8),
              Icon(Icons.arrow_downward_rounded, color: AppColors.successGreen),
              SizedBox(height: 8),
              Text(
                '🍏 Glucose (Food) + 🌬️ Oxygen (Air)',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF047857), fontSize: 15),
              ),
            ],
          ),
        );
        break;

      default:
        visualWidget = Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Icon(Icons.lightbulb_outline_rounded, size: 40, color: AppColors.warmYellow),
          ),
        );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: visualWidget,
    );
  }
}
