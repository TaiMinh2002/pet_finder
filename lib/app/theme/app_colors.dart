import 'package:flutter/material.dart';

abstract final class AppColors {
  static const charcoal = Color(0xFF273036);
  static const coral = Color(0xFFF45D48);
  static const coralDark = Color(0xFFD83B2D);
  static const cream = Color(0xFFFFF4E6);
  static const peach = Color(0xFFFFD7BE);
  static const sky = Color(0xFFA7E8F0);
  static const teal = Color(0xFF4DBDC6);
  static const green = Color(0xFF8ACB88);
  static const muted = Color(0xFF76665F);
  static const white = Color(0xFFFFFFFF);
  
  // Additional colors for compatibility
  static const blue = Color(0xFF2196F3);
  static const red = Color(0xFFFF5722);
  static const gray = MaterialColor(0xFF9E9E9E, {
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF5F5F5),
    200: Color(0xFFEEEEEE),
    300: Color(0xFFE0E0E0),
    400: Color(0xFFBDBDBD),
    500: Color(0xFF9E9E9E),
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    900: Color(0xFF212121),
  });

  static const glass = Color(0xD9FFFFFF);
  static const glassStrong = Color(0xF2FFFFFF);
  static const glassSoft = Color(0xC9FFFFFF);
  static const fieldWarm = Color(0xFFFFF7EF);
  static const fieldCool = Color(0xFFE6FAF9);
  static const successSoft = Color(0xFFE7F7EF);
  static const lostSoft = Color(0xFFFFE7DF);
  static const shadowWarm = Color(0x20A6482A);
  static const handle = Color(0x33273036);
}
