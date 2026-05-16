import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    super.key,
    this.hint,
    this.icon,
    this.suffixIcon,
    this.controller,
    this.maxLines = 1,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.required = false,
    this.errorText,
    this.onChanged,
    this.dismissKeyboardOnTapOutside = true,
  });

  final String label;
  final String? hint;
  final IconData? icon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final int maxLines;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool required;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool dismissKeyboardOnTapOutside;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.caption.copyWith(color: AppColors.charcoal),
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.coralDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
          onTapOutside: dismissKeyboardOnTapOutside
              ? (_) => FocusManager.instance.primaryFocus?.unfocus()
              : null,
          maxLines: maxLines,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: AppTextStyles.bodyStrong,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.caption.copyWith(
              color: AppColors.muted.withValues(alpha: 0.65),
            ),
            prefixIcon: icon == null
                ? null
                : Icon(icon, color: AppColors.coral, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.fieldWarm,
            border: OutlineInputBorder(
              borderRadius: AppRadius.mdBorder,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.mdBorder,
              borderSide: BorderSide(
                color: errorText == null ? Colors.transparent : AppColors.coral,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.mdBorder,
              borderSide: BorderSide(
                color: errorText == null
                    ? AppColors.coral
                    : AppColors.coralDark,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: AppTextStyles.caption.copyWith(color: AppColors.coralDark),
          ),
        ],
      ],
    );
  }
}
