import 'dart:async';

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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    context.goNamed(AppRoute.onboarding.name);
  }

  void _onTapNavigate() {
    _timer?.cancel();
    _navigate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmSky),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    const _OrganicBackdrop(),
                    const Positioned(
                      top: 72,
                      left: 56,
                      right: 56,
                      child: _BrandLockup(),
                    ),
                    Positioned(
                      top: 210,
                      left: 20,
                      right: 20,
                      child: _SplashIllustration(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.appTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.display,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.splashTagline,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 22),
                    GestureDetector(
                      onTap: _onTapNavigate,
                      child: const SplashLoadingDots(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.splashSearchingNeighborhood,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.muted.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashLoadingDots extends StatefulWidget {
  const SplashLoadingDots({super.key});

  @override
  State<SplashLoadingDots> createState() => _SplashLoadingDotsState();
}

class _SplashLoadingDotsState extends State<SplashLoadingDots> {
  static const _dotCount = 4;
  static const _stepDuration = Duration(milliseconds: 320);
  static const _animationDuration = Duration(milliseconds: 220);

  Timer? _timer;
  var _activeDotIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_stepDuration, (_) {
      if (!mounted) return;
      setState(() {
        _activeDotIndex = (_activeDotIndex + 1) % _dotCount;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_dotCount, (index) {
        final isActive = index == _activeDotIndex;
        return Padding(
          padding: EdgeInsets.only(right: index == _dotCount - 1 ? 0 : 8),
          child: AnimatedScale(
            scale: isActive ? 1.12 : 1,
            duration: _animationDuration,
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: _animationDuration,
              curve: Curves.easeOutCubic,
              width: isActive ? 18 : 9,
              height: 9,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.coral
                    : AppColors.muted.withValues(alpha: 0.24),
                borderRadius: AppRadius.pillBorder,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.coral.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : const [],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _OrganicBackdrop extends StatelessWidget {
  const _OrganicBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -34,
          top: 56,
          child: _Glow(
            color: AppColors.teal.withValues(alpha: 0.34),
            size: 190,
          ),
        ),
        Positioned(
          left: -62,
          top: 210,
          child: _Glow(
            color: AppColors.coral.withValues(alpha: 0.18),
            size: 204,
          ),
        ),
        const Positioned(
          left: 36,
          top: 132,
          child: _DecorIcon(
            icon: Icons.pets,
            color: Color(0x25F45D48),
            angle: -0.2,
          ),
        ),
        const Positioned(
          right: 44,
          top: 108,
          child: _DecorIcon(
            icon: Icons.pets,
            color: Color(0x284DBDC6),
            angle: 0.18,
          ),
        ),
        const Positioned(
          right: 62,
          bottom: 170,
          child: _DecorIcon(
            icon: Icons.pets,
            color: Color(0x22F45D48),
            angle: -0.14,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(26),
            boxShadow: AppShadows.softCard,
          ),
          child: const Icon(Icons.pets, color: AppColors.coral, size: 38),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.72),
            borderRadius: AppRadius.pillBorder,
          ),
          child: Text(
            context.l10n.splashLocalHelpers,
            style: AppTextStyles.chip,
          ),
        ),
      ],
    );
  }
}

class _SplashIllustration extends StatelessWidget {
  const _SplashIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.34),
                borderRadius: AppRadius.heroBorder,
              ),
            ),
          ),
          Positioned(
            left: 28,
            right: 28,
            top: 76,
            child: Container(
              height: 210,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(38),
                boxShadow: AppShadows.raisedCard,
              ),
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: AppAssetImage(
                      assetPath: AppImages.splashHero,
                      borderRadius: BorderRadius.all(Radius.circular(38)),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.white.withValues(alpha: 0.08),
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
            right: 8,
            top: 8,
            child: _FloatingBubble(
              icon: Icons.favorite,
              text: context.l10n.splashCaseAlert,
              color: AppColors.coral,
            ),
          ),
          Positioned(
            left: 8,
            top: 18,
            child: _FloatingBubble(
              icon: Icons.groups_2,
              text: context.l10n.commonCommunity,
              color: AppColors.teal,
            ),
          ),
          Positioned(
            right: 36,
            bottom: 30,
            child: _FloatingBubble(
              icon: Icons.route,
              text: context.l10n.splashLiveTrail,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBubble extends StatelessWidget {
  const _FloatingBubble({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: AppRadius.pillBorder,
        boxShadow: AppShadows.floating,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 7),
          Text(text, style: AppTextStyles.chip.copyWith(fontSize: 10)),
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

class _DecorIcon extends StatelessWidget {
  const _DecorIcon({
    required this.icon,
    required this.color,
    this.angle = 0,
    this.size = 26,
  });

  final IconData icon;
  final Color color;
  final double angle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Icon(icon, color: color, size: size),
    );
  }
}
