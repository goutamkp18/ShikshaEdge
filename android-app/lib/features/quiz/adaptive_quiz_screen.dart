import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../models/models.dart';
import '../../services/adaptive_learning/adaptive_quiz_service.dart';
import '../../services/adaptive_learning/bkt_engine.dart';
import '../../services/audio/audio_service.dart';
import '../../shared/providers/app_providers.dart';

class AdaptiveQuizScreen extends ConsumerStatefulWidget {
  final String topicId;

  const AdaptiveQuizScreen({
    super.key,
    required this.topicId,
  });

  @override
  ConsumerState<AdaptiveQuizScreen> createState() => _AdaptiveQuizScreenState();
}

class _AdaptiveQuizScreenState extends ConsumerState<AdaptiveQuizScreen> {
  final List<String> _answeredQuestionIds = [];
  final List<Attempt> _sessionAttempts = [];

  Question? _currentQuestion;
  String? _selectedOptionId;
  bool _isAnswerSubmitted = false;
  BktCalculationResult? _lastBktResult;
  bool _isLoadingNext = true;
  bool _showHint = false;
  bool _showDevDemo = false;
  bool _showKannada = false;

  late AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _loadNextAdaptiveQuestion();
  }

  Future<void> _loadNextAdaptiveQuestion() async {
    setState(() {
      _isLoadingNext = true;
      _selectedOptionId = null;
      _isAnswerSubmitted = false;
      _showHint = false;
    });

    final student = ref.read(activeStudentProvider).value;
    if (student == null) {
      if (!mounted) return;
      context.go('/register');
      return;
    }

    _showKannada = student.preferredLanguage == 'kn';

    final quizService = ref.read(adaptiveQuizServiceProvider);
    final nextQ = await quizService.getNextAdaptiveQuestion(
      studentId: student.id,
      topicId: widget.topicId,
      excludedQuestionIds: _answeredQuestionIds,
    );

    if (nextQ != null) {
      final audioPath = _showKannada
          ? nextQ.audioKnPath ?? nextQ.audioEnPath
          : nextQ.audioEnPath ?? nextQ.audioKnPath;

      if (audioPath != null && audioPath.isNotEmpty) {
        await _audioService.loadAssetAudio(audioPath);
      }
    }

    if (mounted) {
      setState(() {
        _currentQuestion = nextQ;
        _isLoadingNext = false;
      });
    }
  }

  Future<void> _submitAnswer() async {
    if (_selectedOptionId == null || _currentQuestion == null || _isAnswerSubmitted) return;

    final student = ref.read(activeStudentProvider).value;
    if (student == null) return;

    final quizService = ref.read(adaptiveQuizServiceProvider);
    final bktResult = await quizService.submitAnswer(
      studentId: student.id,
      question: _currentQuestion!,
      selectedOptionId: _selectedOptionId!,
    );

    _answeredQuestionIds.add(_currentQuestion!.id);

    final selectedOpt = _currentQuestion!.options.firstWhere(
      (opt) => opt.id == _selectedOptionId,
    );

    final attempt = Attempt(
      id: '',
      studentId: student.id,
      questionId: _currentQuestion!.id,
      topicId: _currentQuestion!.topicId,
      skillId: _currentQuestion!.skillId,
      selectedOptionId: _selectedOptionId!,
      isCorrect: selectedOpt.isCorrect,
      difficulty: _currentQuestion!.difficulty,
      masteryBefore: bktResult.priorMastery,
      masteryAfter: bktResult.updatedMastery,
      answeredAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    _sessionAttempts.add(attempt);

    setState(() {
      _isAnswerSubmitted = true;
      _lastBktResult = bktResult;
    });
  }

  void _finishQuiz() {
    context.pushReplacement('/quiz-results', extra: {
      'topicId': widget.topicId,
      'attempts': _sessionAttempts,
      'lastBkt': _lastBktResult,
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (_isLoadingNext) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Adaptive AI selecting next question...',
                style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondaryText),
              ),
            ],
          ),
        ),
      );
    }

    // Question exhaustion or topic complete
    if (_currentQuestion == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Topic Quiz')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.stars_rounded, size: 72, color: AppColors.warmYellow),
                const SizedBox(height: 18),
                const Text(
                  'Great Practice Session!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                const Text(
                  'You have practiced all available questions for this topic in this session.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.secondaryText),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _finishQuiz,
                  child: const Text('View Quiz Results'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = _currentQuestion!;
    final questionText = _showKannada ? q.questionTextKn : q.questionText;
    final explanation = _showKannada ? q.explanationKn : q.explanation;
    final hint = _showKannada ? q.hintKn : q.hint;
    final questionNumber = _answeredQuestionIds.length + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question $questionNumber'),
        actions: [
          // Language toggle button for rural students
          TextButton.icon(
            onPressed: () {
              setState(() => _showKannada = !_showKannada);
            },
            icon: const Icon(Icons.translate_rounded, size: 18, color: AppColors.primaryIndigo),
            label: Text(
              _showKannada ? 'ENG' : 'ಕನ್ನಡ',
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryIndigo),
            ),
          ),
          IconButton(
            tooltip: 'Finish Quiz',
            icon: const Icon(Icons.close_rounded),
            onPressed: _answeredQuestionIds.isNotEmpty ? _finishQuiz : () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Difficulty Badge & Adaptive AI Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDifficultyBadge(q.difficulty),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.bolt_rounded, size: 14, color: AppColors.primaryIndigo),
                        SizedBox(width: 4),
                        Text(
                          'BKT Adaptive AI',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryIndigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Question Text Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questionText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.5,
                        color: AppColors.primaryText,
                      ),
                    ),
                    if (_audioService.isAssetAvailable) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          IconButton.filledTonal(
                            icon: const Icon(Icons.volume_up_rounded, size: 20),
                            onPressed: () => _audioService.replay(),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Listen to Question Audio',
                            style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Multiple-Choice Options
              ...q.options.map((opt) {
                final isSelected = _selectedOptionId == opt.id;
                final optText = _showKannada ? opt.optionTextKn : opt.optionText;

                Color optBorder = const Color(0xFFE2E8F0);
                Color optBg = Colors.white;
                Widget? trailingIcon;

                if (_isAnswerSubmitted) {
                  if (opt.isCorrect) {
                    optBorder = AppColors.successGreen;
                    optBg = const Color(0xFFECFDF5);
                    trailingIcon = const Icon(Icons.check_circle_rounded, color: AppColors.successGreen);
                  } else if (isSelected) {
                    optBorder = AppColors.errorRed;
                    optBg = const Color(0xFFFEF2F2);
                    trailingIcon = const Icon(Icons.cancel_rounded, color: AppColors.errorRed);
                  }
                } else if (isSelected) {
                  optBorder = AppColors.primaryIndigo;
                  optBg = AppColors.primaryIndigo.withOpacity(0.08);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: _isAnswerSubmitted
                        ? null
                        : () => setState(() => _selectedOptionId = opt.id),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: optBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: optBorder, width: isSelected ? 2 : 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.primaryIndigo : const Color(0xFF94A3B8),
                                width: 2,
                              ),
                              color: isSelected ? AppColors.primaryIndigo : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(Icons.circle, size: 10, color: Colors.white),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              optText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                          if (trailingIcon != null) trailingIcon,
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),

              // Hint Toggle
              if (!_isAnswerSubmitted) ...[
                TextButton.icon(
                  onPressed: () => setState(() => _showHint = !_showHint),
                  icon: const Icon(Icons.lightbulb_outline_rounded, size: 18, color: AppColors.warmYellow),
                  label: Text(_showHint ? 'Hide Hint' : loc.translate('hint')),
                ),
                if (_showHint)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Text(
                      '💡 $hint',
                      style: const TextStyle(color: Color(0xFF92400E), fontSize: 13, height: 1.4),
                    ),
                  ),
              ],

              // Feedback & Explanation Card (Shown after submit)
              if (_isAnswerSubmitted && _lastBktResult != null) ...[
                const SizedBox(height: 16),
                _buildFeedbackCard(explanation),
                const SizedBox(height: 16),
                _buildExplainableAiCard(),
              ],

              const SizedBox(height: 28),

              // Action Buttons: Submit / Next Question
              if (!_isAnswerSubmitted)
                ElevatedButton(
                  onPressed: _selectedOptionId != null ? _submitAnswer : null,
                  child: Text(loc.translate('submit_answer')),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _finishQuiz,
                        child: const Text('Finish Session'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _loadNextAdaptiveQuestion,
                        child: Text(loc.translate('next_question')),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color bg;
    Color fg;
    String label;

    switch (difficulty.toLowerCase()) {
      case 'easy':
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF15803D);
        label = 'LEVEL: EASY';
        break;
      case 'hard':
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFB91C1C);
        label = 'LEVEL: HARD';
        break;
      case 'medium':
      default:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        label = 'LEVEL: MEDIUM';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(String explanation) {
    final isCorrect = _lastBktResult!.isCorrect;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                color: isCorrect ? AppColors.successGreen : AppColors.errorRed,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                isCorrect ? 'Correct! Keep it up!' : 'Not quite right. Let\'s learn why:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isCorrect ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            explanation,
            style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.primaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildExplainableAiCard() {
    final bkt = _lastBktResult!;
    final reason = _showKannada ? bkt.explainableReasonKn : bkt.explainableReason;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.psychology_rounded, color: AppColors.primaryIndigo, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Explainable AI Engine',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryIndigo),
                  ),
                ],
              ),
              InkWell(
                onTap: () => setState(() => _showDevDemo = !_showDevDemo),
                child: Text(
                  _showDevDemo ? 'Hide Math' : 'Show BKT Math',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryIndigo),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            reason,
            style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.primaryText),
          ),
          if (_showDevDemo) ...[
            const Divider(height: 20),
            Text(
              '• Prior Mastery (L): ${(bkt.priorMastery * 100).toStringAsFixed(1)}%\n'
              '• Answer Correctness: ${bkt.isCorrect ? "True" : "False"}\n'
              '• Posterior Probability: ${(bkt.posterior * 100).toStringAsFixed(1)}%\n'
              '• Learning Transition (+T=10%): ${(bkt.updatedMastery * 100).toStringAsFixed(1)}%\n'
              '• Selected Next Difficulty: ${bkt.nextDifficulty.toUpperCase()}\n'
              '• Config: L0=0.30, T=0.10, G=0.20, S=0.10',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Color(0xFF334155),
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
