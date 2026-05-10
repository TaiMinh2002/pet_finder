import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../bloc/map_state.dart';

class MapPermissionView extends StatelessWidget {
  const MapPermissionView({
    super.key,
    required this.stateType,
    required this.onRetry,
    required this.onOpenSettings,
  });

  final Type stateType;
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final isDeniedForever = stateType == MapLocationDeniedForever;
    final isServiceDisabled = stateType == MapServiceDisabled;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.fieldWarm,
                shape: BoxShape.circle,
                boxShadow: AppShadows.floating,
              ),
              child: const Icon(
                Icons.location_off_rounded,
                color: AppColors.coral,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isServiceDisabled
                  ? context.l10n.mapLocationServiceDisabled
                  : context.l10n.mapLocationPermissionRequired,
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isServiceDisabled
                  ? context.l10n.mapLocationServiceDisabledDesc
                  : isDeniedForever
                  ? context.l10n.mapLocationPermissionDeniedForeverDesc
                  : context.l10n.mapLocationPermissionDeniedDesc,
              style: AppTextStyles.body.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (isDeniedForever || isServiceDisabled)
              _PermissionButton(
                label: context.l10n.mapOpenSettings,
                icon: Icons.settings_rounded,
                color: AppColors.charcoal,
                onTap: onOpenSettings,
              )
            else
              _PermissionButton(
                label: context.l10n.mapRetry,
                icon: Icons.refresh_rounded,
                color: AppColors.coral,
                onTap: onRetry,
              ),
          ],
        ),
      ),
    );
  }
}

class _PermissionButton extends StatelessWidget {
  const _PermissionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppShadows.primaryButton,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.white, size: 20),
            const SizedBox(width: 10),
            Text(label, style: AppTextStyles.button.copyWith(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
