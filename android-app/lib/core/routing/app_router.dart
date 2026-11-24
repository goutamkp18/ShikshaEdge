import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/content_packs/content_packs_screen.dart';
import '../../features/dashboard/home_dashboard_screen.dart';
import '../../features/dashboard/main_navigation_shell.dart';
import '../../features/lessons/lesson_reader_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/progress/progress_dashboard_screen.dart';
import '../../features/quiz/adaptive_quiz_screen.dart';
import '../../features/quiz/quiz_results_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/student_profile/registration_screen.dart';
import '../../features/subjects/subject_topics_screen.dart';
import '../../models/models.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationScreen(),
    ),

    // Stateful Navigation Shell for bottom bar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeDashboardScreen(),
            ),
          ],
        ),
        // Tab 1: Learn
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/learn',
              builder: (context, state) => const SubjectTopicsScreen(
                subjectId: 'math_6',
              ),
            ),
          ],
        ),
        // Tab 2: Practice
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/practice',
              builder: (context, state) => const AdaptiveQuizScreen(
                topicId: 'math_mult',
              ),
            ),
          ],
        ),
        // Tab 3: Progress
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => const ProgressDashboardScreen(),
            ),
          ],
        ),
        // Tab 4: Profile & Settings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),

    // Deep sub-routes
    GoRoute(
      path: '/subject/:subjectId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final subjectId = state.pathParameters['subjectId'] ?? 'math_6';
        final subject = state.extra as Subject?;
        return SubjectTopicsScreen(subjectId: subjectId, subject: subject);
      },
    ),
    GoRoute(
      path: '/lesson/:lessonId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] ?? 'lesson_mult_1';
        return LessonReaderScreen(lessonId: lessonId);
      },
    ),
    GoRoute(
      path: '/quiz/:topicId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final topicId = state.pathParameters['topicId'] ?? 'math_mult';
        return AdaptiveQuizScreen(topicId: topicId);
      },
    ),
    GoRoute(
      path: '/quiz-results',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final topicId = extra['topicId'] as String? ?? 'math_mult';
        final attempts = extra['attempts'] as List<Attempt>? ?? [];
        return QuizResultsScreen(
          topicId: topicId,
          attempts: attempts,
          lastBkt: extra['lastBkt'],
        );
      },
    ),
    GoRoute(
      path: '/content-packs',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ContentPacksScreen(),
    ),
  ],
);
