import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';

class ReportFlowScaffold extends StatelessWidget {
  const ReportFlowScaffold({
    required this.stepLabel,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.child,
    super.key,
    this.onBack,
    this.bottom,
  });

  final String stepLabel;
  final String title;
  final String subtitle;
  final double progress;
  final Widget child;
  final VoidCallback? onBack;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const _ReportBackdrop(),
              SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenNarrow,
                  16,
                  AppSpacing.screenNarrow,
                  120 + MediaQuery.viewInsetsOf(context).bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _CircleIconButton(
                          icon: Icons.arrow_back,
                          onTap: onBack,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.sectionTitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          stepLabel,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.coralDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: AppRadius.pillBorder,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.white.withValues(
                          alpha: 0.55,
                        ),
                        color: AppColors.coral,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      title,
                      style: AppTextStyles.heroTitle.copyWith(
                        fontSize: 33,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(subtitle, style: AppTextStyles.body),
                    const SizedBox(height: 22),
                    child,
                  ],
                ),
              ),
              if (bottom != null)
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24 + MediaQuery.viewInsetsOf(context).bottom,
                  child: bottom!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportBottomBar extends StatelessWidget {
  const ReportBottomBar({
    required this.primaryLabel,
    required this.onPrimary,
    super.key,
    this.secondaryLabel,
    this.onSecondary,
    this.primaryIcon,
    this.isPrimaryLoading = false,
  });

  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final IconData? primaryIcon;
  final bool isPrimaryLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (secondaryLabel != null) ...[
          Expanded(
            child: AppButton(
              label: secondaryLabel!,
              onPressed: onSecondary,
              variant: AppButtonVariant.secondary,
            ),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: AppButton(
            label: primaryLabel,
            onPressed: onPrimary,
            icon: primaryIcon,
            isLoading: isPrimaryLoading,
          ),
        ),
      ],
    );
  }
}

class ReportInfoChip extends StatelessWidget {
  const ReportInfoChip({
    required this.label,
    required this.icon,
    super.key,
    this.color = AppColors.teal,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: AppRadius.pillBorder,
        boxShadow: AppShadows.floating,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.chip),
        ],
      ),
    );
  }
}

class ReportSelectCard extends StatelessWidget {
  const ReportSelectCard({
    required this.title,
    required this.description,
    required this.selected,
    required this.icon,
    required this.accent,
    required this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final bool selected;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.cardLargeBorder,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: selected ? AppGradients.lostCard : null,
          color: selected ? null : AppColors.glass,
          borderRadius: AppRadius.cardLargeBorder,
          boxShadow: AppShadows.softCard,
          border: Border.all(
            color: selected ? accent : AppColors.white.withValues(alpha: 0.72),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                borderRadius: AppRadius.mdBorder,
              ),
              child: Icon(icon, color: accent, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.title),
                  const SizedBox(height: 6),
                  Text(description, style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportUploadCard extends StatelessWidget {
  const ReportUploadCard({required this.labels, super.key});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    String photoLabelFor(String value) => switch (value) {
      'face' || 'Face' => context.l10n.reportFlowPhotoFace,
      'full_body' || 'Full body' => context.l10n.reportFlowPhotoFullBody,
      _ => value,
    };

    return AppCard(
      padding: const EdgeInsets.all(18),
      color: AppColors.glass,
      radius: 32,
      shadow: AppShadows.raisedCard,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.55),
              borderRadius: AppRadius.cardBorder,
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.8),
                width: 1.2,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: AppColors.lostSoft,
                    borderRadius: AppRadius.lgBorder,
                  ),
                  child: const Icon(
                    Icons.image_outlined,
                    color: AppColors.coral,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  context.l10n.reportFlowUploadTitle,
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.reportFlowUploadHint,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: context.l10n.reportFlowCamera,
                  onPressed: () {},
                  icon: Icons.photo_camera_outlined,
                  height: 50,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: context.l10n.reportFlowGallery,
                  onPressed: () {},
                  icon: Icons.collections_outlined,
                  height: 50,
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 86,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: labels.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Container(
                  width: 86,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: index.isEven
                        ? AppGradients.lostCard
                        : AppGradients.foundCard,
                    borderRadius: AppRadius.cardBorder,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.pets,
                        color: AppColors.charcoal,
                        size: 26,
                      ),
                      const Spacer(),
                      Text(
                        photoLabelFor(labels[index]),
                        style: AppTextStyles.chip,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReportMapPlaceholder extends StatelessWidget {
  const ReportMapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      color: AppColors.glass,
      radius: 32,
      shadow: AppShadows.raisedCard,
      child: SizedBox(
        height: 218,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFDDF7F6),
                      AppColors.cream,
                      AppColors.peach,
                    ],
                  ),
                  borderRadius: AppRadius.cardLargeBorder,
                ),
              ),
            ),
            Positioned(
              left: 24,
              top: 52,
              child: Transform.rotate(
                angle: -0.12,
                child: const Icon(
                  Icons.route,
                  color: Color(0x804DBDC6),
                  size: 92,
                ),
              ),
            ),
            const Positioned(
              right: 28,
              top: 34,
              child: Icon(Icons.location_on, color: AppColors.coral, size: 42),
            ),
            Positioned(
              right: 18,
              bottom: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.glassStrong,
                  borderRadius: AppRadius.pillBorder,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.pets, color: AppColors.teal, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.reportFlowApproxArea,
                      style: AppTextStyles.chip,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportReviewCard extends StatelessWidget {
  const ReportReviewCard({required this.title, required this.rows, super.key});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      color: AppColors.glass,
      radius: 28,
      shadow: AppShadows.softCard,
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

class CircleChoiceChip extends StatelessWidget {
  const CircleChoiceChip({
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

class ReportIllustrationCard extends StatelessWidget {
  const ReportIllustrationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
    this.accent = AppColors.coral,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      color: AppColors.glassSoft,
      radius: 34,
      shadow: AppShadows.raisedCard,
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: AppShadows.floating,
            ),
            child: Icon(icon, color: accent, size: 52),
          ),
          const SizedBox(height: 18),
          Text(title, textAlign: TextAlign.center, style: AppTextStyles.title),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.pillBorder,
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: AppRadius.pillBorder,
          boxShadow: AppShadows.floating,
        ),
        child: Icon(icon, color: AppColors.charcoal, size: 20),
      ),
    );
  }
}

class _ReportBackdrop extends StatelessWidget {
  const _ReportBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -58,
          top: 80,
          child: _Glow(
            color: AppColors.teal.withValues(alpha: 0.25),
            size: 188,
          ),
        ),
        Positioned(
          left: -74,
          top: 242,
          child: _Glow(
            color: AppColors.coral.withValues(alpha: 0.16),
            size: 220,
          ),
        ),
        Positioned(
          right: 40,
          top: 128,
          child: Transform.rotate(
            angle: 0.22,
            child: Icon(
              Icons.pets,
              color: AppColors.teal.withValues(alpha: 0.18),
              size: 28,
            ),
          ),
        ),
        Positioned(
          left: 44,
          bottom: 138,
          child: Transform.rotate(
            angle: -0.16,
            child: Icon(
              Icons.pets,
              color: AppColors.coral.withValues(alpha: 0.18),
              size: 26,
            ),
          ),
        ),
      ],
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
