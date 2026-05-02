import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.height = 56,
    this.expand = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final double height;
  final bool expand;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == AppButtonVariant.primary;
    final isGhost = variant == AppButtonVariant.ghost;
    final foreground = isPrimary ? AppColors.white : AppColors.charcoal;

    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: isPrimary
            ? null
            : (isGhost ? Colors.transparent : AppColors.glass),
        gradient: isPrimary ? AppGradients.coralButton : null,
        borderRadius: AppRadius.pillBorder,
        boxShadow: isPrimary ? AppShadows.primaryButton : null,
        border: isGhost
            ? null
            : Border.all(color: AppColors.white.withValues(alpha: 0.65)),
      ),
      child: SizedBox(
        height: height,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(foreground),
                  ),
                )
              else if (icon != null) ...[
                Icon(icon, color: foreground, size: 20),
                const SizedBox(width: 10),
              ],
              if (isLoading && icon != null) const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.button.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Opacity(
      opacity: (onPressed == null || isLoading) ? 0.65 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.pillBorder,
          onTap: isLoading ? null : onPressed,
          child: expand
              ? SizedBox(width: double.infinity, child: child)
              : child,
        ),
      ),
    );
  }
}
