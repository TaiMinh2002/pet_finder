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
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_status_views.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/pet_report_card.dart';
import '../../../mock/mock_data.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class NearbyAlertsMapScreen extends StatelessWidget {
  const NearbyAlertsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = MockData.reports;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const _MapBackdrop(),
              CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenNarrow,
                      18,
                      AppSpacing.screenNarrow,
                      118,
                    ),
                    sliver: SliverList.list(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.mapNearbyAlerts,
                                    style: AppTextStyles.heroTitle.copyWith(
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.l10n.mapApproximateView,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            _CircleButton(
                              icon: Icons.notifications_none,
                              onTap: () =>
                                  context.goNamed(AppRoute.notifications.name),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (reports.isEmpty)
                          AppLoadingState(
                            title: context.l10n.mapEmptyTitle,
                            message: context.l10n.mapEmptyDesc,
                            icon: Icons.map_outlined,
                          )
                        else
                          AppCard(
                            radius: 32,
                            color: AppColors.glass,
                            shadow: AppShadows.raisedCard,
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              children: [
                                Container(
                                  height: 260,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: AppRadius.cardLargeBorder,
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: AppAssetImage(
                                          assetPath: AppImages.mapNearby,
                                          borderRadius:
                                              AppRadius.cardLargeBorder,
                                        ),
                                      ),
                                      Positioned(
                                        top: 14,
                                        left: 14,
                                        right: 14,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.glassStrong,
                                            borderRadius: AppRadius.pillBorder,
                                            boxShadow: AppShadows.floating,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.search,
                                                color: AppColors.coral,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  context.l10n.mapSearchHint,
                                                  style: AppTextStyles.caption
                                                      .copyWith(
                                                        color: AppColors.muted,
                                                      ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.tune,
                                                color: AppColors.charcoal,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 28,
                                        top: 120,
                                        child: _MapPin(
                                          color: AppColors.coral,
                                          label: context.l10n.mapFilterLost,
                                        ),
                                      ),
                                      Positioned(
                                        right: 46,
                                        top: 92,
                                        child: _MapPin(
                                          color: AppColors.teal,
                                          label: context.l10n.mapFilterFound,
                                        ),
                                      ),
                                      Positioned(
                                        right: 40,
                                        bottom: 28,
                                        child: AppChip(
                                          label: context.l10n.mapRadius5km,
                                          icon: Icons.radar,
                                          color: AppColors.fieldWarm,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    AppChip(
                                      label: context.l10n.mapFilterAll,
                                      selected: true,
                                    ),
                                    SizedBox(width: 8),
                                    AppChip(
                                      label: context.l10n.mapFilterLost,
                                      color: AppColors.fieldWarm,
                                    ),
                                    SizedBox(width: 8),
                                    AppChip(
                                      label: context.l10n.mapFilterFound,
                                      color: AppColors.fieldCool,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                AppButton(
                                  label: context.l10n.mapSubmitSighting,
                                  icon: Icons.add_location_alt_outlined,
                                  variant: AppButtonVariant.secondary,
                                  onPressed: () => showPetSnackBar(
                                    context,
                                    context.l10n.mapSightingFlowLater,
                                    icon: Icons.place_outlined,
                                    backgroundColor: AppColors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (reports.isNotEmpty) ...[
                          const SizedBox(height: 18),
                          Text(
                            context.l10n.mapNearbyList,
                            style: AppTextStyles.sectionTitle,
                          ),
                          const SizedBox(height: 12),
                          for (final report in reports) ...[
                            PetReportCard(
                              report: report,
                              onTap: () => context.goNamed(
                                AppRoute.reportDetail.name,
                                pathParameters: {'reportId': report.id},
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const Positioned(
                left: 18,
                right: 18,
                bottom: 22,
                child: _MapBottomNavigation(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapBottomNavigation extends StatelessWidget {
  const _MapBottomNavigation();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        AppBottomNav(
          currentIndex: 1,
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
          items: [
            AppBottomNavItem(
              icon: Icons.home_rounded,
              label: context.l10n.mapNavHome,
            ),
            AppBottomNavItem(
              icon: Icons.map_outlined,
              label: context.l10n.mapNavMap,
            ),
            AppBottomNavItem(icon: Icons.pets, label: context.l10n.mapNavPets),
            AppBottomNavItem(
              icon: Icons.person_outline,
              label: context.l10n.mapNavProfile,
            ),
          ],
        ),
        Positioned(
          top: -18,
          child: InkWell(
            borderRadius: AppRadius.pillBorder,
            onTap: () => context.goNamed(AppRoute.reportCreate.name),
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

class _MapPin extends StatelessWidget {
  const _MapPin({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.glassStrong,
            borderRadius: AppRadius.pillBorder,
            boxShadow: AppShadows.floating,
          ),
          child: Text(label, style: AppTextStyles.chip),
        ),
        Icon(Icons.location_on, color: color, size: 34),
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

class _MapBackdrop extends StatelessWidget {
  const _MapBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -46,
          top: 88,
          child: _Glow(
            color: AppColors.teal.withValues(alpha: 0.16),
            size: 190,
          ),
        ),
        Positioned(
          left: -60,
          top: 280,
          child: _Glow(
            color: AppColors.coral.withValues(alpha: 0.12),
            size: 220,
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
