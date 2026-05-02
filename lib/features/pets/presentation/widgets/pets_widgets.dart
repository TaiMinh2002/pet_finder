import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/pet_model.dart';

class PetsScaffold extends StatelessWidget {
  const PetsScaffold({required this.child, super.key, this.bottomNav = true});

  final Widget child;
  final bool bottomNav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const _PetsBackdrop(),
              child,
              if (bottomNav)
                const Positioned(
                  left: 18,
                  right: 18,
                  bottom: 22,
                  child: PetsBottomNavigation(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PetsBottomNavigation extends StatelessWidget {
  const PetsBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      AppBottomNavItem(
        icon: Icons.home_rounded,
        label: context.l10n.commonHome,
      ),
      AppBottomNavItem(icon: Icons.map_outlined, label: context.l10n.commonMap),
      AppBottomNavItem(icon: Icons.pets, label: context.l10n.commonPets),
      AppBottomNavItem(
        icon: Icons.person_outline,
        label: context.l10n.commonProfile,
      ),
    ];
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        AppBottomNav(
          currentIndex: 2,
          onChanged: (index) {
            if (index == 0) {
              context.goNamed(AppRoute.home.name);
            } else if (index == 1) {
              context.goNamed(AppRoute.mapNearby.name);
            } else if (index == 2) {
              context.goNamed(AppRoute.petsList.name);
            } else if (index == 3) {
              context.goNamed(AppRoute.profileOverview.name);
            }
          },
          items: items,
        ),
        Positioned(
          top: -18,
          child: InkWell(
            borderRadius: AppRadius.pillBorder,
            onTap: () => context.goNamed(AppRoute.petsAdd.name),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.coral,
                shape: BoxShape.circle,
                boxShadow: AppShadows.primaryButton,
                border: Border.all(color: AppColors.white, width: 4),
              ),
              child: const Icon(Icons.add, color: AppColors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}

class PetsHeader extends StatelessWidget {
  const PetsHeader({
    required this.title,
    required this.subtitle,
    super.key,
    this.leading,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 14)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.heroTitle.copyWith(
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: AppTextStyles.body.copyWith(fontSize: 13)),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}

class CircleGlassButton extends StatelessWidget {
  const CircleGlassButton({required this.icon, required this.onTap, super.key});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.pillBorder,
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: AppRadius.cardBorder,
          boxShadow: AppShadows.floating,
        ),
        child: Icon(icon, color: AppColors.charcoal, size: 20),
      ),
    );
  }
}

class PetHeroCard extends StatelessWidget {
  const PetHeroCard({required this.pet, super.key, this.height = 304});

  final PetModel pet;
  final double height;

  @override
  Widget build(BuildContext context) {
    final accent = pet.type == PetType.dog ? AppColors.coral : AppColors.teal;

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: pet.type == PetType.dog
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.peach, AppColors.cream, AppColors.white],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDDF7F6), AppColors.cream, AppColors.white],
              ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 24,
            top: 28,
            child: Icon(
              Icons.pets,
              color: accent.withValues(alpha: 0.14),
              size: 72,
            ),
          ),
          Positioned(
            left: 36,
            top: 84,
            child: _PetPortrait(
              accent: accent,
              size: 172,
              icon: Icons.pets,
              imagePath: pet.photoUrl ?? AppImages.petHeroFor(pet.type),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 26,
            child: AppChip(label: pet.careStatus, color: AppColors.glassStrong),
          ),
        ],
      ),
    );
  }
}

