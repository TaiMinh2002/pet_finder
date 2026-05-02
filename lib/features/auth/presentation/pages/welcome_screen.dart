import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/auth_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      compact: true,
      title: context.l10n.welcomeTitle,
      subtitle: context.l10n.welcomeSubtitle,
      illustration: const AuthIllustration(
        imagePath: AppImages.authWelcome,
        icon: Icons.home_rounded,
        badgeLabel: 'Trusted alerts',
        height: 330,
      ),
      children: [
        _TrustBadge(),
        const SizedBox(height: 18),
        AppButton(
          label: context.l10n.welcomeCreateAccount,
          icon: Icons.person_add_alt_1,
          onPressed: () => context.goNamed(AppRoute.signUp.name),
        ),
        const SizedBox(height: 12),
        AppButton(
          label: context.l10n.welcomeLogin,
          icon: Icons.login,
          variant: AppButtonVariant.secondary,
          onPressed: () => context.goNamed(AppRoute.login.name),
        ),
      ],
    );
  }
}

class _TrustBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: AppRadius.pillBorder,
          boxShadow: AppShadows.floating,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.verified_user_outlined,
              color: AppColors.coral,
              size: 17,
            ),
            const SizedBox(width: 8),
            Text(context.l10n.welcomeTrustNetwork, style: AppTextStyles.chip),
          ],
        ),
      ),
    );
  }
}
