import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/groups_providers.dart';
import '../../data/models/group_model.dart';

class GroupsListScreen extends ConsumerStatefulWidget {
  const GroupsListScreen({super.key});

  @override
  ConsumerState<GroupsListScreen> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends ConsumerState<GroupsListScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => const _CreateGroupDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsProvider);

    return AppScaffold(
      currentTab: AppTab.groups,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Groups', style: AppTextStyles.titleMedium),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 28),
              onPressed: _showCreateGroupDialog,
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: AppTextField(
                controller: _searchCtrl,
                label: 'Search Groups',
                hint: 'Search by group name...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim().toLowerCase();
                  });
                },
              ),
            ),
            const SizedBox(height: 8),

            // Groups Grid/List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(groupsProvider.notifier).fetchGroups(),
                color: AppColors.primary,
                backgroundColor: AppColors.surface,
                child: groupsAsync.when(
                  data: (groups) {
                    final filtered = groups.where((g) {
                      return g.name.toLowerCase().contains(_searchQuery);
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.group_work_rounded,
                                  size: 64,
                                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isEmpty ? 'No groups yet' : 'No matching groups found',
                                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 8),
                                if (_searchQuery.isEmpty)
                                  SizedBox(
                                    width: 160,
                                    height: 36,
                                    child: AppButton(
                                      label: 'Create first group',
                                      onPressed: _showCreateGroupDialog,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(20),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final group = filtered[index];
                        return _buildGroupCard(group)
                            .animate()
                            .fade(duration: 250.ms, delay: (index * 40).ms)
                            .slideY(begin: 0.05, duration: 250.ms, delay: (index * 40).ms);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Failed to load groups', style: TextStyle(color: AppColors.error)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => ref.read(groupsProvider.notifier).fetchGroups(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(GroupModel group) {
    final isPublic = group.groupType == 'public';

    return GestureDetector(
      onTap: () => context.push('/groups/${group.id}'),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white10,
              backgroundImage: group.avatarUrl != null ? NetworkImage(group.avatarUrl!) : null,
              child: group.avatarUrl == null
                  ? const Icon(Icons.group_rounded, color: Colors.white70)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.name,
                          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPublic
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.gold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isPublic
                                ? AppColors.success.withValues(alpha: 0.3)
                                : AppColors.gold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          isPublic ? 'Public' : 'Private',
                          style: TextStyle(
                            color: isPublic ? AppColors.success : AppColors.gold,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    group.description ?? 'No description provided.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.people_outline_rounded, size: 14, color: Colors.white54),
                      const SizedBox(width: 4),
                      Text(
                        '${group.membersCount} members',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _CreateGroupDialog extends ConsumerStatefulWidget {
  const _CreateGroupDialog();

  @override
  ConsumerState<_CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends ConsumerState<_CreateGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedType = 'public';
  String _selectedAvatar = 'https://api.dicebear.com/7.x/identicon/png?seed=Group1';
  bool _isLoading = false;

  final List<String> _seeds = ['Group1', 'Group2', 'Group3', 'Group4', 'Group5'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await ref.read(groupsProvider.notifier).createGroup(
          name: _nameCtrl.text.trim(),
          description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          avatarUrl: _selectedAvatar,
          groupType: _selectedType,
        );

    setState(() => _isLoading = false);

    if (mounted) {
      if (result != null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Group "${result.name}" created!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create group. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create New Group',
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Avatar seeds
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white10,
                      backgroundImage: NetworkImage(_selectedAvatar),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _seeds.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final seed = _seeds[index];
                          final url = 'https://api.dicebear.com/7.x/identicon/png?seed=$seed';
                          final isSelected = url == _selectedAvatar;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedAvatar = url),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(url),
                              child: isSelected
                                  ? Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black45,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check, size: 14, color: Colors.white),
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              AppTextField(
                controller: _nameCtrl,
                label: 'Group Name',
                hint: 'Enter group name',
                validator: (val) => val == null || val.trim().isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _descCtrl,
                label: 'Description',
                hint: 'Describe the group purpose...',
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Group Type
              Text(
                'Group Privacy',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Public', style: TextStyle(color: Colors.white, fontSize: 14)),
                      value: 'public',
                      groupValue: _selectedType,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _selectedType = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Private', style: TextStyle(color: Colors.white, fontSize: 14)),
                      value: 'private',
                      groupValue: _selectedType,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _selectedType = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: AppButton(
                      label: 'Create',
                      isLoading: _isLoading,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
