import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/profile_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var nearbyAlerts = true;
  var chatNotifications = true;
  var exactLocation = false;
  var darkMode = false;
  var _isSaving = false;

  Future<void> _saveSettings() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.settingsSaved,
      icon: Icons.settings,
      backgroundColor: AppColors.teal,
    );
    setState(() => _isSaving = false);
  }

  String _currentLanguageLabel(BuildContext context) {
    return switch (appLocaleController.locale.languageCode) {
      'en' => context.l10n.languageEnglish,
      'ja' => context.l10n.languageJapanese,
      'ko' => context.l10n.languageKorean,
      'zh' => context.l10n.languageChinese,
      _ => context.l10n.languageVietnamese,
    };
  }

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
                  title: context.l10n.settingsTitle,
                  subtitle: context.l10n.settingsSubtitle,
                  leading: CircleGlassButton(
                    icon: Icons.arrow_back,
                    onTap: () =>
                        context.safeBackNamed(AppRoute.profileOverview),
                  ),
                ),
                const SizedBox(height: 18),
                SettingsSectionCard(
                  title: context.l10n.settingsNotificationsSection,
                  children: [
                    SettingsToggleRow(
                      title: context.l10n.settingsNearbyAlerts,
                      subtitle: context.l10n.settingsNearbyAlertsSubtitle,
                      value: nearbyAlerts,
                      onChanged: (value) =>
                          setState(() => nearbyAlerts = value),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.black.withValues(alpha: 0.08)),
                    const SizedBox(height: 12),
                    SettingsToggleRow(
                      title: context.l10n.settingsChatNotifications,
                      subtitle: context.l10n.settingsChatNotificationsSubtitle,
                      value: chatNotifications,
                      onChanged: (value) =>
                          setState(() => chatNotifications = value),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SettingsSectionCard(
                  title: context.l10n.settingsLocationSection,
                  children: [
                    SettingsRowItem(
                      title: context.l10n.settingsAlertRadius,
                      value: '5 km',
                    ),
                    SizedBox(height: 12),
                    Divider(color: Color(0x14000000)),
                    SizedBox(height: 12),
                    SettingsRowItem(
                      title: context.l10n.settingsDefaultCity,
                      value: 'Ho Chi Minh City',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SettingsSectionCard(
                  title: context.l10n.settingsPrivacySection,
                  children: [
                    SettingsToggleRow(
                      title: context.l10n.settingsShowExactLocation,
                      subtitle: context.l10n.settingsShowExactLocationSubtitle,
                      value: exactLocation,
                      onChanged: (value) =>
                          setState(() => exactLocation = value),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.black.withValues(alpha: 0.08)),
                    const SizedBox(height: 12),
                    SettingsRowItem(
                      title: context.l10n.settingsContactVisibility,
                      value: context.l10n.settingsSafeMode,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SettingsSectionCard(
                  title: context.l10n.settingsAppearanceSection,
                  children: [
                    SettingsToggleRow(
                      title: context.l10n.settingsDarkMode,
                      subtitle: context.l10n.settingsDarkModeSubtitle,
                      value: darkMode,
                      onChanged: (value) => setState(() => darkMode = value),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SettingsSectionCard(
                  title: context.l10n.settingsLanguageSection,
                  children: [
                    SettingsRowItem(
                      title: context.l10n.settingsAppLanguage,
                      value: _currentLanguageLabel(context),
                      onTap: () => context.push(AppRoute.language.path),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SettingsSectionCard(
                  title: context.l10n.settingsAlertRadiusSection,
                  children: [
                    SettingsRowItem(
                      title: context.l10n.settingsNearbySearchDistance,
                      value: '5 km',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: context.l10n.settingsSaveButton,
                  icon: Icons.check_circle_outline,
                  isLoading: _isSaving,
                  onPressed: _saveSettings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
