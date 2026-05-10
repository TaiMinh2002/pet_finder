import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../models/map_marker_data.dart';
import '../../models/map_marker_type.dart';

class MapBottomPreviewCard extends StatelessWidget {
  const MapBottomPreviewCard({
    super.key,
    required this.marker,
    required this.onTap,
  });

  final MapMarkerData marker;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4E6),
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppShadows.raisedCard,
          border: Border.all(
            color: AppColors.peach.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            _PetThumbnail(type: marker.type),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _TypeBadge(type: marker.type),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${marker.petName} · ${marker.distanceLabel} ${context.l10n.mapAway}',
                          style: AppTextStyles.bodyStrong.copyWith(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (marker.petDescription != null)
                    Text(
                      marker.petDescription!,
                      style: AppTextStyles.body.copyWith(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.place_rounded,
                        size: 12,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        marker.locationLabel,
                        style: AppTextStyles.caption.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: AppRadius.cardBorder,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetThumbnail extends StatelessWidget {
  const _PetThumbnail({required this.type});

  final MapMarkerType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.peach, type.color.withValues(alpha: 0.6)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(Icons.pets_rounded, color: type.color, size: 28),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: type.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.white,
          fontSize: 10,
        ),
      ),
    );
  }
}
