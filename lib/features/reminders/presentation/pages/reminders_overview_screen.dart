import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_status_views.dart';
import '../../../pets/domain/pet_model.dart';
import '../../../pets/presentation/bloc/pets_cubit.dart';
import '../../../pets/presentation/bloc/pets_state.dart';
import '../../domain/reminder_model.dart';
import '../bloc/reminders_cubit.dart';
import '../bloc/reminders_state.dart';
import '../widgets/reminders_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class RemindersOverviewScreen extends StatefulWidget {
  const RemindersOverviewScreen({super.key});

  @override
  State<RemindersOverviewScreen> createState() =>
      _RemindersOverviewScreenState();
}

class _RemindersOverviewScreenState extends State<RemindersOverviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RemindersCubit>().loadUserReminders();
      context.read<PetsCubit>().loadUserPets();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                BlocBuilder<RemindersCubit, RemindersState>(
                  builder: (context, state) {
                    if (state is RemindersLoading ||
                        state is RemindersInitial) {
                      return AppLoadingState(
                        title: context.l10n.reminderOverviewTitle,
                        message: context.l10n.reminderOverviewSubtitle,
                      );
                    }
                    if (state is RemindersError) {
                      return AppErrorState(
                        title: context.l10n.reminderOverviewTitle,
                        message: state.message,
                        onRetry: () =>
                            context.read<RemindersCubit>().loadUserReminders(),
                      );
                    }
                    final reminders = state is RemindersLoaded
                        ? state.reminders
                        : const <ReminderModel>[];
                    final grouped = {
                      for (final bucket in ReminderBucket.values)
                        bucket: reminders
                            .where((item) => item.bucket == bucket)
                            .toList(),
                    };
                    final pets = switch (context.watch<PetsCubit>().state) {
                      PetsLoaded(:final pets) => pets,
                      _ => const <PetModel>[],
                    };

                    return Column(
                      children: [
                        const ReminderHeroCard(),
                        const SizedBox(height: 14),
                        ReminderSummaryStrip(reminders: reminders),
                        const SizedBox(height: 18),
                        AppButton(
                          label: context.l10n.reminderAddBtn,
                          icon: Icons.add_alarm_rounded,
                          onPressed: () =>
                              context.goNamed(AppRoute.remindersAdd.name),
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
                                pets: pets,
                              ),
                              if (bucket != ReminderBucket.values.last)
                                const SizedBox(height: 24),
                            ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
