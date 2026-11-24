import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/app_config.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = const [
    OnboardingItem(
      titleKey: 'onboarding_1_title',
      descKey: 'onboarding_1_desc',
      icon: Icons.wifi_off_rounded,
      color: AppColors.primaryIndigo,
      highlightText: '100% Offline Access',
    ),
    OnboardingItem(
      titleKey: 'onboarding_2_title',
      descKey: 'onboarding_2_desc',
      icon: Icons.auto_graph_rounded,
      color: AppColors.successGreen,
      highlightText: 'Bayesian Adaptive AI',
    ),
    OnboardingItem(
      titleKey: 'onboarding_3_title',
      descKey: 'onboarding_3_desc',
      icon: Icons.record_voice_over_rounded,
      color: AppColors.skyBlue,
      highlightText: 'Kannada & English Voice',
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConfig.keyOnboardingCompleted, true);
    if (!mounted) return;
    context.go('/register');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          if (!isLastPage)
            TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                loc.translate('skip'),
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, idx) {
                  final item = _pages[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration card
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              item.icon,
                              size: 80,
                              color: item.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.highlightText,
                            style: TextStyle(
                              color: item.color,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          loc.translate(item.titleKey),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          loc.translate(item.descKey),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryText,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Indicator and Buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i ? AppColors.primaryIndigo : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (isLastPage) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(isLastPage ? loc.translate('get_started') : loc.translate('next')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String titleKey;
  final String descKey;
  final IconData icon;
  final Color color;
  final String highlightText;

  const OnboardingItem({
    required this.titleKey,
    required this.descKey,
    required this.icon,
    required this.color,
    required this.highlightText,
  });
}
