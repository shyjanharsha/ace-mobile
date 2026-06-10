import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/notifications/presentation/providers/notifications_providers.dart';
import 'glass_card.dart';

enum AppTab { home, friends, groups, leaderboard, notifications, profile }

class AppScaffold extends ConsumerWidget {
  final Widget child;
  final AppTab currentTab;
  final bool showBottomNav;

  const AppScaffold({
    super.key,
    required this.child,
    required this.currentTab,
    this.showBottomNav = true,
  });

  void _onTabTapped(BuildContext context, AppTab tab) {
    if (tab == currentTab) return;
    switch (tab) {
      case AppTab.home:
        context.go('/home');
        break;
      case AppTab.friends:
        context.go('/friends');
        break;
      case AppTab.groups:
        context.go('/groups');
        break;
      case AppTab.leaderboard:
        context.go('/leaderboard');
        break;
      case AppTab.notifications:
        context.go('/notifications');
        break;
      case AppTab.profile:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch notifications to show a badge count
    final notifsAsync = ref.watch(notificationsProvider);
    final unreadCount = notifsAsync.value?.where((n) => !n.read).length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          children: [
            // Screen content
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: showBottomNav ? 90.0 : 0.0,
                ),
                child: child,
              ),
            ),

            // Floating Bottom Navigation Bar
            if (showBottomNav)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: SafeArea(
                  top: false,
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    radius: 24,
                    borderColor: AppColors.primary.withValues(alpha: 0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          context,
                          tab: AppTab.home,
                          icon: Icons.home_filled,
                          label: 'Home',
                        ),
                        _buildNavItem(
                          context,
                          tab: AppTab.friends,
                          icon: Icons.people_alt_rounded,
                          label: 'Social',
                        ),
                        _buildNavItem(
                          context,
                          tab: AppTab.groups,
                          icon: Icons.group_work_rounded,
                          label: 'Groups',
                        ),
                        _buildNavItem(
                          context,
                          tab: AppTab.leaderboard,
                          icon: Icons.emoji_events_rounded,
                          label: 'Rank',
                        ),
                        _buildNavItem(
                          context,
                          tab: AppTab.notifications,
                          icon: Icons.notifications_rounded,
                          label: 'Alerts',
                          badgeCount: unreadCount,
                        ),
                        _buildNavItem(
                          context,
                          tab: AppTab.profile,
                          icon: Icons.person_rounded,
                          label: 'Profile',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required AppTab tab,
    required IconData icon,
    required String label,
    int badgeCount = 0,
  }) {
    final isSelected = tab == currentTab;
    final activeColor = AppColors.primary;
    final inactiveColor = AppColors.textSecondary;

    return GestureDetector(
      onTap: () => _onTabTapped(context, tab),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 24,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.error,
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        badgeCount > 99 ? '99+' : '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
