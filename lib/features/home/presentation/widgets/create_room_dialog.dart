import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/home_providers.dart';

class CreateRoomDialog extends ConsumerStatefulWidget {
  const CreateRoomDialog({super.key});

  @override
  ConsumerState<CreateRoomDialog> createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends ConsumerState<CreateRoomDialog> {
  int _maxPlayers = 4;
  int _betCoins = 100;
  bool _isPublic = true;
  String? _errorMessage;

  final List<int> _wagerOptions = [50, 100, 250, 500, 1000];

  Future<void> _createRoom() async {
    setState(() => _errorMessage = null);

    final room = await ref.read(roomActionProvider.notifier).createRoom(
          roomType: _isPublic ? 'public' : 'private',
          maxPlayers: _maxPlayers,
          minPlayers: 2,
          betCoins: _betCoins,
          moveTimeout: 30,
          allowSpectators: true,
        );

    if (room != null && mounted) {
      context.pop(); // Close dialog
      context.goNamed(
        'roomLobby',
        pathParameters: {'roomId': room.id.toString()},
      );
    } else if (mounted) {
      final actionState = ref.read(roomActionProvider);
      setState(() {
        _errorMessage = actionState.error?.toString() ?? 'Failed to create room';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(roomActionProvider);
    final isLoading = actionState.isLoading;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Host New Table', style: AppTextStyles.headlineSmall),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: isLoading ? null : () => context.pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // -------------------------------------------------------
            // Room Type: Public vs Private
            // -------------------------------------------------------
            Text('Table Type', style: AppTextStyles.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _TypeButton(
                    label: 'Public',
                    icon: Icons.public,
                    isSelected: _isPublic,
                    onTap: () => setState(() => _isPublic = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TypeButton(
                    label: 'Private',
                    icon: Icons.lock_outline_rounded,
                    isSelected: !_isPublic,
                    onTap: () => setState(() => _isPublic = false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // -------------------------------------------------------
            // Max Players Slider
            // -------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Max Players', style: AppTextStyles.titleSmall),
                Text(
                  '$_maxPlayers Players',
                  style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.glassBorder,
                thumbColor: AppColors.primary,
                overlayColor: AppColors.primary.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: _maxPlayers.toDouble(),
                min: 2,
                max: 8,
                divisions: 6,
                onChanged: isLoading
                    ? null
                    : (val) => setState(() => _maxPlayers = val.round()),
              ),
            ),
            const SizedBox(height: 12),

            // -------------------------------------------------------
            // Bet/Wager Coins selection
            // -------------------------------------------------------
            Text('Entry Wager (Coins)', style: AppTextStyles.titleSmall),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _wagerOptions.map((opt) {
                  final isSelected = _betCoins == opt;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        '$opt',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.gold,
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      side: BorderSide(
                        color: isSelected ? AppColors.gold : AppColors.glassBorder,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSelected: isLoading
                          ? null
                          : (selected) {
                              if (selected) setState(() => _betCoins = opt);
                            },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],

            // -------------------------------------------------------
            // Create Button
            // -------------------------------------------------------
            AppButton(
              label: 'Create Table',
              isLoading: isLoading,
              onPressed: isLoading ? null : _createRoom,
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.glassBorder,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : Colors.white54, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
