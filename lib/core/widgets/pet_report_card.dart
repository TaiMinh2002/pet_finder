import 'package:flutter/material.dart';

import '../../app/assets/app_images.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';
import '../localization/localization_extensions.dart';
import '../../features/reports/domain/pet_report_model.dart';
import 'app_image_widgets.dart';
import 'app_card.dart';
import 'status_badge.dart';

class PetReportCard extends StatelessWidget {
  const PetReportCard({required this.report, super.key, this.onTap});

  final PetReportModel report;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isLost = report.type == PetReportType.lost;
    final badgeType = switch (report.type) {
      PetReportType.lost => StatusBadgeType.lost,
      PetReportType.found => StatusBadgeType.found,
      PetReportType.reunited => StatusBadgeType.reunited,
    };

    return InkWell(
      borderRadius: AppRadius.cardBorder,
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(14),
        radius: 26,
        child: Row(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: AppRadius.lgBorder,
              ),
              child: AppThumbnailImage(
                assetPath:
                    report.photoUrl ?? AppImages.reportThumbFor(report.type),
                size: 76,
                borderRadius: AppRadius.lgBorder,
                semanticLabel: report.petName,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusBadge(
                        label: isLost
                            ? context.l10n.homeCategoryLost
                            : context.l10n.homeCategoryFound,
                        type: badgeType,
                      ),
                      const Spacer(),
                      Text(report.distanceLabel, style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(report.petName, style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 4),
                  Text(
                    '${report.breed} • ${report.locationLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    report.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
