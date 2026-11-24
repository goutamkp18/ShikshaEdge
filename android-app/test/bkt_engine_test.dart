import 'package:flutter_test/flutter_test.dart';
import 'package:shikshaedge/services/adaptive_learning/bkt_engine.dart';

void main() {
  group('Bayesian Knowledge Tracing (BKT) Engine Tests', () {
    const engine = BktEngine();

    test('Initial parameters match specification', () {
      expect(engine.parameters.initialMastery, 0.30);
      expect(engine.parameters.learningProbability, 0.10);
      expect(engine.parameters.guessProbability, 0.20);
      expect(engine.parameters.slipProbability, 0.10);
    });

    test('Correct answer updates mastery upwards', () {
      const prior = 0.30;
      final result = engine.updateMastery(currentMastery: prior, isCorrect: true);

      // Verify posterior calculation:
      // posterior = (0.30 * 0.90) / ((0.30 * 0.90) + (0.70 * 0.20))
      // numerator = 0.27
      // denominator = 0.27 + 0.14 = 0.41
      // posterior = 0.27 / 0.41 ≈ 0.6585
      // updatedMastery = posterior + (1 - posterior) * 0.10 ≈ 0.6585 + 0.0341 ≈ 0.6927
      expect(result.isCorrect, isTrue);
      expect(result.posterior, greaterThan(prior));
      expect(result.updatedMastery, greaterThan(result.posterior));
      expect(result.masteryChange, greaterThan(0));
      expect(result.updatedMastery, closeTo(0.692, 0.01));
    });

    test('Incorrect answer updates mastery downwards', () {
      const prior = 0.60;
      final result = engine.updateMastery(currentMastery: prior, isCorrect: false);

      // posterior = (0.60 * 0.10) / ((0.60 * 0.10) + (0.40 * 0.80))
      // numerator = 0.06
      // denominator = 0.06 + 0.32 = 0.38
      // posterior = 0.06 / 0.38 ≈ 0.1579
      // updatedMastery = posterior + (1 - posterior) * 0.10 ≈ 0.1579 + 0.0842 = 0.242
      expect(result.isCorrect, isFalse);
      expect(result.posterior, lessThan(prior));
      expect(result.updatedMastery, lessThan(prior));
    });

    test('Mastery probability boundaries remain strictly clamped between 0 and 1', () {
      // Multiple consecutive correct answers
      double mastery = 0.95;
      for (int i = 0; i < 20; i++) {
        final res = engine.updateMastery(currentMastery: mastery, isCorrect: true);
        mastery = res.updatedMastery;
        expect(mastery, lessThanOrEqualTo(1.0));
        expect(mastery, greaterThanOrEqualTo(0.0));
      }
      expect(mastery, greaterThan(0.95));

      // Multiple consecutive incorrect answers
      mastery = 0.05;
      for (int i = 0; i < 20; i++) {
        final res = engine.updateMastery(currentMastery: mastery, isCorrect: false);
        mastery = res.updatedMastery;
        expect(mastery, lessThanOrEqualTo(1.0));
        expect(mastery, greaterThanOrEqualTo(0.0));
      }
    });

    test('Adaptive Difficulty Policy selects correct difficulty levels', () {
      // < 40%: easy
      expect(engine.getDifficultyForMastery(0.10), 'easy');
      expect(engine.getDifficultyForMastery(0.39), 'easy');

      // 40% - 75%: medium
      expect(engine.getDifficultyForMastery(0.40), 'medium');
      expect(engine.getDifficultyForMastery(0.55), 'medium');
      expect(engine.getDifficultyForMastery(0.75), 'medium');

      // > 75%: hard
      expect(engine.getDifficultyForMastery(0.76), 'hard');
      expect(engine.getDifficultyForMastery(0.99), 'hard');
    });

    test('Mastery Tier categorization indicates learning support requirements', () {
      expect(engine.getMasteryTier(0.25), 'Needs Practice');
      expect(engine.getMasteryTier(0.50), 'Developing');
      expect(engine.getMasteryTier(0.85), 'Proficient');
    });

    test('Explainable AI provides meaningful feedback in English and Kannada', () {
      final res = engine.updateMastery(currentMastery: 0.30, isCorrect: true);
      expect(res.explainableReason, isNotEmpty);
      expect(res.explainableReasonKn, isNotEmpty);
    });
  });
}
