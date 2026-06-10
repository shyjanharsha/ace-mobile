import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';

enum AppButtonVariant { primary, outlined, ghost, gold }

/// Reusable animated button with primary/outlined/ghost/gold variants
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final AppButtonVariant variant;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.width,
    this.height = 52,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!isDisabled) widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.6 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            width: widget.width ?? double.infinity,
            height: widget.height,
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return switch (widget.variant) {
      AppButtonVariant.primary => _PrimaryButton(
          label:     widget.label,
          icon:      widget.icon,
          isLoading: widget.isLoading,
        ),
      AppButtonVariant.gold => _GoldButton(
          label:     widget.label,
          icon:      widget.icon,
          isLoading: widget.isLoading,
        ),
      AppButtonVariant.outlined => _OutlinedButton(
          label:     widget.label,
          icon:      widget.icon,
          isLoading: widget.isLoading,
        ),
      AppButtonVariant.ghost => _GhostButton(
          label: widget.label,
          icon:  widget.icon,
        ),
    };
  }
}

// -------------------------------------------------------
// Primary gradient button
// -------------------------------------------------------
class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;

  const _PrimaryButton({required this.label, this.icon, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.primaryButton(),
      child: _ButtonInner(
        label:     label,
        icon:      icon,
        isLoading: isLoading,
        textColor: Colors.white,
      ),
    );
  }
}

// -------------------------------------------------------
// Gold button (wagered rooms)
// -------------------------------------------------------
class _GoldButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;

  const _GoldButton({required this.label, this.icon, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.goldButton(),
      child: _ButtonInner(
        label:     label,
        icon:      icon,
        isLoading: isLoading,
        textColor: Colors.black,
        iconColor: Colors.black,
      ),
    );
  }
}

// -------------------------------------------------------
// Outlined button
// -------------------------------------------------------
class _OutlinedButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;

  const _OutlinedButton({required this.label, this.icon, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 1.5),
        color: AppColors.primary.withValues(alpha: 0.08),
      ),
      child: _ButtonInner(
        label:     label,
        icon:      icon,
        isLoading: isLoading,
        textColor: AppColors.primary,
        iconColor: AppColors.primary,
      ),
    );
  }
}

// -------------------------------------------------------
// Ghost button (text only)
// -------------------------------------------------------
class _GhostButton extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _GhostButton({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return _ButtonInner(
      label:     label,
      icon:      icon,
      isLoading: false,
      textColor: AppColors.textSecondary,
      iconColor: AppColors.textSecondary,
    );
  }
}

// -------------------------------------------------------
// Shared inner content
// -------------------------------------------------------
class _ButtonInner extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;
  final Color textColor;
  final Color? iconColor;

  const _ButtonInner({
    required this.label,
    this.icon,
    required this.isLoading,
    required this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(textColor),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: iconColor ?? textColor, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTextStyles.labelLarge.copyWith(color: textColor),
                ),
              ],
            ),
    );
  }
}
