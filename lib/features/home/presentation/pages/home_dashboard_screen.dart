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
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/pet_report_card.dart';
import '../../../../core/widgets/app_status_views.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../features/mock/mock_data.dart';
import '../../../../features/reports/domain/pet_report_model.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  var _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final urgentReports = MockData.reports
        .where((report) => report.type == PetReportType.lost)
        .toList();
    final categories = [
      context.l10n.homeCategoryAll,
      context.l10n.homeCategoryLost,
      context.l10n.homeCategoryFound,
      context.l10n.homeCategoryReunited,
      context.l10n.homeCategoryNearMe,
    ];

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const _HomeBackdrop(),
              CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenNarrow,
                      16,
                      AppSpacing.screenNarrow,
                      118,
                    ),
                    sliver: SliverList.list(
                      children: [
                        const _GreetingHeader(),
                        const SizedBox(height: 18),
                        const _CommunityStatsCard(),
                        const SizedBox(height: 16),
                        const _HeroActionCard(),
                        const SizedBox(height: 16),
                        const _SearchAndFilter(),
                        const SizedBox(height: 20),
                        const _QuickActionsGrid(),
                        const SizedBox(height: 22),
                        SectionHeader(
                          title: context.l10n.homeNearbyUrgentAlerts,
                          actionLabel: context.l10n.homeViewMap,
                          onActionPressed: () =>
                              context.goNamed(AppRoute.mapNearby.name),
                        ),
                        const SizedBox(height: 12),
                        if (urgentReports.isEmpty)
                          AppLoadingState(
                            title: context.l10n.homeNoUrgentAlerts,
                            message: context.l10n.homeNoUrgentAlertsMessage,
                            icon: Icons.campaign_outlined,
                          )
                        else
                          _UrgentCarousel(reports: urgentReports),
                        const SizedBox(height: 22),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (
                                var index = 0;
                                index < categories.length;
                                index++
                              ) ...[
                                AppChip(
                                  label: categories[index],
                                  selected: _selectedCategory == index,
                                  onTap: () =>
                                      setState(() => _selectedCategory = index),
                                ),
                                if (index != categories.length - 1)
                                  const SizedBox(width: 8),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SectionHeader(title: context.l10n.homeLatestReports),
                        const SizedBox(height: 12),
                        if (MockData.reports.isEmpty)
                          AppLoadingState(
                            title: context.l10n.homeNoReports,
                            message: context.l10n.homeNoReportsMessage,
                            icon: Icons.pets,
                          )
                        else
                          for (final report in MockData.reports) ...[
                            PetReportCard(
                              report: report,
                              onTap: () => context.goNamed(
                                AppRoute.reportDetail.name,
                                pathParameters: {'reportId': report.id},
                              ),
                            ),
                            const SizedBox(height: 14),
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
                child: _HomeBottomNavigation(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.homeGreeting,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.homeReadyToHelp,
                style: AppTextStyles.heroTitle.copyWith(fontSize: 28),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _NotificationButton(),
        const SizedBox(width: 10),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.cardBorder,
            boxShadow: AppShadows.floating,
          ),
          child: AppAssetImage(
            assetPath: AppImages.profileAvatarDog,
            borderRadius: AppRadius.cardBorder,
          ),
        ),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.cardBorder,
      onTap: () => context.goNamed(AppRoute.notifications.name),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: AppRadius.cardBorder,
          boxShadow: AppShadows.floating,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.notifications_none, color: AppColors.charcoal),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.coral,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroActionCard extends StatelessWidget {
  const _HeroActionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: AppRadius.heroBorder,
        boxShadow: AppShadows.raisedCard,
        border: Border.all(color: AppColors.white.withValues(alpha: 0.72)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.homeHeroTitle,
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.homeHeroSubtitle,
                      style: AppTextStyles.body.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              const _HeroPetMap(),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              AppButton(
                label: context.l10n.reportLostPet,
                icon: Icons.campaign,
                height: 48,
                onPressed: () => context.goNamed(
                  AppRoute.reportCreate.name,
                  queryParameters: const {'type': 'lost'},
                ),
              ),
              const SizedBox(height: 10),
              AppButton(
                label: context.l10n.reportFoundPet,
                icon: Icons.favorite,
                variant: AppButtonVariant.secondary,
                height: 48,
                onPressed: () => context.goNamed(
                  AppRoute.reportCreate.name,
                  queryParameters: const {'type': 'found'},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPetMap extends StatelessWidget {
  const _HeroPetMap();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppAssetImage(
              assetPath: AppImages.homeHero,
              borderRadius: AppRadius.cardLargeBorder,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppRadius.cardLargeBorder,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0x1F273036), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.glass,
              borderRadius: AppRadius.lgBorder,
              boxShadow: AppShadows.softCard,
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.coral, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.homeSearchHint,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.muted.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.coral,
            borderRadius: AppRadius.lgBorder,
            boxShadow: AppShadows.primaryButton,
          ),
          child: const Icon(Icons.tune, color: AppColors.white),
        ),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        context.l10n.homeSearchNearby,
        Icons.radar,
        AppColors.teal,
        AppRoute.mapNearby,
      ),
      _QuickAction(
        context.l10n.homeQuickMyPets,
        Icons.pets,
        AppColors.coral,
        AppRoute.petsList,
      ),
      _QuickAction(
        context.l10n.homeQuickCommunity,
        Icons.groups_2,
        AppColors.green,
        AppRoute.communityFeed,
      ),
      _QuickAction(
        context.l10n.homeQuickReminders,
        Icons.calendar_month,
        AppColors.coralDark,
        AppRoute.remindersOverview,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.92,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return InkWell(
          borderRadius: AppRadius.lgBorder,
          onTap: action.route == null
              ? null
              : () => context.goNamed(action.route!.name),
          child: AppCard(
            padding: const EdgeInsets.all(14),
            color: AppColors.white.withValues(alpha: 0.8),
            radius: 22,
            shadow: AppShadows.softCard,
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: 0.15),
                    borderRadius: AppRadius.mdBorder,
                  ),
                  child: Icon(action.icon, color: action.color, size: 23),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    action.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyStrong,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _UrgentCarousel extends StatelessWidget {
  const _UrgentCarousel({required this.reports});

  final List<PetReportModel> reports;

  @override
  Widget build(BuildContext context) {
    final items = reports.isEmpty ? MockData.reports : reports;
    return SizedBox(
      height: 166,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final report = items[index % items.length];
          return _UrgentReportCard(report: report, index: index);
        },
      ),
    );
  }
}

class _UrgentReportCard extends StatelessWidget {
  const _UrgentReportCard({required this.report, required this.index});

  final PetReportModel report;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.cardBorder,
      onTap: () => context.goNamed(
        AppRoute.reportDetail.name,
        pathParameters: {'reportId': report.id},
      ),
      child: Container(
        width: 218,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: AppRadius.cardBorder,
          boxShadow: AppShadows.softCard,
        ),
        child: Stack(
          children: [
            Positioned(
              right: -4,
              top: -4,
              child: Icon(
                Icons.pets,
                color: (index.isEven ? AppColors.coral : AppColors.teal)
                    .withValues(alpha: 0.18),
                size: 74,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: AppRadius.mdBorder,
                      ),
                      child: AppAssetImage(
                        assetPath:
                            report.photoUrl ??
                            AppImages.reportThumbFor(report.type),
                        borderRadius: AppRadius.mdBorder,
                      ),
                    ),
                    const Spacer(),
                    Text(report.distanceLabel, style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: 12),
                Text(report.petName, style: AppTextStyles.sectionTitle),
                const SizedBox(height: 4),
                Text(
                  report.locationLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.radio_button_checked,
                      color: AppColors.coral,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        context.l10n.homeNearbyUrgentAlerts,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.chip.copyWith(
                          color: AppColors.coral,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBottomNavigation extends StatelessWidget {
  const _HomeBottomNavigation();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        AppBottomNav(
          currentIndex: 0,
          onChanged: (index) {
            if (index == 1) {
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
              label: context.l10n.commonHome,
            ),
            AppBottomNavItem(
              icon: Icons.map_outlined,
              label: context.l10n.commonMap,
            ),
            AppBottomNavItem(icon: Icons.pets, label: context.l10n.commonPets),
            AppBottomNavItem(
              icon: Icons.person_outline,
              label: context.l10n.commonProfile,
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

class _HomeBackdrop extends StatelessWidget {
  const _HomeBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -52,
          top: 76,
          child: _Glow(
            color: AppColors.teal.withValues(alpha: 0.25),
            size: 170,
          ),
        ),
        Positioned(
          left: -72,
          top: 300,
          child: _Glow(
            color: AppColors.coral.withValues(alpha: 0.16),
            size: 220,
          ),
        ),
        Positioned(
          right: 32,
          bottom: 138,
          child: Transform.rotate(
            angle: 0.24,
            child: Icon(
              Icons.pets,
              color: AppColors.coral.withValues(alpha: 0.14),
              size: 42,
            ),
          ),
        ),
      ],
    );
  }
}

class _CommunityStatsCard extends StatelessWidget {
  const _CommunityStatsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      radius: 22,
      color: AppColors.glass,
      shadow: AppShadows.softCard,
      child: Row(
        children: [
          const SizedBox(
            width: 28,
            height: 28,
            child: AppAssetImage(
              assetPath: AppImages.homeCommunity,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              '14 nearby alerts • 5 active helpers',
              style: AppTextStyles.bodyStrong,
            ),
          ),
          Icon(
            Icons.favorite_rounded,
            color: AppColors.coral.withValues(alpha: 0.78),
            size: 18,
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

class _QuickAction {
  const _QuickAction(this.label, this.icon, this.color, this.route);

  final String label;
  final IconData icon;
  final Color color;
  final AppRoute? route;
}
