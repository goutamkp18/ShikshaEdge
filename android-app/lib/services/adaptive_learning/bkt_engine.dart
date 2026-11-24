/// Parameters for the Bayesian Knowledge Tracing (BKT) Model
class BktParameters {
  final double initialMastery;    // L0: Probability student already knows skill before any observation (default 0.30)
  final double learningProbability; // T: Probability of transitioning from unmastered to mastered state after practice (default 0.10)
  final double guessProbability;    // G: Probability student guesses correctly despite not knowing (default 0.20)
  final double slipProbability;     // S: Probability student makes a mistake despite knowing (default 0.10)

  const BktParameters({
    this.initialMastery = 0.30,
    this.learningProbability = 0.10,
    this.guessProbability = 0.20,
    this.slipProbability = 0.10,
  });
}

/// Detailed calculation result for auditability, telemetry, and Developer Demonstration View
class BktCalculationResult {
  final double priorMastery;
  final bool isCorrect;
  final double posterior;
  final double updatedMastery;
  final double masteryChange;
  final String nextDifficulty;
  final String explainableReason;
  final String explainableReasonKn;
  final BktParameters parameters;

  BktCalculationResult({
    required this.priorMastery,
    required this.isCorrect,
    required this.posterior,
    required this.updatedMastery,
    required this.masteryChange,
    required this.nextDifficulty,
    required this.explainableReason,
    required this.explainableReasonKn,
    required this.parameters,
  });
}

/// Pure Dart Bayesian Knowledge Tracing Engine (Offline, Zero-Cloud)
class BktEngine {
  final BktParameters parameters;

  const BktEngine({this.parameters = const BktParameters()});

  /// Calculate posterior and next mastery given student's prior mastery and response correctness
  BktCalculationResult updateMastery({
    required double currentMastery,
    required bool isCorrect,
  }) {
    // Clamp prior between 0.001 and 0.999 to avoid division by zero
    final L = currentMastery.clamp(0.001, 0.999);
    final S = parameters.slipProbability;
    final G = parameters.guessProbability;
    final T = parameters.learningProbability;

    double posterior;
    if (isCorrect) {
      // P(L | Correct) = (L * (1 - S)) / ((L * (1 - S)) + ((1 - L) * G))
      final numerator = L * (1.0 - S);
      final denominator = numerator + ((1.0 - L) * G);
      posterior = denominator > 0 ? (numerator / denominator) : L;
    } else {
      // P(L | Incorrect) = (L * S) / ((L * S) + ((1 - L) * (1 - G)))
      final numerator = L * S;
      final denominator = numerator + ((1.0 - L) * (1.0 - G));
      posterior = denominator > 0 ? (numerator / denominator) : L;
    }

    // Apply learning transition: P(L_next) = posterior + (1 - posterior) * T
    final rawUpdated = posterior + ((1.0 - posterior) * T);
    final updatedMastery = rawUpdated.clamp(0.0, 1.0);
    final masteryChange = updatedMastery - currentMastery;

    final nextDifficulty = getDifficultyForMastery(updatedMastery);
    final (reasonEn, reasonKn) = _generateExplanation(
      priorMastery: currentMastery,
      updatedMastery: updatedMastery,
      isCorrect: isCorrect,
      nextDifficulty: nextDifficulty,
    );

    return BktCalculationResult(
      priorMastery: currentMastery,
      isCorrect: isCorrect,
      posterior: posterior,
      updatedMastery: updatedMastery,
      masteryChange: masteryChange,
      nextDifficulty: nextDifficulty,
      explainableReason: reasonEn,
      explainableReasonKn: reasonKn,
      parameters: parameters,
    );
  }

  /// Policy:
  /// Mastery < 40%: Easy questions
  /// Mastery 40% - 75%: Medium questions
  /// Mastery > 75%: Hard questions
  String getDifficultyForMastery(double mastery) {
    if (mastery < 0.40) {
      return 'easy';
    } else if (mastery <= 0.75) {
      return 'medium';
    } else {
      return 'hard';
    }
  }

  /// Classify mastery for student performance reporting
  String getMasteryTier(double mastery) {
    if (mastery < 0.40) {
      return 'Needs Practice';
    } else if (mastery <= 0.75) {
      return 'Developing';
    } else {
      return 'Proficient';
    }
  }

  /// Friendly human-readable explanation of why question difficulty was adjusted
  (String, String) _generateExplanation({
    required double priorMastery,
    required double updatedMastery,
    required bool isCorrect,
    required String nextDifficulty,
  }) {
    if (isCorrect) {
      if (updatedMastery > 0.75) {
        return (
          "Great job! Your mastery reached ${(updatedMastery * 100).toStringAsFixed(0)}%. You're ready for a challenge!",
          "ಅದ್ಭುತ! ನಿಮ್ಮ ಪ್ರಾವೀಣ್ಯತೆ ${(updatedMastery * 100).toStringAsFixed(0)}% ತಲುಪಿದೆ. ಸವಾಲಿನ ಪ್ರಶ್ನೆಗೆ ನೀವು ಸಿದ್ಧರಿದ್ದೀರಿ!"
        );
      } else if (updatedMastery >= 0.40) {
        return (
          "Nice work! Your understanding is improving. Moving to medium difficulty.",
          "ಉತ್ತಮ ಪ್ರಯತ್ನ! ನಿಮ್ಮ ಕಲಿಕೆ ಸುಧಾರಿಸುತ್ತಿದೆ. ಮಧ್ಯಮ ಮಟ್ಟದ ಪ್ರಶ್ನೆಗೆ ಮುಂದುವರಿಯುತ್ತಿದ್ದೀರಿ."
        );
      } else {
        return (
          "Correct! Let's reinforce this foundation with another practice question.",
          "ಸರಿ ಉತ್ತರ! ಮತ್ತೊಂದು ಅಭ್ಯಾಸದ ಪ್ರಶ್ನೆಯೊಂದಿಗೆ ಈ ಪರಿಕಲ್ಪನೆಯನ್ನು ಬಲಪಡಿಸೋಣ."
        );
      }
    } else {
      if (updatedMastery < 0.40) {
        return (
          "No worries! Mistakes help us learn. Let's try an easier question to build confidence.",
          "ಚಿಂತೆ ಬೇಡ! ತಪ್ಪುಗಳಿಂದಲೇ ಕಲಿಯುವುದು. ಆತ್ಮವಿಶ್ವಾಸ ಹೆಚ್ಚಿಸಲು ಸುಲಭದ ಪ್ರಶ್ನೆ ಅಭ್ಯಾಸ ಮಾಡೋಣ."
        );
      } else {
        return (
          "Let's review this concept carefully with hints and step-by-step guidance.",
          "ಸುಳಿವು ಮತ್ತು ಹಂತ-ಹಂತದ ಮಾರ್ಗದರ್ಶನದೊಂದಿಗೆ ಈ ಪರಿಕಲ್ಪನೆಯನ್ನು ಪುನರಾವರ್ತಿಸೋಣ."
        );
      }
    }
  }
}
