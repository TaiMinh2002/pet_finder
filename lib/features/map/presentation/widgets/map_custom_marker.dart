import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../models/map_marker_type.dart';

class MapCustomMarker extends StatelessWidget {
  const MapCustomMarker({
    super.key,
    required this.type,
    this.isSelected = false,
    this.size = 42.0,
  });

  final MapMarkerType type;
  final bool isSelected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = type.color;
    final shadowColor = type.shadowColor;
    final markerSize = isSelected ? size * 1.2 : size;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: markerSize,
      height: markerSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: isSelected ? 0.5 : 0.35),
            blurRadius: isSelected ? 24 : 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: isSelected
            ? Border.all(color: AppColors.white, width: 3)
            : null,
      ),
      child: Icon(
        _iconForType(type),
        color: AppColors.white,
        size: markerSize * 0.46,
      ),
    );
  }

  IconData _iconForType(MapMarkerType type) => switch (type) {
    MapMarkerType.lost => Icons.search_rounded,
    MapMarkerType.found => Icons.pets_rounded,
    MapMarkerType.urgent => Icons.warning_rounded,
    MapMarkerType.reunited => Icons.favorite_rounded,
  };
}

class MapCurrentLocationMarker extends StatefulWidget {
  const MapCurrentLocationMarker({super.key});

  @override
  State<MapCurrentLocationMarker> createState() =>
      _MapCurrentLocationMarkerState();
}

class _MapCurrentLocationMarkerState extends State<MapCurrentLocationMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.teal,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
