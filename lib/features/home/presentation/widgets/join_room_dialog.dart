import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/home_providers.dart';

class JoinRoomDialog extends ConsumerStatefulWidget {
  const JoinRoomDialog({super.key});

  @override
  ConsumerState<JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends ConsumerState<JoinRoomDialog> {
  final _codeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _joinRoom() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _errorMessage = null);

    final code = _codeCtrl.text.trim().toUpperCase();
    final room = await ref.read(roomActionProvider.notifier).joinRoomByCode(code);

    if (room != null && mounted) {
      context.pop(); // Close dialog
      context.goNamed(
        'roomLobby',
        pathParameters: {'roomId': room.id.toString()},
      );
    } else if (mounted) {
      final actionState = ref.read(roomActionProvider);
      setState(() {
        _errorMessage = actionState.error?.toString() ?? 'Room not found or invalid code';
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Join Table', style: AppTextStyles.headlineSmall),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: isLoading ? null : () => context.pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Enter the 6-character room code to join:',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // -------------------------------------------------------
              // Pin/Code text field
              // -------------------------------------------------------
              AppTextField(
                controller: _codeCtrl,
                label: 'Room Code',
                hint: 'e.g. AB12CD',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Code is required';
                  }
                  if (val.trim().length != 6) {
                    return 'Code must be exactly 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],

              // -------------------------------------------------------
              // Join Button
              // -------------------------------------------------------
              AppButton(
                label: 'Join Table',
                isLoading: isLoading,
                onPressed: isLoading ? null : _joinRoom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
