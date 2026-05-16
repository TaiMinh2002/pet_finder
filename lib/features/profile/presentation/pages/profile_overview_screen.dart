import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../widgets/profile_widgets.dart';

class ProfileOverviewScreen extends StatelessWidget {
  const ProfileOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScaffold(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenNarrow,
              18,
              AppSpacing.screenNarrow,
              118,
            ),
            sliver: SliverList.list(
              children: [
                ProfileHeader(
                  title: context.l10n.profileTitle,
                  subtitle: context.l10n.profileSubtitle,
                  trailing: CircleGlassButton(
                    icon: Icons.edit_outlined,
                    onTap: () => context.goNamed(AppRoute.profileEdit.name),
                  ),
                ),
                const SizedBox(height: 18),
                const ProfileHeroCard(),
                const SizedBox(height: 16),
                const ProfileStatGrid(),
                const SizedBox(height: 18),
                ProfileMenuSection(
                  title: context.l10n.profileAccountSection,
                  items: [
                    ProfileMenuItemData(
                      title: context.l10n.commonMyReports,
                      subtitle: context.l10n.profileMyReportsSubtitle,
                      icon: Icons.campaign_outlined,
                      color: AppColors.coral,
                      onTap: () => context.goNamed(AppRoute.myReports.name),
                    ),
                    ProfileMenuItemData(
                      title: context.l10n.commonSavedReports,
                      subtitle: context.l10n.profileSavedReportsSubtitle,
                      icon: Icons.bookmark_border,
                      color: AppColors.teal,
                      onTap: () => context.goNamed(AppRoute.savedReports.name),
                    ),
                    ProfileMenuItemData(
                      title: context.l10n.commonNotifications,
                      subtitle: context.l10n.profileNotificationsSubtitle,
                      icon: Icons.notifications_none,
                      color: AppColors.green,
                      onTap: () => context.goNamed(AppRoute.notifications.name),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ProfileMenuSection(
                  title: context.l10n.profilePreferencesSection,
                  items: [
                    ProfileMenuItemData(
                      title: context.l10n.commonSettings,
                      subtitle: context.l10n.profileSettingsSubtitle,
                      icon: Icons.settings_outlined,
                      color: AppColors.coralDark,
                      onTap: () => context.goNamed(AppRoute.settings.name),
                    ),
                    ProfileMenuItemData(
                      title: context.l10n.commonHelpSupport,
                      subtitle: context.l10n.profileHelpSubtitle,
                      icon: Icons.help_outline_rounded,
                      color: AppColors.teal,
                      onTap: () => context.goNamed(AppRoute.helpSupport.name),
                    ),
                    ProfileMenuItemData(
                      title: context.l10n.profilePrivacySafety,
                      subtitle: context.l10n.profilePrivacySubtitle,
                      icon: Icons.shield_outlined,
                      color: AppColors.green,
                      onTap: () => context.goNamed(AppRoute.settings.name),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ProfileMenuSection(
                  title: context.l10n.profileSessionSection,
                  items: [
                    ProfileMenuItemData(
                      title: context.l10n.profileLogout,
                      subtitle: context.l10n.profileLogoutSubtitle,
                      icon: Icons.logout_rounded,
                      color: AppColors.coral,
                      onTap: () async {
                        await context.read<AuthCubit>().logout();
                        if (!context.mounted) return;
                        showPetSnackBar(
                          context,
                          context.l10n.profileSignedOut,
                          icon: Icons.logout_rounded,
                          backgroundColor: AppColors.coralDark,
                        );
                        context.goNamed(AppRoute.welcome.name);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
