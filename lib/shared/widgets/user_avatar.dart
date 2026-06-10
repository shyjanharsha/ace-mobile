import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Avatar widget with online presence indicator dot
class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String username;
  final String? status; // online, away, in_game, offline
  final double size;
  final bool showStatus;
  final bool isCurrentTurn;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    required this.username,
    this.status,
    this.size = 48,
    this.showStatus = true,
    this.isCurrentTurn = false,
  });

  Color get _statusColor {
    return switch (status) {
      'online'  => AppColors.online,
      'in_game' => AppColors.inGame,
      'away'    => AppColors.away,
      _         => AppColors.offline,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // -------------------------------------------------------
        // Avatar circle
        // -------------------------------------------------------
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrentTurn ? AppColors.gold : AppColors.glassBorder,
              width: isCurrentTurn ? 2.5 : 1.5,
            ),
            boxShadow: isCurrentTurn
                ? [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: ClipOval(
            child: avatarUrl != null
                ? CachedNetworkImage(
                    imageUrl: avatarUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _InitialsAvatar(username: username, size: size),
                    errorWidget: (_, __, ___) => _InitialsAvatar(username: username, size: size),
                  )
                : _InitialsAvatar(username: username, size: size),
          ),
        ),

        // -------------------------------------------------------
        // Status indicator dot
        // -------------------------------------------------------
        if (showStatus)
          Positioned(
            bottom: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _statusColor,
                border: Border.all(color: AppColors.background, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: _statusColor.withValues(alpha: 0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Fallback — initials with gradient background
class _InitialsAvatar extends StatelessWidget {
  final String username;
  final double size;

  const _InitialsAvatar({required this.username, required this.size});

  @override
  Widget build(BuildContext context) {
    final initials = username.isNotEmpty
        ? username.substring(0, username.length >= 2 ? 2 : 1).toUpperCase()
        : '?';

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.labelMedium.copyWith(
            color: Colors.white,
            fontSize: size * 0.3,
          ),
        ),
      ),
    );
  }
}
