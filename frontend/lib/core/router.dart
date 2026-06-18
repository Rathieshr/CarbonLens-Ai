import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/landing_screen.dart';
import '../screens/profile_setup_screen.dart';
import '../screens/ask_carbonlens_screen.dart';

import '../screens/navigation_scaffold.dart';
import '../screens/home_screen.dart';
import '../screens/intelligence_screen.dart';
import '../screens/future_screen.dart';
import '../screens/action_center_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/ask',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AskCarbonLensScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/intelligence',
              builder: (context, state) => const IntelligenceScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/future',
              builder: (context, state) => const FutureScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/action',
              builder: (context, state) => const ActionCenterScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
