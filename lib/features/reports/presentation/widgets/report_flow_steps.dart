part of '../pages/report_flow_screen.dart';

String _reportPetTypeLabel(BuildContext context, String value) {
  if (value == 'dog' || value == context.l10n.petWidgetTypeDog) {
    return context.l10n.reportFlowPetTypeDog;
  }
  if (value == 'cat' || value == context.l10n.petWidgetTypeCat) {
    return context.l10n.reportFlowPetTypeCat;
  }
  if (value == 'other' || value == context.l10n.petWidgetTypeOther) {
    return context.l10n.reportFlowPetTypeOther;
  }
  return value;
}

String _reportGenderLabel(BuildContext context, String value) {
  if (value == 'female' || value == context.l10n.petWidgetGenderFemale) {
    return context.l10n.reportFlowGenderFemale;
  }
  if (value == 'male' || value == context.l10n.petWidgetGenderMale) {
    return context.l10n.reportFlowGenderMale;
  }
  return value;
}

String _reportDateLabel(BuildContext context, String value) {
  if (value == 'today' || value == 'Today') {
    return context.l10n.reportFlowToday;
  }
  if (value == 'yesterday' || value == 'Yesterday') {
    return context.l10n.reportFlowYesterday;
  }
  return value;
}

class ReportFlowChooseTypeStep extends StatelessWidget {
  const ReportFlowChooseTypeStep({
    required this.draft,
    required this.onTypeChanged,
    required this.onNext,
    super.key,
  });

