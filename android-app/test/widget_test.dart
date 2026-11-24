import 'package:flutter_test/flutter_test.dart';
import 'package:shikshaedge/core/theme/app_colors.dart';

void main() {
  test('AppColors palette consistency check', () {
    expect(AppColors.primaryIndigo.toARGB32(), 0xFF4F46E5);
    expect(AppColors.deepIndigo.toARGB32(), 0xFF312E81);
    expect(AppColors.successGreen.toARGB32(), 0xFF16A34A);
    expect(AppColors.warmYellow.toARGB32(), 0xFFF59E0B);
    expect(AppColors.skyBlue.toARGB32(), 0xFF0EA5E9);
  });
}
