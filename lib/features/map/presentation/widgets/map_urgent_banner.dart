import 'package:flutter/material.dart';

import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../models/map_marker_data.dart';

class MapUrgentBanner extends StatelessWidget {
  const MapUrgentBanner({super.key, required this.marker});

  final MapMarkerData marker;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0D6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x66FFB84D), width: 1),
        boxShadow: AppShadows.floating,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0x33FFB84D),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFFFB84D),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.mapUrgentNearbyAlert,
                  style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
                ),
                Text(
                  marker.lastSeenLabel,
                  style: AppTextStyles.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
