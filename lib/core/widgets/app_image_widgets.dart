import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../localization/localization_extensions.dart';
import '../widgets/app_asset_image.dart';
import '../widgets/app_card.dart';

class AppThumbnailImage extends StatelessWidget {
  const AppThumbnailImage({
    required this.assetPath,
    super.key,
    this.size = 76,
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
    this.fit = BoxFit.cover,
    this.semanticLabel,
  });

  final String assetPath;
  final double size;
  final BorderRadiusGeometry borderRadius;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return AppAssetImage(
      assetPath: assetPath,
      width: size,
      height: size,
      fit: fit,
      borderRadius: borderRadius,
      cacheWidth: size.round() * 2,
      cacheHeight: size.round() * 2,
      semanticLabel: semanticLabel,
    );
  }
}

class AppHeroImage extends StatelessWidget {
  const AppHeroImage({
    required this.assetPath,
    super.key,
    this.height = 220,
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.fit = BoxFit.cover,
    this.semanticLabel,
  });

  final String assetPath;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return AppAssetImage(
      assetPath: assetPath,
      width: double.infinity,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      cacheWidth: 1200,
      cacheHeight: (height * 2).round(),
      semanticLabel: semanticLabel,
    );
  }
}

class AppCircularImage extends StatelessWidget {
  const AppCircularImage({
    required this.assetPath,
    super.key,
    this.size = 56,
    this.fit = BoxFit.cover,
    this.semanticLabel,
  });

  final String assetPath;
  final double size;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return AppAssetImage(
      assetPath: assetPath,
      width: size,
      height: size,
      fit: fit,
      borderRadius: BorderRadius.circular(size / 2),
      cacheWidth: size.round() * 2,
      cacheHeight: size.round() * 2,
      semanticLabel: semanticLabel,
    );
  }
}

class AppIllustrationImage extends StatelessWidget {
  const AppIllustrationImage({
    required this.assetPath,
    super.key,
    this.height = 160,
    this.borderRadius = const BorderRadius.all(Radius.circular(34)),
    this.fit = BoxFit.cover,
    this.semanticLabel,
  });

  final String assetPath;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return AppAssetImage(
      assetPath: assetPath,
      width: double.infinity,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      cacheWidth: 1200,
      cacheHeight: (height * 2).round(),
      semanticLabel: semanticLabel,
    );
  }
}

class AppEmptyStateIllustration extends StatelessWidget {
  const AppEmptyStateIllustration({
    required this.assetPath,
    super.key,
    this.size = 116,
    this.borderRadius = const BorderRadius.all(Radius.circular(34)),
  });

  final String assetPath;
  final double size;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return AppAssetImage(
      assetPath: assetPath,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: borderRadius,
      cacheWidth: size.round() * 2,
      cacheHeight: size.round() * 2,
      semanticLabel: context.l10n.commonEmptyStateIllustration,
    );
  }
}

class AppImageCard extends StatelessWidget {
  const AppImageCard({
    required this.child,
    super.key,
    this.radius = 30,
    this.padding = EdgeInsets.zero,
    this.color = AppColors.white,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: radius,
      color: color,
      padding: padding,
      child: child,
    );
  }
}
