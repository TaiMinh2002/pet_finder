import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/auth_scaffold.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  var _isLoading = false;

  Future<void> _submit() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.otpButton,
      icon: Icons.check_circle_outline,
      backgroundColor: AppColors.green,
    );
    setState(() => _isLoading = false);
    context.goNamed(AppRoute.accountSuccess.name);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      leading: AuthIconButton(
        icon: Icons.arrow_back,
        onTap: () => context.safeBackNamed(AppRoute.welcome),
      ),
      title: context.l10n.otpTitle,
      subtitle: context.l10n.otpSubtitle,
      illustration: AuthIllustration(
        imagePath: AppImages.authOtp,
        icon: Icons.sms_outlined,
        badgeLabel: context.l10n.authBadgeSecureCode,
        accent: AppColors.coral,
      ),
      children: [
        AuthFormCard(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _OtpBox(value: '4'),
                _OtpBox(value: '8'),
                _OtpBox(value: '2'),
                _OtpBox(value: ''),
                _OtpBox(value: ''),
                _OtpBox(value: ''),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.otpResendCountdown,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 18),
            AppButton(
              label: context.l10n.otpButton,
              icon: Icons.arrow_forward,
              isLoading: _isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ],
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.fieldWarm,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: value.isEmpty
              ? AppColors.white.withValues(alpha: 0.8)
              : AppColors.coral.withValues(alpha: 0.45),
        ),
      ),
      child: Center(child: Text(value, style: AppTextStyles.sectionTitle)),
    );
  }
}
