import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../mock/mock_data.dart';
import '../../../pets/domain/pet_model.dart';
import '../../domain/reminder_model.dart';
import '../widgets/reminders_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key, this.reminderId});

  final String? reminderId;

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late PetModel _selectedPet;
  late ReminderCategory _selectedCategory;
  late String _dateLabel;
  late String _timeLabel;
  late String _repeatLabel;
  late bool _notificationsEnabled;
  var _isSaving = false;

  ReminderModel? get _editingReminder {
    final reminderId = widget.reminderId;
    if (reminderId == null || reminderId.isEmpty) {
      return null;
    }
    for (final reminder in MockData.reminders) {
      if (reminder.id == reminderId) {
        return reminder;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final editingReminder = _editingReminder;
    final pet = editingReminder == null
        ? MockData.pets.first
        : MockData.pets.firstWhere(
            (item) => item.id == editingReminder.petId,
            orElse: () => MockData.pets.first,
          );

    _selectedPet = pet;
    _selectedCategory =
        editingReminder?.category ?? ReminderCategory.vaccination;
    _dateLabel = editingReminder?.dateLabel ?? 'Friday, May 2';
    _timeLabel = editingReminder?.timeLabel ?? '9:00 AM';
    _repeatLabel = editingReminder?.repeatLabel ?? 'Monthly';
    _notificationsEnabled = editingReminder?.notificationsEnabled ?? true;
    _titleController = TextEditingController(
      text: editingReminder?.title ?? 'Rabies booster',
    );
    _notesController = TextEditingController(
      text:
          editingReminder?.notes ??
          'Helpful note: bring the pet booklet and a favorite treat.',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveReminder() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.remindersSaved,
      icon: Icons.favorite,
      backgroundColor: AppColors.teal,
    );
    setState(() => _isSaving = false);
    context.goNamed(
      AppRoute.remindersDetail.name,
      pathParameters: {
        'reminderId': widget.reminderId ?? MockData.reminders.first.id,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingReminder != null;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return RemindersScaffold(
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
                  128 + bottomInset,
                ),
                sliver: SliverList.list(
                  children: [
                    RemindersHeader(
                      title: isEditing
                          ? context.l10n.remindersEditTitle
                          : context.l10n.remindersAddTitle,
                      subtitle: context.l10n.reminderAddSubtitle,
                      leading: CircleGlassButton(
                        icon: Icons.arrow_back,
                        onTap: () =>
                            context.safeBackNamed(AppRoute.remindersOverview),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ReminderFormCard(
                      title: context.l10n.reminderAddWhat,
                      children: [
                        ReminderSelectorField(
                          label: context.l10n.reminderAddPet,
                          value: _selectedPet.name,
                          icon: _selectedPet.type == PetType.dog
                              ? Icons.pets
                              : Icons.cruelty_free,
                          accent: AppColors.coral,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          context.l10n.reminderAddType,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ReminderChoiceWrap<ReminderCategory>(
                          items: ReminderCategory.values,
                          selected: _selectedCategory,
                          labelOf: (item) =>
                              reminderCategoryMeta(context, item).label,
                          onSelected: (item) =>
                              setState(() => _selectedCategory = item),
                        ),
                        const SizedBox(height: 14),
                        AppTextField(
                          label: context.l10n.communityWidgetTitleLabel,
                          hint: context.l10n.remindersTitleHint,
                          icon: reminderCategoryMeta(
                            context,
                            _selectedCategory,
                          ).icon,
                          controller: _titleController,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ReminderFormCard(
                      title: context.l10n.reminderAddWhen,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ReminderSelectorField(
                                label: context.l10n.reminderAddDate,
                                value: _dateLabel,
                                icon: Icons.event_outlined,
                                accent: AppColors.teal,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ReminderSelectorField(
                                label: context.l10n.reminderAddTime,
                                value: _timeLabel,
                                icon: Icons.schedule,
                                accent: AppColors.coral,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ReminderSelectorField(
                          label: context.l10n.reminderAddRepeat,
                          value: _repeatLabel,
                          icon: Icons.repeat,
                          accent: AppColors.teal,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          context.l10n.reminderAddRepeatHint,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ReminderFormCard(
                      title: context.l10n.reminderAddHelpfulNotes,
                      children: [
                        AppTextField(
                          label: context.l10n.reminderNotes,
                          hint: context.l10n.remindersNotesHint,
                          icon: Icons.notes_rounded,
                          controller: _notesController,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 14),
                        ReminderNotificationTile(
                          value: _notificationsEnabled,
                          onChanged: (value) =>
                              setState(() => _notificationsEnabled = value),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: AppSpacing.screenNarrow,
            right: AppSpacing.screenNarrow,
            bottom: 28 + bottomInset,
            child: AppButton(
              label: isEditing
                  ? context.l10n.remindersSaveChanges
                  : context.l10n.remindersSave,
              icon: Icons.favorite,
              isLoading: _isSaving,
              onPressed: _saveReminder,
            ),
          ),
        ],
      ),
    );
  }
}
