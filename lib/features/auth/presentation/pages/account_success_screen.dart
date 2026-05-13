import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/auth_scaffold.dart';

class AccountSuccessScreen extends StatefulWidget {
  const AccountSuccessScreen({super.key});

  @override
  State<AccountSuccessScreen> createState() => _AccountSuccessScreenState();
}

class _AccountSuccessScreenState extends State<AccountSuccessScreen> {
  var _isLoading = false;

  Future<void> _continue() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.authSuccessTitle,
      icon: Icons.home_rounded,
      backgroundColor: AppColors.green,
    );
    setState(() => _isLoading = false);
    context.goNamed(AppRoute.home.name);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      compact: true,
      title: context.l10n.authSuccessTitle,
      subtitle: context.l10n.authSuccessSubtitle,
      illustration: AuthIllustration(
        imagePath: AppImages.authSuccess,
        icon: Icons.check_circle_outline,
        badgeLabel: context.l10n.authBadgeReadyToHelp,
        height: 368,
        accent: AppColors.green,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.glassSoft,
            borderRadius: AppRadius.cardBorder,
            boxShadow: AppShadows.softCard,
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.successSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.authSuccessSubtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.charcoal,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        AppButton(
          label: context.l10n.commonContinue,
          icon: Icons.home_rounded,
          isLoading: _isLoading,
          onPressed: _continue,
        ),
      ],
    );
  }
}
