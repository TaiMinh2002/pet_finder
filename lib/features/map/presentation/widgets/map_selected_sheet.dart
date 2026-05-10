import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../models/map_marker_data.dart';
import '../../models/map_marker_type.dart';

class MapSelectedSheet extends StatelessWidget {
  const MapSelectedSheet({
    super.key,
    required this.marker,
    required this.onDismiss,
    required this.onViewDetails,
    required this.onContact,
    required this.onNavigate,
  });

  final MapMarkerData marker;
  final VoidCallback onDismiss;
  final VoidCallback onViewDetails;
  final VoidCallback onContact;
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFF4).withValues(alpha: 0.97),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.charcoal.withValues(alpha: 0.15),
            blurRadius: 34,
            offset: const Offset(0, -12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.handle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _TypeBadge(type: marker.type),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        marker.petName,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onDismiss,
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.muted,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.place_rounded,
                      size: 14,
                      color: AppColors.coral,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${marker.distanceLabel} ${context.l10n.mapAway}',
                      style: AppTextStyles.bodyStrong.copyWith(
                        fontSize: 13,
                        color: AppColors.coral,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(marker.lastSeenLabel, style: AppTextStyles.caption),
                if (marker.petDescription != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    marker.petDescription!,
                    style: AppTextStyles.body.copyWith(fontSize: 13),
                  ),
                ],
                const SizedBox(height: 16),
                _ActionButtons(
                  onViewDetails: onViewDetails,
                  onContact: onContact,
                  onNavigate: onNavigate,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final MapMarkerType type;

  @override
  Widget build(BuildContext context) {
    final label = switch (type) {
      MapMarkerType.lost => context.l10n.mapBadgeLost,
      MapMarkerType.found => context.l10n.mapBadgeFound,
      MapMarkerType.urgent => context.l10n.mapBadgeUrgent,
      MapMarkerType.reunited => context.l10n.mapBadgeReunited,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: type.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onViewDetails,
    required this.onContact,
    required this.onNavigate,
  });

  final VoidCallback onViewDetails;
  final VoidCallback onContact;
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _ActionButton(
            label: context.l10n.mapViewDetails,
            color: AppColors.coral,
            textColor: AppColors.white,
            onTap: onViewDetails,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            label: context.l10n.mapContact,
            color: AppColors.white,
            textColor: AppColors.charcoal,
            hasBorder: true,
            onTap: onContact,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            label: context.l10n.mapNavigate,
            color: AppColors.white,
            textColor: AppColors.charcoal,
            hasBorder: true,
            onTap: onNavigate,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.hasBorder = false,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: hasBorder ? null : AppShadows.primaryButton,
          border: hasBorder
              ? Border.all(
                  color: AppColors.charcoal.withValues(alpha: 0.15),
                  width: 1,
                )
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.chip.copyWith(color: textColor, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
