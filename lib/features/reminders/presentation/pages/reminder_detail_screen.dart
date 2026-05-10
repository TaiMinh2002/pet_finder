import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_status_views.dart';
import '../../../mock/mock_data.dart';
import '../../domain/reminder_model.dart';
import '../widgets/reminders_detail_widgets.dart';
import '../widgets/reminders_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class ReminderDetailScreen extends StatefulWidget {
  const ReminderDetailScreen({required this.reminderId, super.key});

  final String reminderId;

  @override
  State<ReminderDetailScreen> createState() => _ReminderDetailScreenState();
}

class _ReminderDetailScreenState extends State<ReminderDetailScreen> {
  var _isCompleting = false;
  var _isDeleting = false;

  Future<void> _completeReminder() async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.reminderMarkedCompleted,
      icon: Icons.check_circle_outline,
      backgroundColor: AppColors.green,
    );
    setState(() => _isCompleting = false);
    context.goNamed(AppRoute.remindersCompleted.name);
  }

  Future<void> _deleteReminder() async {
    if (_isDeleting) return;
    setState(() => _isDeleting = true);
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.reminderDeleted,
      icon: Icons.delete_outline,
      backgroundColor: AppColors.coralDark,
    );
    setState(() => _isDeleting = false);
    context.goNamed(AppRoute.remindersOverview.name);
  }

  @override
  Widget build(BuildContext context) {
    final reminder = MockData.tryResolveReminder(widget.reminderId);
    if (reminder == null) {
      return RemindersScaffold(
        bottomNav: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenNarrow,
            18,
            AppSpacing.screenNarrow,
            40,
          ),
          child: AppErrorState(
            title: context.l10n.reminderNotFoundTitle,
            message: context.l10n.reminderNotFoundDesc,
            retryLabel: context.l10n.reminderDetailBack,
            onRetry: () => context.goNamed(AppRoute.remindersOverview.name),
          ),
        ),
      );
    }
    final pet = MockData.tryResolvePet(reminder.petId) ?? MockData.pets.first;

    return RemindersScaffold(
      bottomNav: false,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenNarrow,
              18,
              AppSpacing.screenNarrow,
              124,
            ),
            sliver: SliverList.list(
              children: [
                RemindersHeader(
                  title: context.l10n.reminderDetailTitle,
                  subtitle: context.l10n.reminderDetailSubtitle,
                  leading: CircleGlassButton(
                    icon: Icons.arrow_back,
                    onTap: () =>
                        context.safeBackNamed(AppRoute.remindersOverview),
                  ),
                ),
                const SizedBox(height: 18),
                ReminderDetailHero(reminder: reminder, pet: pet),
                const SizedBox(height: 14),
                ReminderPetInfoCard(pet: pet),
                const SizedBox(height: 14),
                ReminderInfoCard(
                  title: context.l10n.reminderSchedule,
                  rows: [
                    (
                      context.l10n.reminderAddType,
                      reminderCategoryMeta(context, reminder.category).label,
                    ),
                    (context.l10n.reminderAddDate, reminder.dateLabel),
                    (context.l10n.reminderAddTime, reminder.timeLabel),
                    (context.l10n.remindersRepeat, reminder.repeatLabel),
                    (
                      context.l10n.notiTitle,
                      reminder.notificationsEnabled
                          ? context.l10n.reminderNotificationsEnabled
                          : context.l10n.reminderNotificationsMuted,
                    ),
                    (
                      context.l10n.reportStatus,
                      switch (reminder.status) {
                        ReminderStatus.upcoming =>
                          context.l10n.remindersStatusUpcoming,
                        ReminderStatus.dueSoon =>
                          context.l10n.remindersStatusDueSoon,
                        ReminderStatus.completed =>
                          context.l10n.remindersStatusCompleted,
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ReminderInfoCard(
                  title: context.l10n.reminderNotes,
                  rows: [(context.l10n.reminderCareNote, reminder.notes)],
                ),
                const SizedBox(height: 18),
                ReminderActionButtonRow(
                  isCompleting: _isCompleting,
                  isDeleting: _isDeleting,
                  onComplete: _completeReminder,
                  onEdit: () => context.goNamed(
                    AppRoute.remindersEdit.name,
                    pathParameters: {'reminderId': reminder.id},
                  ),
                  onDelete: _deleteReminder,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
