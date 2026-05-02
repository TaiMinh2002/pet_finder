import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../mock/mock_data.dart';
import '../../domain/reminder_model.dart';
import '../widgets/reminders_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class RemindersOverviewScreen extends StatelessWidget {
  const RemindersOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reminders = MockData.reminders;
    final grouped = {
      for (final bucket in ReminderBucket.values)
        bucket: reminders.where((item) => item.bucket == bucket).toList(),
    };

    return RemindersScaffold(
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
                RemindersHeader(
                  title: context.l10n.reminderOverviewTitle,
                  subtitle: context.l10n.reminderOverviewSubtitle,
                  trailing: SizedBox(
                    width: 48,
                    height: 48,
                    child: AppButton(
                      label: '+',
                      height: 48,
                      expand: false,
                      onPressed: () =>
                          context.goNamed(AppRoute.remindersAdd.name),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const ReminderHeroCard(),
                const SizedBox(height: 14),
                ReminderSummaryStrip(reminders: reminders),
                const SizedBox(height: 18),
                AppButton(
                  label: context.l10n.reminderAddBtn,
                  icon: Icons.add_alarm_rounded,
                  onPressed: () => context.goNamed(AppRoute.remindersAdd.name),
                ),
                const SizedBox(height: 22),
                if (reminders.isEmpty)
                  ReminderEmptyCard(
                    onAddReminder: () =>
                        context.goNamed(AppRoute.remindersAdd.name),
                  )
                else
                  for (final bucket in ReminderBucket.values)
                    if ((grouped[bucket] ?? []).isNotEmpty) ...[
                      ReminderGroupSection(
                        title: reminderBucketLabel(context, bucket),
                        reminders: grouped[bucket]!,
                      ),
                      if (bucket != ReminderBucket.values.last)
                        const SizedBox(height: 24),
                    ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