  final ReportDraft draft;
  final ValueChanged<PetReportType> onTypeChanged;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return ReportFlowScaffold(
      stepLabel: context.l10n.reportFlowStepCounter(1, 7),
      title: context.l10n.reportFlowStep1Title,
      subtitle: context.l10n.reportFlowStep1Subtitle,
      progress: 1 / 7,
      onBack: () => context.safeBackNamed(AppRoute.home),
      bottom: ReportBottomBar(
        primaryLabel: context.l10n.reportFlowNext,
        onPrimary: onNext,
        primaryIcon: Icons.arrow_forward,
      ),
      child: Column(
        children: [
          ReportSelectCard(
            title: context.l10n.reportFlowLostTitle,
            description: context.l10n.reportFlowLostDescription,
            selected: draft.type == PetReportType.lost,
            icon: Icons.campaign,
            accent: AppColors.coral,
            onTap: () => onTypeChanged(PetReportType.lost),
          ),
          const SizedBox(height: 14),
          ReportSelectCard(
            title: context.l10n.reportFlowFoundTitle,
            description: context.l10n.reportFlowFoundDescription,
            selected: draft.type == PetReportType.found,
            icon: Icons.favorite,
            accent: AppColors.teal,
            onTap: () => onTypeChanged(PetReportType.found),
          ),
          const SizedBox(height: 16),
          ReportInfoChip(
            label: context.l10n.reportFlowGuidedEditable,
            icon: Icons.shield_outlined,
            color: AppColors.green,
          ),
          const SizedBox(height: 16),
          AppCard(
            color: AppColors.glassSoft,
            radius: 24,
            shadow: AppShadows.softCard,
            padding: const EdgeInsets.all(14),
            child: Text(
              context.l10n.reportFlowEditableNote,
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportFlowUploadPhotosStep extends StatelessWidget {
  const ReportFlowUploadPhotosStep({
    required this.draft,
    required this.onBack,
    required this.onNext,
    super.key,
  });

  final ReportDraft draft;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return ReportFlowScaffold(
      stepLabel: context.l10n.reportFlowStepCounter(2, 7),
      title: context.l10n.reportFlowStep2Title,
      subtitle: context.l10n.reportFlowStep2Subtitle,
      progress: 2 / 7,
      onBack: onBack,
      bottom: ReportBottomBar(
        primaryLabel: context.l10n.reportFlowNext,
        onPrimary: onNext,
        primaryIcon: Icons.arrow_forward,
      ),
      child: Column(
        children: [
          ReportUploadCard(labels: draft.photoLabels),
          const SizedBox(height: 16),
          ReportInfoChip(
            label: context.l10n.reportFlowClearTips,
            icon: Icons.auto_awesome,
            color: Color(0xFFFACC15),
          ),
          const SizedBox(height: 12),
          AppCard(
            color: AppColors.glassSoft,
            radius: 22,
            shadow: AppShadows.softCard,
            padding: const EdgeInsets.all(14),
            child: Text(
              context.l10n.reportFlowClearTipsBody,
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportFlowPetInformationStep extends StatelessWidget {
  const ReportFlowPetInformationStep({
    required this.draft,
    required this.petNameController,
    required this.breedController,
    required this.colorController,
    required this.marksController,
    required this.onBack,
    required this.onNext,
    required this.onTypeChanged,
    required this.onGenderChanged,
    super.key,
  });

  final ReportDraft draft;
  final TextEditingController petNameController;
  final TextEditingController breedController;
  final TextEditingController colorController;
  final TextEditingController marksController;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    return ReportFlowScaffold(
      stepLabel: context.l10n.reportFlowStepCounter(3, 7),
      title: context.l10n.reportFlowStep3Title,
      subtitle: context.l10n.reportFlowStep3Subtitle,
      progress: 3 / 7,
      onBack: onBack,
      bottom: ReportBottomBar(
        primaryLabel: context.l10n.reportFlowNext,
        onPrimary: onNext,
        primaryIcon: Icons.arrow_forward,
      ),
      child: Column(
        children: [
          AppCard(
            color: AppColors.glass,
            radius: 32,
            shadow: AppShadows.raisedCard,
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                AppTextField(
                  label: context.l10n.reportFlowPetName,
                  hint: context.l10n.reportFlowPetNameHint,
                  icon: Icons.pets,
                  controller: petNameController,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ReportFlowPseudoField(
                        label: context.l10n.reportFlowType,
                        value: _reportPetTypeLabel(context, draft.petType),
                        icon: Icons.arrow_drop_down,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ReportFlowPseudoField(
                        label: context.l10n.reportFlowGender,
                        value: _reportGenderLabel(context, draft.gender),
                        icon: Icons.arrow_drop_down,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    CircleChoiceChip(
                      label: context.l10n.reportFlowPetTypeDog,
                      selected: draft.petType == 'dog',
                      onTap: () => onTypeChanged('dog'),
                    ),
                    CircleChoiceChip(
                      label: context.l10n.reportFlowPetTypeCat,
                      selected: draft.petType == 'cat',
                      onTap: () => onTypeChanged('cat'),
                    ),
                    CircleChoiceChip(
                      label: context.l10n.reportFlowPetTypeOther,
                      selected: draft.petType == 'other',
                      onTap: () => onTypeChanged('other'),
                    ),
                    CircleChoiceChip(
                      label: context.l10n.reportFlowGenderFemale,
                      selected: draft.gender == 'female',
                      onTap: () => onGenderChanged('female'),
                    ),
                    CircleChoiceChip(
                      label: context.l10n.reportFlowGenderMale,
                      selected: draft.gender == 'male',
                      onTap: () => onGenderChanged('male'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: context.l10n.reportFlowBreed,
                  hint: context.l10n.reportFlowBreedHint,
                  icon: Icons.badge_outlined,
                  controller: breedController,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: context.l10n.reportFlowColor,
                  hint: context.l10n.reportFlowColorHint,
                  icon: Icons.palette_outlined,
                  controller: colorController,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: context.l10n.reportFlowSpecialMarks,
                  hint: context.l10n.reportFlowSpecialMarksHint,
                  icon: Icons.edit_note_outlined,
                  controller: marksController,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ReportInfoChip(
            label: context.l10n.reportFlowDetailsHelpMatch,
            icon: Icons.verified,
            color: AppColors.teal,
          ),
        ],
      ),
    );
  }
}

class ReportFlowLocationTimeStep extends StatelessWidget {
  const ReportFlowLocationTimeStep({
    required this.draft,
    required this.addressController,
    required this.onBack,
    required this.onNext,
    required this.onDateChanged,
    required this.onTimeChanged,
    super.key,
  });

  final ReportDraft draft;
  final TextEditingController addressController;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final ValueChanged<String> onDateChanged;
  final ValueChanged<String> onTimeChanged;

  @override
  Widget build(BuildContext context) {
    return ReportFlowScaffold(
      stepLabel: context.l10n.reportFlowStepCounter(4, 7),
      title: context.l10n.reportFlowStep4Title,
      subtitle: context.l10n.reportFlowStep4Subtitle,
      progress: 4 / 7,
      onBack: onBack,
      bottom: ReportBottomBar(
        primaryLabel: context.l10n.reportFlowNext,
        onPrimary: onNext,
        primaryIcon: Icons.arrow_forward,
      ),
      child: Column(
        children: [
          const ReportMapPlaceholder(),
          const SizedBox(height: 14),
          AppButton(
            label: context.l10n.reportFlowUseLocation,
            onPressed: () {},
            icon: Icons.my_location,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: context.l10n.reportFlowAddressLabel,
            hint: context.l10n.reportFlowAddressHint,
            icon: Icons.place_outlined,
            controller: addressController,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ReportFlowPseudoField(
                  label: context.l10n.reportFlowDate,
                  value: _reportDateLabel(context, draft.dateLabel),
                  icon: Icons.calendar_month,
                  onTap: () => onDateChanged(
                    draft.dateLabel == 'today' ? 'yesterday' : 'today',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ReportFlowPseudoField(
                  label: context.l10n.reportFlowTime,
                  value: draft.timeLabel,
                  icon: Icons.access_time,
                  onTap: () => onTimeChanged(
                    draft.timeLabel == '6:20 PM' ? '7:05 PM' : '6:20 PM',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppCard(
            color: AppColors.white.withValues(alpha: 0.5),
            radius: 14,
            shadow: AppShadows.softCard,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.green,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.reportFlowAccurateLocationHelp,
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReportFlowContactInfoStep extends StatelessWidget {
  const ReportFlowContactInfoStep({
    required this.draft,
    required this.phoneController,
    required this.altController,
    required this.onBack,
    required this.onNext,
    required this.onVisibilityChanged,
    super.key,
  });

  final ReportDraft draft;
  final TextEditingController phoneController;
  final TextEditingController altController;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final ValueChanged<bool> onVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    return ReportFlowScaffold(
      stepLabel: context.l10n.reportFlowStepCounter(5, 7),
      title: context.l10n.reportFlowStep5Title,
      subtitle: context.l10n.reportFlowStep5Subtitle,
      progress: 5 / 7,
      onBack: onBack,
      bottom: ReportBottomBar(
        primaryLabel: context.l10n.reportFlowContinueReview,
        onPrimary: onNext,
        primaryIcon: Icons.arrow_forward,
      ),
      child: Column(
        children: [
          ReportIllustrationCard(
            title: context.l10n.reportFlowStayReachableTitle,
            subtitle: context.l10n.reportFlowStayReachableSubtitle,
            icon: Icons.phone_in_talk_outlined,
            accent: AppColors.teal,
          ),
          const SizedBox(height: 16),
          AppCard(
            color: AppColors.glass,
            radius: 30,
            shadow: AppShadows.raisedCard,
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                AppTextField(
                  label: context.l10n.reportFlowPhoneLabel,
                  hint: context.l10n.reportFlowPhoneHint,
                  icon: Icons.phone_outlined,
                  controller: phoneController,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: context.l10n.reportFlowAltLabel,
                  hint: context.l10n.reportFlowAltHint,
                  icon: Icons.chat_bubble_outline,
                  controller: altController,
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      CircleChoiceChip(
                        label: context.l10n.reportFlowPhoneVisible,
                        selected: draft.isPhoneVisible,
                        onTap: () => onVisibilityChanged(true),
                      ),
                      CircleChoiceChip(
                        label: context.l10n.reportFlowHidePhone,
                        selected: !draft.isPhoneVisible,
                        onTap: () => onVisibilityChanged(false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ReportInfoChip(
            label: draft.isPhoneVisible
                ? context.l10n.reportFlowPhoneVisibleLabel
                : context.l10n.reportFlowVisibilityControl,
            icon: draft.isPhoneVisible
                ? Icons.call_outlined
                : Icons.lock_outline,
            color: draft.isPhoneVisible ? AppColors.coral : AppColors.teal,
          ),
        ],
      ),
    );
  }
}

class ReportFlowReviewStep extends StatelessWidget {
  const ReportFlowReviewStep({
    required this.draft,
    required this.isPublishing,
    required this.onBack,
    required this.onPublish,
    super.key,
  });

  final ReportDraft draft;
  final bool isPublishing;
  final VoidCallback onBack;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return ReportFlowScaffold(
      stepLabel: context.l10n.reportFlowStepCounter(6, 7),
      title: context.l10n.reportFlowStep6Title,
      subtitle: context.l10n.reportFlowStep6Subtitle,
      progress: 6 / 7,
      onBack: onBack,
      bottom: ReportBottomBar(
        primaryLabel: context.l10n.reportFlowPublish,
        onPrimary: onPublish,
        primaryIcon: Icons.campaign,
        isPrimaryLoading: isPublishing,
      ),
      child: Column(
        children: [
          AppCard(
            color: AppColors.glass,
            radius: 30,
            shadow: AppShadows.raisedCard,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 94,
                  height: 94,
                  decoration: BoxDecoration(
                    gradient: draft.type == PetReportType.lost
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.peach, AppColors.cream],
                          )
                        : const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFDDF7F6), AppColors.white],
                          ),
                    borderRadius: AppRadius.cardBorder,
                  ),
                  child: Icon(
                    draft.type == PetReportType.lost
                        ? Icons.pets
                        : Icons.favorite,
                    color: draft.type == PetReportType.lost
                        ? AppColors.coral
                        : AppColors.teal,
                    size: 38,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppChip(
                        label: draft.type == PetReportType.lost
                            ? context.l10n.reportFlowTagLost
                            : context.l10n.reportFlowTagFound,
                        selected: true,
                      ),
                      const SizedBox(height: 10),
                      Text(draft.petName, style: AppTextStyles.title),
                      const SizedBox(height: 4),
                      Text(
                        '${draft.breed} • ${draft.address}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ReportReviewCard(
            title: context.l10n.reportFlowPetDetails,
            rows: [
              (
                context.l10n.reportFlowType,
                _reportPetTypeLabel(context, draft.petType),
              ),
              (
                context.l10n.reportFlowGender,
                _reportGenderLabel(context, draft.gender),
              ),
              (context.l10n.reportFlowColor, draft.color),
              (context.l10n.reportFlowSpecialMarks, draft.specialMarks),
            ],
          ),
          const SizedBox(height: 14),
          ReportReviewCard(
            title: context.l10n.reportFlowLocationTime,
            rows: [
              (context.l10n.reportFlowAddressLabel, draft.address),
              (
                context.l10n.reportFlowDate,
                _reportDateLabel(context, draft.dateLabel),
              ),
              (context.l10n.reportFlowTime, draft.timeLabel),
            ],
          ),
          const SizedBox(height: 14),
          ReportReviewCard(
            title: context.l10n.reportFlowContact,
            rows: [
              (context.l10n.reportFlowPhoneLabel, draft.phone),
              (context.l10n.reportFlowContactAlternate, draft.altContact),
              (
                context.l10n.reportFlowVisibility,
                draft.isPhoneVisible
                    ? context.l10n.reportFlowPhoneVisibleLabel
                    : context.l10n.reportFlowPhoneHiddenLabel,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            context.l10n.reportFlowUpdatePauseNote,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.muted.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportFlowSuccessStep extends StatelessWidget {
  const ReportFlowSuccessStep({
    required this.draft,
    required this.onGoHome,
    required this.onViewReport,
    super.key,
  });

  final ReportDraft draft;
  final VoidCallback onGoHome;
  final VoidCallback onViewReport;

  @override
  Widget build(BuildContext context) {
    final copy = draft.type == PetReportType.lost
        ? context.l10n.reportFlowSuccessLostSubtitle
        : context.l10n.reportFlowSuccessFoundSubtitle;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmSky),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 38, 28, 28),
            child: Column(
              children: [
                const Spacer(),
                ReportIllustrationCard(
                  title: context.l10n.reportFlowSuccessTitle,
                  subtitle: copy,
                  icon: Icons.favorite,
                  accent: draft.type == PetReportType.lost
                      ? AppColors.coral
                      : AppColors.green,
                ),
                const SizedBox(height: 18),
                AppCard(
                  color: AppColors.glassSoft,
                  radius: 24,
                  shadow: AppShadows.softCard,
                  padding: const EdgeInsets.all(16),
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
                          Icons.radio,
                          color: AppColors.green,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.l10n.reportFlowSuccessNearbyResponse,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.charcoal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ReportBottomBar(
                  secondaryLabel: context.l10n.reportFlowViewReport,
                  onSecondary: onViewReport,
                  primaryLabel: context.l10n.commonBackToHome,
                  onPrimary: onGoHome,
                  primaryIcon: Icons.home_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReportFlowPseudoField extends StatelessWidget {
  const ReportFlowPseudoField({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.mdBorder,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.fieldWarm,
          borderRadius: AppRadius.mdBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.charcoal),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text(value, style: AppTextStyles.bodyStrong)),
                Icon(icon, color: AppColors.coral, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
