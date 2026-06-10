import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/friends/presentation/screens/friends_screen.dart';
import '../../features/rooms/presentation/screens/room_lobby_screen.dart';
import '../../features/gameplay/presentation/screens/game_table_screen.dart';

/// GoRouter instance — auth-guarded navigation
/// The router listens to [authStateProvider] and redirects accordingly
final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<bool>(false);

  // Listen to auth state changes for redirect
  ref.listen<AsyncValue<AuthState>>(
    authStateProvider,
    (_, next) {
      authNotifier.value = next.maybeWhen(
        data: (state) => state.isAuthenticated,
        orElse: () => false,
      );
    },
  );

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: authNotifier,
    debugLogDiagnostics: true,

    // -------------------------------------------------------
    // Auth redirect guard
    // -------------------------------------------------------
    redirect: (context, state) {
      final isAuthenticated = authNotifier.value;
      final location = state.uri.toString();

      final isAuthPath = location == RouteNames.login ||
          location == RouteNames.signup ||
          location == RouteNames.splash;

      // Unauthenticated and trying to access protected route → login
      if (!isAuthenticated && !isAuthPath) {
        return RouteNames.login;
      }

      // Authenticated and going to auth screens → home
      if (isAuthenticated && isAuthPath && location != RouteNames.splash) {
        return RouteNames.home;
      }

      return null;
    },

    routes: [
      // -------------------------------------------------------
      // Public routes
      // -------------------------------------------------------
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) => _buildFadePage(
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => _buildSlidePage(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.signup,
        name: 'signup',
        pageBuilder: (context, state) => _buildSlidePage(
          state: state,
          child: const SignupScreen(),
        ),
      ),

      // -------------------------------------------------------
      // Protected routes (shells with bottom nav will be added in Phase 3)
      // -------------------------------------------------------
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.friends,
        name: 'friends',
        builder: (context, state) => const FriendsScreen(),
      ),
      GoRoute(
        path: '/rooms',
        name: 'rooms',
        builder: (context, state) => const _PlaceholderScreen(title: 'Rooms'),
        routes: [
          GoRoute(
            path: ':roomId',
            name: 'roomLobby',
            builder: (context, state) {
              final roomId = int.parse(state.pathParameters['roomId']!);
              return RoomLobbyScreen(roomId: roomId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/game/:matchId',
        name: 'game',
        builder: (context, state) {
          final matchId = int.parse(state.pathParameters['matchId']!);
          return GameTableScreen(matchId: matchId);
        },
      ),
      GoRoute(
        path: RouteNames.leaderboard,
        name: 'leaderboard',
        builder: (context, state) => const _PlaceholderScreen(title: 'Leaderboard'),
      ),
      GoRoute(
        path: RouteNames.notifications,
        name: 'notifications',
        builder: (context, state) => const _PlaceholderScreen(title: 'Notifications'),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF0D0E1A),
      body: Center(
        child: Text(
          'Page not found: ${state.uri}',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    ),
  );
});

// -------------------------------------------------------
// Page transition builders
// -------------------------------------------------------
CustomTransitionPage<void> _buildFadePage({
  required GoRouterState state,
  required Widget child,
}) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    );

CustomTransitionPage<void> _buildSlidePage({
  required GoRouterState state,
  required Widget child,
}) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end   = Offset.zero;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
    );

// -------------------------------------------------------
// Placeholder — replaced phase by phase
// -------------------------------------------------------
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0D0E1A),
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 24)),
        ),
      );
}
