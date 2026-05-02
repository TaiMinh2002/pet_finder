import 'package:flutter/material.dart';

import '../../app/assets/app_images.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';
import '../localization/localization_extensions.dart';
import '../../features/pets/domain/pet_model.dart';
import 'app_card.dart';
import 'app_chip.dart';
import 'app_image_widgets.dart';

class PetProfileCard extends StatelessWidget {
  const PetProfileCard({
    required this.pet,
    super.key,
    this.onTap,
    this.onReportLost,
  });

  final PetModel pet;
  final VoidCallback? onTap;
  final VoidCallback? onReportLost;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.cardLargeBorder,
      onTap: onTap,
      child: AppCard(
        color: AppColors.white,
        radius: AppRadius.cardLarge,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.lostSoft,
                    borderRadius: AppRadius.lgBorder,
                  ),
                  child: AppThumbnailImage(
                    assetPath: pet.photoUrl ?? AppImages.petCardFor(pet.type),
                    size: 72,
                    borderRadius: AppRadius.lgBorder,
                    semanticLabel: pet.name,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pet.name, style: AppTextStyles.sectionTitle),
                      const SizedBox(height: 4),
                      Text(
                        '${pet.breed} • ${pet.ageLabel}',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          AppChip(
                            label: pet.careStatus,
                            color: AppColors.fieldCool,
                          ),
                          AppChip(
                            label: pet.profileStatus,
                            color: AppColors.cream,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${pet.gender} • ${pet.color}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.charcoal,
                    ),
                  ),
                ),
                if (onReportLost != null)
                  TextButton.icon(
                    onPressed: onReportLost,
                    icon: const Icon(
                      Icons.campaign_outlined,
                      color: AppColors.coral,
                      size: 16,
                    ),
                    label: Text(
                      context.l10n.petWidgetReportLost,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.coralDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
