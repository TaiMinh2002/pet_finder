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
import '../../../../core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  var _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_OnboardingContent> _pages(BuildContext context) => [
    _OnboardingContent(
      title: context.l10n.onboarding1Title,
      body: context.l10n.onboarding1Body,
      chip: context.l10n.onboarding1Chip,
      icon: Icons.campaign,
      accent: AppColors.coral,
      imagePath: AppImages.onboardingLost,
    ),
    _OnboardingContent(
      title: context.l10n.onboarding2Title,
      body: context.l10n.onboarding2Body,
      chip: context.l10n.onboarding2Chip,
      icon: Icons.map,
      accent: AppColors.teal,
      imagePath: AppImages.onboardingNearby,
    ),
    _OnboardingContent(
      title: context.l10n.onboarding3Title,
      body: context.l10n.onboarding3Body,
      chip: context.l10n.onboarding3Chip,
      icon: Icons.favorite,
      accent: AppColors.green,
      imagePath: AppImages.onboardingReunion,
    ),
  ];

  void _next() {
    final pages = _pages(context);
    if (_page == pages.length - 1) {
      context.goNamed(AppRoute.welcome.name);
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmSky),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(child: _OnboardingDecor(page: _page)),
              Positioned(
                right: AppSpacing.screen,
                top: 10,
                child: TextButton(
                  onPressed: () => context.goNamed(AppRoute.welcome.name),
                  child: Text(
                    context.l10n.onboardingSkip,
                    style: AppTextStyles.bodyStrong.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 56),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: pages.length,
                      onPageChanged: (value) => setState(() => _page = value),
                      itemBuilder: (context, index) =>
                          _OnboardingPage(content: pages[index]),
                    ),
                  ),
                  _PaginationDots(length: pages.length, currentIndex: _page),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: AppButton(
                      label: _page == pages.length - 1
                          ? context.l10n.onboardingGetStarted
                          : context.l10n.commonNext,
                      icon: Icons.arrow_forward,
                      height: _page == pages.length - 1 ? 58 : 64,
                      onPressed: _next,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: 135,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.charcoal.withValues(alpha: 0.2),
                      borderRadius: AppRadius.pillBorder,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.content});

  final _OnboardingContent content;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final panelHeight = constraints.maxHeight * 0.56;
        final clampedPanelHeight = panelHeight.clamp(322.0, 430.0);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenNarrow,
              ),
              child: Column(
                children: [
                  _IllustrationPanel(
                    content: content,
                    height: clampedPanelHeight,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    content.title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heroTitle,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      content.body,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _IllustrationPanel extends StatelessWidget {
  const _IllustrationPanel({required this.content, required this.height});

  final _OnboardingContent content;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x99FFF8EF),
                borderRadius: AppRadius.heroBorder,
                boxShadow: AppShadows.raisedCard,
              ),
            ),
          ),
          Positioned(
            left: 32,
            right: 32,
            top: 44,
            bottom: 72,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.76),
                borderRadius: BorderRadius.circular(34),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AppAssetImage(
                      assetPath: content.imagePath,
                      borderRadius: BorderRadius.circular(34),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.charcoal.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 28,
            bottom: 14,
            child: _TrustChip(
              icon: content.icon,
              label: content.chip,
              color: content.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustChip extends StatelessWidget {
  const _TrustChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
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

class _PaginationDots extends StatelessWidget {
  const _PaginationDots({required this.length, required this.currentIndex});

  final int length;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 9,
          height: 9,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.coral
                : AppColors.muted.withValues(alpha: 0.18),
            borderRadius: AppRadius.pillBorder,
          ),
        );
      }),
    );
  }
}

class _OnboardingDecor extends StatelessWidget {
  const _OnboardingDecor({required this.page});

  final int page;

  @override
  Widget build(BuildContext context) {
    final accent = switch (page) {
      1 => AppColors.teal,
      2 => AppColors.green,
      _ => AppColors.coral,
    };

    return Stack(
      children: [
        Positioned(
          right: -46,
          top: 98,
          child: _GlowBlob(
            size: 200,
            color: AppColors.teal.withValues(alpha: 0.22),
          ),
        ),
        Positioned(
          left: -78,
          top: 318,
          child: _GlowBlob(
            size: 228,
            color: AppColors.coral.withValues(alpha: 0.18),
          ),
        ),
        Positioned(
          left: 40,
          top: 116,
          child: _DecorIcon(
            icon: Icons.pets,
            color: AppColors.coral.withValues(alpha: 0.22),
            angle: -0.22,
          ),
        ),
        Positioned(
          right: 34,
          top: 142,
          child: _DecorIcon(
            icon: Icons.place_rounded,
            color: AppColors.teal.withValues(alpha: 0.24),
            angle: 0.18,
            size: 28,
          ),
        ),
        Positioned(
          right: 38,
          bottom: 212,
          child: _DecorIcon(
            icon: Icons.favorite,
            color: accent.withValues(alpha: 0.22),
            angle: -0.18,
            size: 26,
          ),
        ),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 44, spreadRadius: 8)],
      ),
    );
  }
}

class _DecorIcon extends StatelessWidget {
  const _DecorIcon({
    required this.icon,
    required this.color,
    required this.angle,
    this.size = 30,
  });

  final IconData icon;
  final Color color;
  final double angle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Icon(icon, size: size, color: color),
    );
  }
}

class _OnboardingContent {
  const _OnboardingContent({
    required this.title,
    required this.body,
    required this.chip,
    required this.icon,
    required this.accent,
    required this.imagePath,
  });

  final String title;
  final String body;
  final String chip;
  final IconData icon;
  final Color accent;
  final String imagePath;
}
