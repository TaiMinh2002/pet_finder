import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../bloc/map_state.dart';

class MapFilterChips extends StatelessWidget {
  const MapFilterChips({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final MapFilterType activeFilter;
  final ValueChanged<MapFilterType> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: context.l10n.mapFilterLost,
            isActive: activeFilter == MapFilterType.lost,
            activeColor: AppColors.coral,
            onTap: () => onFilterChanged(MapFilterType.lost),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: context.l10n.mapFilterSeen,
            isActive: activeFilter == MapFilterType.seen,
            activeColor: AppColors.muted,
            onTap: () => onFilterChanged(MapFilterType.seen),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: context.l10n.mapFilterFound,
            isActive: activeFilter == MapFilterType.found,
            activeColor: AppColors.teal,
            onTap: () => onFilterChanged(MapFilterType.found),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: context.l10n.mapFilterUrgent,
            isActive: activeFilter == MapFilterType.urgent,
            activeColor: const Color(0xFFFFB84D),
            onTap: () => onFilterChanged(MapFilterType.urgent),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.floating,
        ),
        child: Text(
          label,
          style: AppTextStyles.chip.copyWith(
            color: isActive ? AppColors.white : AppColors.charcoal,
          ),
        ),
      ),
    );
  }
}