class PetProfileFormCard extends StatelessWidget {
  const PetProfileFormCard({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 28,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class PetUploadCard extends StatelessWidget {
  const PetUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 30,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.55),
              borderRadius: AppRadius.cardBorder,
              border: Border.all(color: AppColors.white.withValues(alpha: 0.8)),
            ),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.lostSoft,
                    borderRadius: AppRadius.lgBorder,
                  ),
                  child: AppAssetImage(
                    assetPath: AppImages.petsDogHero,
                    borderRadius: AppRadius.lgBorder,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  context.l10n.petWidgetAddPhotos,
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.petWidgetPhotosDesc,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: context.l10n.petWidgetCamera,
                  onPressed: () {},
                  icon: Icons.photo_camera_outlined,
                  height: 48,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: context.l10n.petWidgetGallery,
                  onPressed: () {},
                  icon: Icons.collections_outlined,
                  height: 48,
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PseudoField extends StatelessWidget {
  const PseudoField({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.mdBorder,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.fieldWarm,
          borderRadius: AppRadius.mdBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.charcoal),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text(value, style: AppTextStyles.bodyStrong)),
                Icon(icon, color: AppColors.coral, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceChipPill extends StatelessWidget {
  const ChoiceChipPill({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: label,
      selected: selected,
      onTap: onTap,
      color: selected ? null : AppColors.white,
    );
  }
}

class PetsEmptyCard extends StatelessWidget {
  const PetsEmptyCard({required this.onAdd, super.key});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          color: AppColors.glassSoft,
          radius: 34,
          shadow: AppShadows.raisedCard,
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const _PetPortrait(
                accent: AppColors.coral,
                size: 150,
                icon: Icons.pets,
                imagePath: AppImages.petsCatHero,
              ),
              const SizedBox(height: 20),
              EmptyState(
                title: context.l10n.petWidgetAddFirst,
                message: context.l10n.petWidgetKeepInfo,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        AppButton(
          label: context.l10n.petWidgetAddBtn,
          onPressed: onAdd,
          icon: Icons.add,
        ),
      ],
    );
  }
}

class ReminderTag extends StatelessWidget {
  const ReminderTag({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: AppRadius.pillBorder,
        boxShadow: AppShadows.floating,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_month, color: AppColors.teal, size: 16),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.chip),
        ],
      ),
    );
  }
}

class EmergencyCard extends StatelessWidget {
  const EmergencyCard({
    required this.onReportLost,
    required this.onEdit,
    super.key,
  });

