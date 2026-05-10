import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    super.key,
    this.icon,
    this.selected = false,
    this.color,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fill = color ?? (selected ? AppColors.coral : AppColors.glassSoft);
    final foreground = selected ? AppColors.white : AppColors.charcoal;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.pillBorder,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: AppRadius.pillBorder,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: foreground, size: 15),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTextStyles.chip.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
