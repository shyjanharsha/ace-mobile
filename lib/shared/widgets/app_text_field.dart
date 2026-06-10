import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';

/// Styled text input field with glass fill
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final bool enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:        controller,
      obscureText:       obscureText,
      keyboardType:      keyboardType,
      validator:         validator,
      onChanged:         onChanged,
      onFieldSubmitted:  onSubmitted,
      maxLines:          maxLines,
      enabled:           enabled,
      textInputAction:   textInputAction,
      focusNode:         focusNode,
      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
      cursorColor: AppColors.primary,
      decoration: AppDecorations.inputDecoration(
        label:       label,
        hint:        hint,
        prefixIcon:  prefixIcon,
        suffixIcon:  suffixIcon,
      ),
    );
  }
}
