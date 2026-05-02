import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_text_styles.dart';
import '../localization/localization_extensions.dart';
import 'app_card.dart';
import 'app_button.dart';

class AppLoadingState extends StatelessWidget {
  const AppLoadingState({
    required this.title,
    required this.message,
    super.key,
    this.icon = Icons.hourglass_top_rounded,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 30,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: AppGradients.coralButton,
              shape: BoxShape.circle,
              boxShadow: AppShadows.primaryButton,
            ),
            child: Icon(icon, color: AppColors.white, size: 34),
          ),
          const SizedBox(height: 18),
          Text(title, textAlign: TextAlign.center, style: AppTextStyles.title),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: AppTextStyles.body),
          const SizedBox(height: 18),
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.coral),
            ),
          ),
        ],
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    required this.title,
    required this.message,
    required this.onRetry,
    super.key,
    this.retryLabel,
    this.icon = Icons.error_outline_rounded,
  });

  final String title;
  final String message;
  final String? retryLabel;
  final IconData icon;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 30,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: AppColors.lostSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.coralDark, size: 34),
          ),
          const SizedBox(height: 18),
          Text(title, textAlign: TextAlign.center, style: AppTextStyles.title),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: AppTextStyles.body),
          const SizedBox(height: 18),
          AppButton(
            label: retryLabel ?? context.l10n.commonRetry,
            icon: Icons.refresh,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
