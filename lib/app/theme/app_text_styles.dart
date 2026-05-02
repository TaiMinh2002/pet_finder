import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  // No local font files are bundled yet, so Phase 1 uses the platform default
  // sans-serif stack instead of referencing missing font assets.
  static const String? headingFamily = null;
  static const String? bodyFamily = null;

  static const display = TextStyle(
    fontFamily: headingFamily,
    fontSize: 39,
    fontWeight: FontWeight.w800,
    height: 1.03,
    color: AppColors.charcoal,
  );

  static const heroTitle = TextStyle(
    fontFamily: headingFamily,
    fontSize: 34,
    fontWeight: FontWeight.w800,
    height: 1.05,
    color: AppColors.charcoal,
  );

  static const title = TextStyle(
    fontFamily: headingFamily,
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: AppColors.charcoal,
  );

  static const sectionTitle = TextStyle(
    fontFamily: headingFamily,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.charcoal,
  );

  static const body = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.38,
    color: AppColors.muted,
  );

  static const bodyStrong = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.charcoal,
  );

  static const caption = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.muted,
  );

  static const button = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
  );

  static const chip = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: AppColors.charcoal,
  );
}