  final VoidCallback onReportLost;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 28,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.petWidgetMissingAlert,
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.petWidgetPrefillDesc,
            style: AppTextStyles.body.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: context.l10n.petWidgetReportLost,
                  onPressed: onReportLost,
                  icon: Icons.campaign_outlined,
                  height: 48,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: context.l10n.petWidgetEditBtn,
                  onPressed: onEdit,
                  icon: Icons.edit_outlined,
                  height: 48,
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    required this.title,
    required this.rows,
    super.key,
  });

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 28,
      shadow: AppShadows.softCard,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          for (var i = 0; i < rows.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(rows[i].$1, style: AppTextStyles.caption),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 6,
                  child: Text(
                    rows[i].$2,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
            if (i != rows.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class PetFormFields extends StatelessWidget {
  const PetFormFields({
    required this.nameController,
    required this.breedController,
    required this.colorController,
    required this.weightController,
    required this.marksController,
    required this.microchipController,
    required this.vaccinationController,
    required this.notesController,
    required this.typeValue,
    required this.genderValue,
    required this.ageValue,
    required this.reminderValue,
    required this.onTypeChanged,
    required this.onGenderChanged,
    required this.onAgeChanged,
    required this.onReminderChanged,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController breedController;
  final TextEditingController colorController;
  final TextEditingController weightController;
  final TextEditingController marksController;
  final TextEditingController microchipController;
  final TextEditingController vaccinationController;
  final TextEditingController notesController;
  final String typeValue;
  final String genderValue;
  final String ageValue;
  final bool reminderValue;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<String> onAgeChanged;
  final ValueChanged<bool> onReminderChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PetUploadCard(),
        const SizedBox(height: 16),
        PetProfileFormCard(
          title: context.l10n.petWidgetBasicInfo,
          children: [
            AppTextField(
              label: context.l10n.petWidgetName,
              hint: context.l10n.petHintName,
              icon: Icons.pets,
              controller: nameController,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: PseudoField(
                    label: context.l10n.petWidgetType,
                    value: typeValue,
                    icon: Icons.arrow_drop_down,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PseudoField(
                    label: context.l10n.petWidgetGender,
                    value: genderValue,
                    icon: Icons.arrow_drop_down,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChipPill(
                  label: context.l10n.petWidgetTypeDog,
                  selected: typeValue == context.l10n.petWidgetTypeDog,
                  onTap: () => onTypeChanged(context.l10n.petWidgetTypeDog),
                ),
                ChoiceChipPill(
                  label: context.l10n.petWidgetTypeCat,
                  selected: typeValue == context.l10n.petWidgetTypeCat,
                  onTap: () => onTypeChanged(context.l10n.petWidgetTypeCat),
                ),
                ChoiceChipPill(
                  label: context.l10n.petWidgetTypeOther,
                  selected: typeValue == context.l10n.petWidgetTypeOther,
                  onTap: () => onTypeChanged(context.l10n.petWidgetTypeOther),
                ),
                ChoiceChipPill(
                  label: context.l10n.petWidgetGenderFemale,
                  selected: genderValue == context.l10n.petWidgetGenderFemale,
                  onTap: () =>
                      onGenderChanged(context.l10n.petWidgetGenderFemale),
                ),
                ChoiceChipPill(
                  label: context.l10n.petWidgetGenderMale,
                  selected: genderValue == context.l10n.petWidgetGenderMale,
                  onTap: () =>
                      onGenderChanged(context.l10n.petWidgetGenderMale),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: context.l10n.petWidgetBreed,
              hint: context.l10n.petHintBreed,
              icon: Icons.badge_outlined,
              controller: breedController,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: PseudoField(
                    label: context.l10n.petWidgetAge,
                    value: ageValue,
                    icon: Icons.calendar_month,
                    onTap: () => onAgeChanged(
                      ageValue == context.l10n.petAgeTwoYears
                          ? context.l10n.petAgeElevenMonths
                          : context.l10n.petAgeTwoYears,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppTextField(
                    label: context.l10n.petWidgetColor,
                    hint: context.l10n.petHintColor,
                    icon: Icons.palette_outlined,
                    controller: colorController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: context.l10n.petWidgetWeight,
              hint: context.l10n.petHintWeight,
              icon: Icons.monitor_weight_outlined,
              controller: weightController,
            ),
          ],
        ),
        const SizedBox(height: 16),
        PetProfileFormCard(
          title: context.l10n.petWidgetIdDetails,
          children: [
            AppTextField(
              label: context.l10n.petWidgetMarks,
              hint: context.l10n.petHintMarks,
              icon: Icons.visibility_outlined,
              controller: marksController,
              maxLines: 3,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: context.l10n.petWidgetMicrochip,
              hint: context.l10n.petHintMicrochip,
              icon: Icons.confirmation_number_outlined,
              controller: microchipController,
            ),
          ],
        ),
        const SizedBox(height: 16),
        PetProfileFormCard(
          title: context.l10n.petWidgetHealthCare,
          children: [
            AppTextField(
              label: context.l10n.petWidgetVaccination,
              hint: context.l10n.petHintVaccination,
              icon: Icons.health_and_safety_outlined,
              controller: vaccinationController,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: context.l10n.petWidgetMedicalNotes,
              hint: context.l10n.petHintMedicalNotes,
              icon: Icons.medical_information_outlined,
              controller: notesController,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChipPill(
                  label: context.l10n.petWidgetReminderOn,
                  selected: reminderValue,
                  onTap: () => onReminderChanged(true),
                ),
                ChoiceChipPill(
                  label: context.l10n.petWidgetReminderOff,
                  selected: !reminderValue,
                  onTap: () => onReminderChanged(false),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppCard(
              color: AppColors.glassSoft,
              radius: 22,
              shadow: AppShadows.softCard,
              padding: const EdgeInsets.all(14),
              child: Text(
                context.l10n.petWidgetRemindersDesc,
                style: AppTextStyles.caption,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PetsBackdrop extends StatelessWidget {
  const _PetsBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -42,
          top: 82,
          child: _Glow(
            color: AppColors.teal.withValues(alpha: 0.25),
            size: 168,
          ),
        ),
        Positioned(
          left: -66,
          top: 240,
          child: _Glow(
            color: AppColors.coral.withValues(alpha: 0.16),
            size: 214,
          ),
        ),
        Positioned(
          right: 34,
          bottom: 132,
          child: Transform.rotate(
            angle: 0.2,
            child: Icon(
              Icons.pets,
              color: AppColors.coral.withValues(alpha: 0.14),
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}

class _PetPortrait extends StatelessWidget {
  const _PetPortrait({
    required this.accent,
    required this.size,
    required this.icon,
    this.imagePath,
  });

  final Color accent;
  final double size;
  final IconData icon;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: size * 0.16,
            top: size * 0.18,
            child: Transform.rotate(
              angle: -0.45,
              child: Container(
                width: size * 0.18,
                height: size * 0.24,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            right: size * 0.16,
            top: size * 0.18,
            child: Transform.rotate(
              angle: 0.45,
              child: Container(
                width: size * 0.18,
                height: size * 0.24,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Container(
            width: size * 0.62,
            height: size * 0.58,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
          if (imagePath == null)
            Icon(icon, color: AppColors.charcoal, size: size * 0.24)
          else
            ClipOval(
              child: AppAssetImage(
                assetPath: imagePath!,
                width: size * 0.62,
                height: size * 0.58,
              ),
            ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
