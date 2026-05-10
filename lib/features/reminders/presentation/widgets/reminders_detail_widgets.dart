import 'package:flutter/material.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_image_widgets.dart';
import '../../../pets/domain/pet_model.dart';
import '../../domain/reminder_model.dart';
import 'reminders_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class ReminderDetailHero extends StatelessWidget {
  const ReminderDetailHero({
    required this.reminder,
    required this.pet,
    super.key,
  });

  final ReminderModel reminder;
  final PetModel pet;

  @override
  Widget build(BuildContext context) {
    final meta = reminderCategoryMeta(context, reminder.category);

    return AppCard(
      color: AppColors.glass,
      radius: 34,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(36),
            ),
            child: const AppEmptyStateIllustration(
              assetPath: AppImages.remindersSupport,
              size: 128,
              borderRadius: BorderRadius.all(Radius.circular(36)),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            reminder.title,
            style: AppTextStyles.heroTitle.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 6),
          Text(
            meta.label,
            style: AppTextStyles.body.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class ReminderPetInfoCard extends StatelessWidget {
  const ReminderPetInfoCard({required this.pet, super.key});

  final PetModel pet;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white.withValues(alpha: 0.84),
      radius: 28,
      shadow: AppShadows.softCard,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AppCircularImage(
            assetPath: pet.photoUrl ?? AppImages.petCardFor(pet.type),
            size: 58,
            semanticLabel: pet.name,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pet.name, style: AppTextStyles.title),
                const SizedBox(height: 4),
                Text(
                  '${pet.breed} • ${pet.ageLabel}',
                  style: AppTextStyles.body.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          AppChip(label: pet.careStatus, color: AppColors.fieldCool),
        ],
      ),
    );
  }
}

class ReminderInfoCard extends StatelessWidget {
  const ReminderInfoCard({required this.title, required this.rows, super.key});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 28,
      shadow: AppShadows.softCard,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 14),
          for (var index = 0; index < rows.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    rows[index].$1,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    rows[index].$2,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.bodyStrong,
                  ),
                ),
              ],
            ),
            if (index != rows.length - 1) ...[
              const SizedBox(height: 12),
              Divider(color: AppColors.charcoal.withValues(alpha: 0.08)),
              const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    );
  }
}

class ReminderActionButtonRow extends StatelessWidget {
  const ReminderActionButtonRow({
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
    super.key,
    this.isCompleting = false,
    this.isDeleting = false,
  });

  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isCompleting;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          label: context.l10n.reminderDetailMarkCompleted,
          icon: Icons.check_circle_outline,
          onPressed: onComplete,
          isLoading: isCompleting,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: context.l10n.reminderDetailEdit,
                icon: Icons.edit_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: onEdit,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppButton(
                label: context.l10n.reminderDetailDelete,
                icon: Icons.delete_outline,
                variant: AppButtonVariant.ghost,
                onPressed: onDelete,
                isLoading: isDeleting,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ReminderSuccessCard extends StatelessWidget {
  const ReminderSuccessCard({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 34,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Container(
            width: 136,
            height: 136,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(38),
            ),
            child: const AppEmptyStateIllustration(
              assetPath: AppImages.remindersSupport,
              size: 136,
              borderRadius: BorderRadius.all(Radius.circular(38)),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            context.l10n.reminderCompletedTitle,
            style: AppTextStyles.heroTitle.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.reminderCompletedDesc,
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 22),
          AppButton(label: context.l10n.reminderDetailBack, onPressed: onBack),
        ],
      ),
    );
  }
}
