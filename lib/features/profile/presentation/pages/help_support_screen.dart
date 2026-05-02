import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../widgets/profile_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScaffold(
      bottomNav: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenNarrow,
              18,
              AppSpacing.screenNarrow,
              40,
            ),
            sliver: SliverList.list(
              children: [
                ProfileHeader(
                  title: context.l10n.helpTitle,
                  subtitle: context.l10n.helpSupportDesc2,
                  leading: CircleGlassButton(
                    icon: Icons.arrow_back,
                    onTap: () =>
                        context.safeBackNamed(AppRoute.profileOverview),
                  ),
                ),
                const SizedBox(height: 18),
                SupportActionCard(
                  title: context.l10n.helpContactSupport,
                  subtitle: context.l10n.helpSupportDesc1,
                  icon: Icons.headset_mic_outlined,
                  color: AppColors.coral,
                ),
                const SizedBox(height: 12),
                SupportActionCard(
                  title: context.l10n.helpReportProblem,
                  subtitle: context.l10n.helpFlagBug,
                  icon: Icons.flag_outlined,
                  color: AppColors.teal,
                ),
                const SizedBox(height: 18),
                FaqCard(
                  question: context.l10n.helpFaq1Question,
                  answer: context.l10n.helpFaq1Answer,
                ),
                const SizedBox(height: 12),
                FaqCard(
                  question: context.l10n.helpFaq2Question,
                  answer: context.l10n.helpFaq2Answer,
                ),
                const SizedBox(height: 12),
                FaqCard(
                  question: context.l10n.helpFaq3Question,
                  answer: context.l10n.helpFaq3Answer,
                ),
                const SizedBox(height: 18),
                SupportActionCard(
                  title: context.l10n.helpPetSafety,
                  subtitle: context.l10n.helpSafetyDesc,
                  icon: Icons.health_and_safety_outlined,
                  color: AppColors.green,
                ),
                const SizedBox(height: 12),
                SupportActionCard(
                  title: context.l10n.helpEmergencyTips,
                  subtitle: context.l10n.helpEmergencyDesc,
                  icon: Icons.local_hospital_outlined,
                  color: AppColors.coralDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
