import 'package:flutter/material.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_card.dart';

class LanguageOption {
  const LanguageOption({
    required this.code,
    required this.label,
    required this.flag,
    required this.backgroundColor,
  });

  final String code;
  final String label;
  final String flag;
  final Color backgroundColor;
}

class CurrentLanguageCard extends StatelessWidget {
  const CurrentLanguageCard({required this.currentLanguage, super.key});

  final LanguageOption currentLanguage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.hero,
      color: AppColors.glassSoft,
      shadow: AppShadows.raisedCard,
      border: Border.all(color: AppColors.peach),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.fieldCool,
                  borderRadius: AppRadius.lgBorder,
                ),
                child: const Center(
                  child: Icon(
                    Icons.language_rounded,
                    color: AppColors.teal,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.languageCurrentCardTitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(currentLanguage.label, style: AppTextStyles.title),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lostSoft,
                  borderRadius: AppRadius.pillBorder,
                ),
                child: Text(
                  context.l10n.languageActiveBadge,
                  style: AppTextStyles.chip.copyWith(color: AppColors.coral),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: AppRadius.cardBorder,
            child: SizedBox(
              height: 96,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const AppAssetImage(
                    assetPath: AppImages.languageHero,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.white.withValues(alpha: 0.18),
                          AppColors.cream.withValues(alpha: 0.92),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 14,
                    child: Text(
                      context.l10n.languageChooseBody,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageSearchField extends StatelessWidget {
  const LanguageSearchField({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 20,
      color: AppColors.glassSoft,
      shadow: AppShadows.softCard,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.muted, size: 18),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTextStyles.bodyStrong,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: context.l10n.languageSearchHint,
                hintStyle: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  color: AppColors.muted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageOptionTile extends StatelessWidget {
  const LanguageOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final LanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.lg,
      color: selected ? AppColors.glassSoft : AppColors.glass,
      shadow: selected ? AppShadows.floating : AppShadows.softCard,
      border: selected
          ? Border.all(color: AppColors.coral.withValues(alpha: 0.28))
          : null,
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: AppRadius.lgBorder,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: option.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    option.flag,
                    style: AppTextStyles.bodyStrong.copyWith(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  option.label,
                  style: AppTextStyles.bodyStrong.copyWith(
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w800,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? AppColors.coral.withValues(alpha: 0.14)
                      : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? AppColors.coral
                        : AppColors.muted.withValues(alpha: 0.28),
                    width: selected ? 1.2 : 1,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: AppColors.coral,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageHelperNote extends StatelessWidget {
  const LanguageHelperNote({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 22,
      color: AppColors.white.withValues(alpha: 0.66),
      shadow: null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          const Icon(Icons.pets_rounded, color: AppColors.teal, size: 17),
          const SizedBox(width: AppSpacing.sm + 1),
          Expanded(
            child: Text(
              context.l10n.languageHelperNote,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
