import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppGradients {
  static const warmSky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.cream,
      AppColors.peach,
      Color(0xFFFFEAD7),
      AppColors.sky,
    ],
    stops: [0, 0.48, 0.72, 1],
  );

  static const warmTeal = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.cream, Color(0xFFFFE3D0), Color(0xFFDDF7F6)],
    stops: [0, 0.55, 1],
  );

  static const coralButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.coral, AppColors.coralDark],
  );

  static const lostCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFE4D8), AppColors.white],
  );

  static const foundCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDDF7F6), AppColors.white],
  );
}
