import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../widgets/auth_scaffold.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _isLoading = false;

  Future<void> _submit() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.signUpButton,
      icon: Icons.verified_outlined,
      backgroundColor: AppColors.coral,
    );
    setState(() => _isLoading = false);
    context.goNamed(AppRoute.otp.name);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      compact: true,
      headerVariant: AuthHeaderVariant.registerCompact,
      leading: AuthIconButton(
        icon: Icons.arrow_back,
        onTap: () => context.safeBackNamed(AppRoute.welcome),
      ),
      title: context.l10n.signUpTitle,
      subtitle: context.l10n.signUpSubtitle,
      illustration: AuthIllustration(
        imagePath: AppImages.authSignUp,
        icon: Icons.badge_outlined,
        badgeLabel: context.l10n.authBadgeSafeContact,
        height: 164,
        compact: true,
        accent: AppColors.coral,
      ),
      children: [
        AuthFormCard(
          padding: const EdgeInsets.all(18),
          children: [
            AppTextField(
              label: context.l10n.authFullName,
              hint: context.l10n.authHintYourName,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: context.l10n.authEmail,
              hint: context.l10n.authHintEmail,
              icon: Icons.mail_outline,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: context.l10n.authCreatePassword,
              hint: context.l10n.authHintCreatePassword,
              icon: Icons.lock_outline,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: context.l10n.authConfirmPassword,
              hint: context.l10n.authHintRepeatPassword,
              icon: Icons.verified_user_outlined,
            ),
            const SizedBox(height: 18),
            AppButton(
              label: context.l10n.signUpButton,
              icon: Icons.arrow_forward,
              height: 52,
              isLoading: _isLoading,
              onPressed: _submit,
            ),
          ],
        ),
        AuthLink(
          text: context.l10n.signUpLoginPrompt,
          onTap: () => context.goNamed(AppRoute.login.name),
        ),
      ],
    );
  }
}
