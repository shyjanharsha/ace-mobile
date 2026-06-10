import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/auth_state.dart';
import '../providers/profile_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _displayNameCtrl = TextEditingController();
  String _selectedAvatar = '';
  bool _soundEnabled = true;
  bool _notifsEnabled = true;

  final List<String> _predefinedAvatars = [
    'https://api.dicebear.com/7.x/bottts/png?seed=Felix',
    'https://api.dicebear.com/7.x/bottts/png?seed=Aneka',
    'https://api.dicebear.com/7.x/bottts/png?seed=Jack',
    'https://api.dicebear.com/7.x/bottts/png?seed=Buster',
    'https://api.dicebear.com/7.x/bottts/png?seed=Milo',
    'https://api.dicebear.com/7.x/bottts/png?seed=Leo',
    'https://api.dicebear.com/7.x/bottts/png?seed=Gizmo',
    'https://api.dicebear.com/7.x/bottts/png?seed=Cookie',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authStateProvider).value?.user;
      if (user != null) {
        _displayNameCtrl.text = user.displayName ?? '';
        setState(() {
          _selectedAvatar = user.avatarUrl ?? _predefinedAvatars.first;
        });
      }
    });
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final success = await ref.read(profileUpdateProvider.notifier).updateProfile(
          displayName: _displayNameCtrl.text.trim(),
          avatarUrl: _selectedAvatar,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Profile updated successfully!' : 'Failed to update profile.',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
      if (success) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(profileUpdateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Profile',
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ).animate().fade(duration: 250.ms),
              const SizedBox(height: 12),

              // Avatar Selection Grid
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Avatar',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _predefinedAvatars.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final avatar = _predefinedAvatars[index];
                          final isSelected = avatar == _selectedAvatar;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedAvatar = avatar),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : Colors.transparent,
                                      width: 2.5,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            const BoxShadow(
                                              color: AppColors.primary,
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white10,
                                    backgroundImage: NetworkImage(avatar),
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check, size: 12, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ).animate().fade(duration: 300.ms, delay: 50.ms),

              const SizedBox(height: 16),

              // Display Name Field
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AppTextField(
                      controller: _displayNameCtrl,
                      label: 'Display Name',
                      hint: 'Enter display name',
                      prefixIcon: const Icon(Icons.badge_rounded, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Save Profile',
                      isLoading: updateState.isLoading,
                      onPressed: _displayNameCtrl.text.trim().isEmpty ? null : _saveProfile,
                    ),
                  ],
                ),
              ).animate().fade(duration: 350.ms, delay: 100.ms),

              const SizedBox(height: 24),

              Text(
                'Preferences',
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ).animate().fade(duration: 400.ms, delay: 150.ms),
              const SizedBox(height: 12),

              // Sound/Notifications settings
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      title: Text(
                        'Game Sound Effects',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Sound on card deals, turns, and wins',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      value: _soundEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _soundEnabled = val),
                    ),
                    Divider(color: Colors.white.withValues(alpha: 0.05)),
                    SwitchListTile.adaptive(
                      title: Text(
                        'Push Notifications',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Alerts for match invitations and friend requests',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      value: _notifsEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _notifsEnabled = val),
                    ),
                  ],
                ),
              ).animate().fade(duration: 450.ms, delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
