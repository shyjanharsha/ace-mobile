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
import '../../features/leaderboard/presentation/screens/leaderboard_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/match_history_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/contact_sync_screen.dart';
import '../../features/groups/presentation/screens/groups_list_screen.dart';
import '../../features/groups/presentation/screens/group_details_screen.dart';
import '../../features/gameplay/presentation/screens/offline_setup_screen.dart';
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
      // Protected routes
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
        builder: (context, state) => const Scaffold(body: Center(child: Text('Rooms Lobby'))),
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
        path: RouteNames.offlineSetup,
        name: 'offlineSetup',
        builder: (context, state) => const OfflineSetupScreen(),
      ),
      GoRoute(
        path: RouteNames.leaderboard,
        name: 'leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.matchHistory,
        name: 'matchHistory',
        builder: (context, state) => const MatchHistoryScreen(),
      ),
      GoRoute(
        path: RouteNames.groups,
        name: 'groups',
        builder: (context, state) => const GroupsListScreen(),
        routes: [
          GoRoute(
            path: ':groupId',
            name: 'groupDetails',
            builder: (context, state) {
              final groupId = int.parse(state.pathParameters['groupId']!);
              return GroupDetailsScreen(groupId: groupId);
            },
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'sync_contacts',
            name: 'syncContacts',
            builder: (context, state) => const ContactSyncScreen(),
          ),
        ],
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
