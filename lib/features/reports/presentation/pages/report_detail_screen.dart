import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_status_views.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../mock/mock_data.dart';
import '../../domain/pet_report_model.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({required this.reportId, super.key});

  final String reportId;

  @override
  Widget build(BuildContext context) {
    final report = MockData.tryResolveReport(reportId);
    if (report == null) {
      return Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenNarrow,
                18,
                AppSpacing.screenNarrow,
                40,
              ),
              child: AppErrorState(
                title: context.l10n.reportNotFoundTitle,
                message: context.l10n.reportNotFoundDesc,
                retryLabel: context.l10n.commonBackToHome,
                onRetry: () => context.goNamed(AppRoute.home.name),
              ),
            ),
          ),
        ),
      );
    }
    final badgeType = switch (report.type) {
      PetReportType.lost => StatusBadgeType.lost,
      PetReportType.found => StatusBadgeType.found,
      PetReportType.reunited => StatusBadgeType.reunited,
    };

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const _ReportBackdrop(),
              CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenNarrow,
                      18,
                      AppSpacing.screenNarrow,
                      40,
                    ),
                    sliver: SliverList.list(
                      children: [
                        Row(
                          children: [
                            _CircleButton(
                              icon: Icons.arrow_back,
                              onTap: () => context.safeBackNamed(AppRoute.home),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                context.l10n.reportDetailTitle,
                                style: AppTextStyles.heroTitle.copyWith(
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        AppCard(
                          radius: 32,
                          color: AppColors.glass,
                          shadow: AppShadows.raisedCard,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 230,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: AppRadius.cardLargeBorder,
                                ),
                                child: AppAssetImage(
                                  assetPath:
                                      report.photoUrl ??
                                      AppImages.reportThumbFor(report.type),
                                  borderRadius: AppRadius.cardLargeBorder,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  StatusBadge(
                                    label: switch (report.type) {
                                      PetReportType.lost =>
                                        context.l10n.homeCategoryLost,
                                      PetReportType.found =>
                                        context.l10n.homeCategoryFound,
                                      PetReportType.reunited =>
                                        context.l10n.homeCategoryReunited,
                                    },
                                    type: badgeType,
                                  ),
                                  const SizedBox(width: 8),
                                  AppChip(
                                    label: report.distanceLabel,
                                    color: AppColors.fieldCool,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                report.petName,
                                style: AppTextStyles.heroTitle.copyWith(
                                  fontSize: 28,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${report.breed} • ${report.locationLabel}',
                                style: AppTextStyles.bodyStrong,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                report.description,
                                style: AppTextStyles.body,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppCard(
                          radius: 28,
                          color: AppColors.white.withValues(alpha: 0.82),
                          shadow: AppShadows.softCard,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.reportKeyDetails,
                                style: AppTextStyles.sectionTitle,
                              ),
                              const SizedBox(height: 12),
                              _DetailRow(
                                label: context.l10n.reportLastUpdate,
                                value: report.timeLabel,
                              ),
                              const SizedBox(height: 10),
                              _DetailRow(
                                label: context.l10n.reportApproxArea,
                                value: report.locationLabel,
                              ),
                              const SizedBox(height: 10),
                              _DetailRow(
                                label: context.l10n.reportStatus,
                                value: switch (report.status) {
                                  PetReportStatus.active =>
                                    context.l10n.chatStatusActive,
                                  PetReportStatus.possibleMatch =>
                                    context.l10n.chatStatusPossibleMatch,
                                  PetReportStatus.resolved =>
                                    context.l10n.chatStatusResolved,
                                  PetReportStatus.closed =>
                                    context.l10n.profileReportsTabClosed,
                                  PetReportStatus.reported =>
                                    context.l10n.chatStatusReported,
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppCard(
                          radius: 28,
                          color: AppColors.glass,
                          shadow: AppShadows.softCard,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  label: context.l10n.reportContact,
                                  icon: Icons.chat_bubble_outline,
                                  onPressed: () {
                                    // Chat functionality temporarily disabled
                                    // TODO: Implement chat integration with new ChatCubit

                                    // For now, show placeholder message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Chat functionality coming soon',
                                        ),
                                      ),
                                    );
                                    context.goNamed(AppRoute.chatList.name);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: AppButton(
                                  label: context.l10n.reportViewMap,
                                  icon: Icons.map_outlined,
                                  variant: AppButtonVariant.secondary,
                                  onPressed: () =>
                                      context.goNamed(AppRoute.mapNearby.name),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: AppTextStyles.caption)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodyStrong,
          ),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

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

class _ReportBackdrop extends StatelessWidget {
  const _ReportBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -46,
          top: 84,
          child: _Glow(
            color: AppColors.teal.withValues(alpha: 0.16),
            size: 186,
          ),
        ),
        Positioned(
          left: -62,
          top: 260,
          child: _Glow(
            color: AppColors.coral.withValues(alpha: 0.12),
            size: 218,
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
