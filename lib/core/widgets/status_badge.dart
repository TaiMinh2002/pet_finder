import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';

enum StatusBadgeType { lost, found, reunited, active }

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.label, required this.type, super.key});

  final String label;
  final StatusBadgeType type;

  @override
  Widget build(BuildContext context) {
    final colors = switch (type) {
      StatusBadgeType.lost => (AppColors.lostSoft, AppColors.coral),
      StatusBadgeType.found => (AppColors.fieldCool, AppColors.teal),
      StatusBadgeType.reunited => (AppColors.successSoft, AppColors.green),
      StatusBadgeType.active => (AppColors.charcoal, AppColors.white),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: AppRadius.pillBorder,
      ),
      child: Text(label, style: AppTextStyles.chip.copyWith(color: colors.$2)),
    );
  }
}
