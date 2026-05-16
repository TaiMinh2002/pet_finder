import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';

enum AuthHeaderVariant { standard, registerCompact }

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.subtitle,
    required this.children,
    super.key,
    this.leading,
    this.illustration,
    this.footer,
    this.compact = false,
    this.headerVariant = AuthHeaderVariant.standard,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? leading;
  final Widget? illustration;
  final Widget? footer;
  final bool compact;
  final AuthHeaderVariant headerVariant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isRegisterCompact =
                  headerVariant == AuthHeaderVariant.registerCompact;
              final topPadding = isRegisterCompact
                  ? AppSpacing.lg
                  : compact
                  ? AppSpacing.xl
                  : AppSpacing.xxxl;
              final headerGap = isRegisterCompact
                  ? AppSpacing.md
                  : compact
                  ? AppSpacing.lg
                  : AppSpacing.xxl;
              final titleSubtitleGap = isRegisterCompact
                  ? AppSpacing.xs
                  : AppSpacing.sm;
              final subtitleFormGap = isRegisterCompact
                  ? AppSpacing.lg
                  : AppSpacing.xxl;
              final contentBottomPadding =
                  AppSpacing.xxxl + MediaQuery.viewInsetsOf(context).bottom;

              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Stack(
                  children: [
                    const _AuthBackdrop(),
                    SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.screen,
                        topPadding,
                        AppSpacing.screen,
                        contentBottomPadding,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - topPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (leading != null) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: leading!,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                            ],
                            if (illustration != null) ...[
                              illustration!,
                              SizedBox(height: headerGap),
                            ],
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.heroTitle.copyWith(
                                fontSize: isRegisterCompact ? 30 : null,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: titleSubtitleGap),
                            Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body.copyWith(
                                fontSize: isRegisterCompact ? 14 : 15,
                              ),
                            ),
                            SizedBox(height: subtitleFormGap),
                            ...children,
                            if (footer != null) ...[
                              const SizedBox(height: AppSpacing.lg),
                              footer!,
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AuthIconButton extends StatelessWidget {
  const AuthIconButton({required this.icon, required this.onTap, super.key});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.pillBorder,
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.72),
            borderRadius: AppRadius.pillBorder,
            boxShadow: AppShadows.floating,
          ),
          child: Icon(icon, color: AppColors.charcoal, size: 20),
        ),
      ),
    );
  }
}

class AuthIllustration extends StatelessWidget {
  const AuthIllustration({
    required this.badgeLabel,
    required this.imagePath,
    super.key,
    this.icon,
    this.accent = AppColors.coral,
    this.height = 218,
    this.compact = false,
  });

  final IconData? icon;
  final String badgeLabel;
  final String imagePath;
  final Color accent;
  final double height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final resolvedHeight = compact
        ? height.clamp(150.0, 180.0)
        : height.clamp(180.0, 240.0);
    final frameInset = compact ? 16.0 : 20.0;
    final frameTop = compact ? 14.0 : 18.0;
    final frameBottom = compact ? 18.0 : 22.0;
    final cardRadius = compact ? 26.0 : 30.0;
    final badgeTop = compact ? 10.0 : 14.0;
    final badgeRight = compact ? 20.0 : 28.0;

    return SizedBox(
      height: resolvedHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.28),
                borderRadius: AppRadius.heroBorder,
              ),
            ),
          ),
          Positioned(
            left: frameInset,
            right: frameInset,
            top: frameTop,
            bottom: frameBottom,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(cardRadius),
                boxShadow: AppShadows.raisedCard,
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AppAssetImage(
                      assetPath: imagePath,
                      fit: BoxFit.fill,
                      borderRadius: BorderRadius.all(
                        Radius.circular(cardRadius),
                      ),
                    ),
                  ),
                  if (icon != null)
                    Positioned(
                      left: 14,
                      bottom: 14,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.82),
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.floating,
                        ),
                        child: Icon(icon, color: accent, size: 22),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            right: badgeRight,
            top: badgeTop,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.glass,
                borderRadius: AppRadius.pillBorder,
                boxShadow: AppShadows.floating,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.teal, size: 16),
                  const SizedBox(width: 7),
                  Text(badgeLabel, style: AppTextStyles.chip),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthFormCard extends StatelessWidget {
  const AuthFormCard({required this.children, super.key, this.padding});

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: AppRadius.cardLargeBorder,
        boxShadow: AppShadows.raisedCard,
        border: Border.all(color: AppColors.white.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class AuthLink extends StatelessWidget {
  const AuthLink({required this.text, required this.onTap, super.key});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyStrong.copyWith(color: AppColors.coralDark),
      ),
    );
  }
}

class _AuthBackdrop extends StatelessWidget {
  const _AuthBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -58,
          top: 70,
          child: _Glow(
            color: AppColors.teal.withValues(alpha: 0.28),
            size: 188,
          ),
        ),
        Positioned(
          left: -72,
          top: 240,
          child: _Glow(
            color: AppColors.coral.withValues(alpha: 0.16),
            size: 220,
          ),
        ),
        Positioned(
          right: 48,
          top: 132,
          child: Transform.rotate(
            angle: 0.28,
            child: Icon(
              Icons.pets,
              color: AppColors.teal.withValues(alpha: 0.2),
              size: 28,
            ),
          ),
        ),
        Positioned(
          left: 44,
          bottom: 124,
          child: Transform.rotate(
            angle: -0.24,
            child: Icon(
              Icons.favorite,
              color: AppColors.coral.withValues(alpha: 0.22),
              size: 28,
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
