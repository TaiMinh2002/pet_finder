import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../profile/presentation/widgets/profile_widgets.dart';
import '../widgets/language_widgets.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  static const _allLanguages = <LanguageOption>[
    LanguageOption(
      code: 'vi',
      label: 'vi',
      flag: 'VI',
      backgroundColor: AppColors.fieldCool,
    ),
    LanguageOption(
      code: 'en',
      label: 'en',
      flag: 'EN',
      backgroundColor: AppColors.lostSoft,
    ),
    LanguageOption(
      code: 'ja',
      label: 'ja',
      flag: '日',
      backgroundColor: AppColors.lostSoft,
    ),
    LanguageOption(
      code: 'ko',
      label: 'ko',
      flag: '한',
      backgroundColor: AppColors.fieldCool,
    ),
    LanguageOption(
      code: 'zh',
      label: 'zh',
      flag: '中',
      backgroundColor: AppColors.lostSoft,
    ),
  ];

  late final TextEditingController _searchController;
  String _selectedLanguageCode = 'vi';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedLanguageCode = appLocaleController.locale.languageCode;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LanguageOption> get _filteredLanguages {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _allLanguages;
    }
    return _allLanguages
        .where(
          (language) => _localizedLabel(
            context,
            language.code,
          ).toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> _applyLanguage() async {
    await appLocaleController.updateLocale(Locale(_selectedLanguageCode));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.languageUpdated,
      icon: Icons.language_rounded,
      backgroundColor: AppColors.teal,
    );
  }

  String _localizedLabel(BuildContext context, String code) {
    return switch (code) {
      'vi' => context.l10n.languageVietnamese,
      'en' => context.l10n.languageEnglish,
      'ja' => context.l10n.languageJapanese,
      'ko' => context.l10n.languageKorean,
      'zh' => context.l10n.languageChinese,
      _ => code.toUpperCase(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final languages = _filteredLanguages;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final currentLanguage = _allLanguages.firstWhere(
      (language) => language.code == _selectedLanguageCode,
      orElse: () => _allLanguages.first,
    );

    return ProfileScaffold(
      bottomNav: false,
      child: Stack(
        children: [
          CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenNarrow,
                  18,
                  AppSpacing.screenNarrow,
                  136 + bottomInset,
                ),
                sliver: SliverList.list(
                  children: [
                    ProfileHeader(
                      title: context.l10n.languageTitle,
                      subtitle: context.l10n.languageSubtitle,
                      leading: CircleGlassButton(
                        icon: Icons.arrow_back,
                        onTap: () => context.safeBackNamed(AppRoute.settings),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Text(
                        context.l10n.languageChooseTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heroTitle.copyWith(fontSize: 35),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 310),
                        child: Text(
                          context.l10n.languageChooseBody,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.muted,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CurrentLanguageCard(
                      currentLanguage: LanguageOption(
                        code: currentLanguage.code,
                        label: _localizedLabel(context, currentLanguage.code),
                        flag: currentLanguage.flag,
                        backgroundColor: currentLanguage.backgroundColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LanguageSearchField(
                      controller: _searchController,
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                    ),
                    const SizedBox(height: 16),
                    if (languages.isEmpty)
                      AppCard(
                        radius: 30,
                        padding: const EdgeInsets.all(22),
                        child: EmptyState(
                          title: context.l10n.languageNoResultTitle,
                          message: context.l10n.languageNoResultMessage,
                          icon: Icons.travel_explore_rounded,
                        ),
                      )
                    else
                      Column(
                        children: [
                          for (var i = 0; i < languages.length; i++) ...[
                            LanguageOptionTile(
                              option: LanguageOption(
                                code: languages[i].code,
                                label: _localizedLabel(
                                  context,
                                  languages[i].code,
                                ),
                                flag: languages[i].flag,
                                backgroundColor: languages[i].backgroundColor,
                              ),
                              selected:
                                  languages[i].code == _selectedLanguageCode,
                              onTap: () => setState(
                                () => _selectedLanguageCode = languages[i].code,
                              ),
                            ),
                            if (i != languages.length - 1)
                              const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    const SizedBox(height: 18),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: LanguageHelperNote(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 28,
            right: 28,
            bottom: 24 + bottomInset,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.languageHelperNote,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                AppButton(
                  label: context.l10n.languageApplyButton,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: _applyLanguage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
