import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../friends/presentation/providers/friends_providers.dart';
import '../providers/profile_providers.dart';

class ContactSyncScreen extends ConsumerStatefulWidget {
  const ContactSyncScreen({super.key});

  @override
  ConsumerState<ContactSyncScreen> createState() => _ContactSyncScreenState();
}

class _ContactSyncScreenState extends ConsumerState<ContactSyncScreen> {
  final List<String> _mockPhoneNumbers = [
    '+919876543210',
    '+919988776655',
    '+918877665544',
    '+917766554433',
    '+916655443322',
  ];

  void _triggerSync() {
    ref.read(contactSyncProvider.notifier).syncContacts(_mockPhoneNumbers);
  }

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(contactSyncProvider);
    final friendActionState = ref.watch(friendActionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Sync Contacts', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Intro Info Card
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.contact_phone_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.1, 1.1),
                          duration: 1.5.seconds,
                        ),
                    const SizedBox(height: 16),
                    Text(
                      'Find Friends from your Phone',
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sync your local contact list to instantly find and connect with friends who are playing Kazhutha Kali!',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: syncState.isLoading ? 'Syncing...' : 'Sync Device Contacts',
                      isLoading: syncState.isLoading,
                      onPressed: _triggerSync,
                    ),
                  ],
                ),
              ).animate().fade(duration: 300.ms),

              const SizedBox(height: 24),

              // Results List
              Expanded(
                child: syncState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : syncState.matchedContacts.isEmpty
                        ? Center(
                            child: Text(
                              syncState.totalSynced > 0
                                  ? 'No registered users found in contacts.'
                                  : 'Tap "Sync Device Contacts" to scan.',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Matched Players (${syncState.matchedContacts.length})',
                                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: syncState.matchedContacts.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final contact = syncState.matchedContacts[index];
                                    final username = contact['username'] ?? '';
                                    final displayName = contact['display_name'] ?? '';
                                    final avatarUrl = contact['avatar_url'];
                                    final userId = contact['id'] as int;

                                    return GlassCard(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      child: Row(
                                        children: [
                                          UserAvatar(
                                            avatarUrl: avatarUrl,
                                            username: username,
                                            showStatus: false,
                                            size: 40,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  displayName.isNotEmpty ? displayName : username,
                                                  style: AppTextStyles.bodyMedium.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '@$username',
                                                  style: AppTextStyles.bodySmall.copyWith(
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          SizedBox(
                                            width: 110,
                                            height: 32,
                                            child: AppButton(
                                              label: 'Add Friend',
                                              isLoading: friendActionState.isLoading,
                                              onPressed: () async {
                                                await ref
                                                    .read(friendActionProvider.notifier)
                                                    .sendFriendRequest(userId);
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Request sent to ${displayName.isNotEmpty ? displayName : username}',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                        .animate()
                                        .fade(duration: 250.ms, delay: (index * 40).ms)
                                        .slideY(begin: 0.05, duration: 250.ms, delay: (index * 40).ms);
                                  },
                                ),
                              ),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
