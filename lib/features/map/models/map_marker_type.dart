import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

enum MapMarkerType {
  lost,
  found,
  urgent,
  reunited;

  Color get color => switch (this) {
    MapMarkerType.lost => AppColors.coral,
    MapMarkerType.found => AppColors.teal,
    MapMarkerType.urgent => const Color(0xFFFFB84D),
    MapMarkerType.reunited => AppColors.green,
  };

  Color get shadowColor => switch (this) {
    MapMarkerType.lost => const Color(0xFFD83B2D),
    MapMarkerType.found => const Color(0xFF22A6A3),
    MapMarkerType.urgent => const Color(0xFFFFB84D),
    MapMarkerType.reunited => const Color(0xFF5B9C59),
  };
}
