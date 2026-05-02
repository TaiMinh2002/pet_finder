import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  static const softCard = [
    BoxShadow(
      color: AppColors.shadowWarm,
      offset: Offset(0, 10),
      blurRadius: 22,
    ),
  ];

  static const raisedCard = [
    BoxShadow(color: Color(0x18A6482A), offset: Offset(0, 14), blurRadius: 34),
    BoxShadow(color: Color(0x85FFFFFF), offset: Offset(0, -2), blurRadius: 8),
  ];

  static const primaryButton = [
    BoxShadow(color: Color(0x42D83B2D), offset: Offset(0, 14), blurRadius: 28),
    BoxShadow(color: Color(0x80FFFFFF), offset: Offset(0, -2), blurRadius: 8),
  ];

  static const floating = [
    BoxShadow(color: Color(0x1A2B2115), offset: Offset(0, 8), blurRadius: 18),
  ];
}
