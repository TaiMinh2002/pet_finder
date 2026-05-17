import 'package:flutter/material.dart';

class AppAssetImage extends StatelessWidget {
  const AppAssetImage({
    required this.assetPath,
    super.key,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.cacheWidth,
    this.cacheHeight,
    this.semanticLabel,
  });

  final String assetPath;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Alignment alignment;
  final int? cacheWidth;
  final int? cacheHeight;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (assetPath.isEmpty) {
      return _FallbackImage(
        width: width,
        height: height,
        borderRadius: borderRadius,
      );
    }

    final image = _isRemoteImage
        ? Image.network(
            assetPath,
            fit: fit,
            width: width,
            height: height,
            alignment: alignment,
            semanticLabel: semanticLabel,
            filterQuality: FilterQuality.medium,
            errorBuilder: (context, error, stackTrace) {
              return _FallbackImage(
                width: width,
                height: height,
                borderRadius: borderRadius,
              );
            },
          )
        : Image.asset(
            assetPath,
            fit: fit,
            width: width,
            height: height,
            alignment: alignment,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            semanticLabel: semanticLabel,
            filterQuality: FilterQuality.medium,
            errorBuilder: (context, error, stackTrace) {
              return _FallbackImage(
                width: width,
                height: height,
                borderRadius: borderRadius,
              );
            },
          );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }

  bool get _isRemoteImage =>
      assetPath.startsWith('http://') || assetPath.startsWith('https://');
}

class _FallbackImage extends StatelessWidget {
  const _FallbackImage({required this.borderRadius, this.width, this.height});

  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF7E6D8),
        borderRadius: borderRadius,
      ),
      child: const Icon(Icons.pets, color: Color(0xFFD83B2D)),
    );

    if (borderRadius == null) {
      return fallback;
    }

    return ClipRRect(borderRadius: borderRadius!, child: fallback);
  }
}
