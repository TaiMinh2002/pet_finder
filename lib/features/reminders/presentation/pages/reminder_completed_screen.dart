import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../widgets/reminders_detail_widgets.dart';
import '../widgets/reminders_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class ReminderCompletedScreen extends StatelessWidget {
  const ReminderCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RemindersScaffold(
      bottomNav: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenNarrow,
          18,
          AppSpacing.screenNarrow,
          40,
        ),
        child: Column(
          children: [
            RemindersHeader(
              title: context.l10n.reminderCompletedTitle,
              subtitle: context.l10n.reminderCompletedDesc,
              leading: CircleGlassButton(
                icon: Icons.arrow_back,
                onTap: () => context.safeBackNamed(AppRoute.remindersOverview),
              ),
            ),
            const Spacer(),
            ReminderSuccessCard(
              onBack: () => context.goNamed(AppRoute.remindersOverview.name),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
