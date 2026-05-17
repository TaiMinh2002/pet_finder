import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../pets/domain/pet_model.dart';
import '../../domain/reminder_model.dart';

class RemindersScaffold extends StatelessWidget {
  const RemindersScaffold({
    required this.child,
    super.key,
    this.bottomNav = true,
    this.floatingAction,
  });

  final Widget child;
  final bool bottomNav;
  final Widget? floatingAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const _RemindersBackdrop(),
              child,
              ...switch (floatingAction) {
                final Widget action => [action],
                null => const <Widget>[],
              },
              if (bottomNav)
                const Positioned(
                  left: 18,
                  right: 18,
                  bottom: 22,
                  child: RemindersBottomNavigation(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RemindersBottomNavigation extends StatelessWidget {
  const RemindersBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      AppBottomNavItem(
        icon: Icons.home_rounded,
        label: context.l10n.commonHome,
      ),
      AppBottomNavItem(
        icon: Icons.calendar_month,
        label: context.l10n.homeQuickReminders,
      ),
      AppBottomNavItem(icon: Icons.pets, label: context.l10n.commonPets),
      AppBottomNavItem(
        icon: Icons.person_outline,
        label: context.l10n.commonProfile,
      ),
    ];
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        AppBottomNav(
          currentIndex: 1,
          onChanged: (index) {
            if (index == 0) {
              context.goNamed(AppRoute.home.name);
            } else if (index == 1) {
              context.goNamed(AppRoute.remindersOverview.name);
            } else if (index == 2) {
              context.goNamed(AppRoute.petsList.name);
            } else if (index == 3) {
              context.goNamed(AppRoute.profileOverview.name);
            }
          },
          items: items,
        ),
        Positioned(
          top: -18,
          child: InkWell(
            borderRadius: AppRadius.pillBorder,
            onTap: () => context.goNamed(AppRoute.remindersAdd.name),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.coral,
                shape: BoxShape.circle,
                boxShadow: AppShadows.primaryButton,
                border: Border.all(color: AppColors.white, width: 4),
              ),
              child: const Icon(Icons.add, color: AppColors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}

class RemindersHeader extends StatelessWidget {
  const RemindersHeader({
    required this.title,
    required this.subtitle,
    super.key,
    this.leading,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 14)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.heroTitle.copyWith(
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: AppTextStyles.body.copyWith(fontSize: 13)),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}

class CircleGlassButton extends StatelessWidget {
  const CircleGlassButton({required this.icon, required this.onTap, super.key});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.pillBorder,
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: AppRadius.cardBorder,
          boxShadow: AppShadows.floating,
        ),
        child: Icon(icon, color: AppColors.charcoal, size: 20),
      ),
    );
  }
}

class ReminderHeroCard extends StatelessWidget {
  const ReminderHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 30,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.reminderWidgetCalmPlan,
                  style: AppTextStyles.title,
                ),
                SizedBox(height: 8),
                Text(
                  context.l10n.reminderWidgetTrack,
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const AppAssetImage(
              assetPath: AppImages.remindersHero,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}

class ReminderSummaryStrip extends StatelessWidget {
  const ReminderSummaryStrip({required this.reminders, super.key});

  final List<ReminderModel> reminders;

  @override
  Widget build(BuildContext context) {
    final dueSoon = reminders
        .where((item) => item.status == ReminderStatus.dueSoon)
        .length;
    final completed = reminders
        .where((item) => item.status == ReminderStatus.completed)
        .length;

    return Row(
      children: [
        Expanded(
          child: _SummaryPill(
            title: '${reminders.length}',
            caption: context.l10n.remindersActiveLabel,
            color: AppColors.coral,
            icon: Icons.notifications_active_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryPill(
            title: '$dueSoon',
            caption: context.l10n.remindersDueTodayLabel,
            color: AppColors.teal,
            icon: Icons.schedule,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryPill(
            title: '$completed',
            caption: context.l10n.remindersCompletedLabel,
            color: AppColors.green,
            icon: Icons.check_circle_outline,
          ),
        ),
      ],
    );
  }
}

class ReminderGroupSection extends StatelessWidget {
  const ReminderGroupSection({
    required this.title,
    required this.reminders,
    required this.pets,
    super.key,
  });

  final String title;
  final List<ReminderModel> reminders;
  final List<PetModel> pets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.coral,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(title, style: AppTextStyles.sectionTitle),
          ],
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < reminders.length; index++) ...[
          ReminderTimelineCard(
            reminder: reminders[index],
            pets: pets,
            isLast: index == reminders.length - 1,
          ),
          if (index != reminders.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class ReminderTimelineCard extends StatelessWidget {
  const ReminderTimelineCard({
    required this.reminder,
    required this.pets,
    super.key,
    this.isLast = false,
  });

  final ReminderModel reminder;
  final List<PetModel> pets;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final pet = pets.where((item) => item.id == reminder.petId).firstOrNull;
    final categoryMeta = reminderCategoryMeta(context, reminder.category);

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () => context.goNamed(
        AppRoute.remindersDetail.name,
        pathParameters: {'reminderId': reminder.id},
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: categoryMeta.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: categoryMeta.color.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 120,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: AppColors.charcoal.withValues(alpha: 0.08),
                      borderRadius: AppRadius.pillBorder,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AppCard(
              color: AppColors.white.withValues(alpha: 0.82),
              radius: 28,
              shadow: AppShadows.softCard,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      pet == null
                          ? const _UnknownPetAvatar(size: 48)
                          : _PetAvatar(pet: pet, size: 48),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet?.name ?? 'Thú cưng chưa khả dụng',
                              style: AppTextStyles.bodyStrong,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              categoryMeta.label,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ReminderStatusBadge(status: reminder.status),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(reminder.title, style: AppTextStyles.title),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppChip(
                        label: '${reminder.dateLabel} • ${reminder.timeLabel}',
                        icon: Icons.schedule,
                        color: AppColors.fieldWarm,
                      ),
                      AppChip(
                        label: reminder.repeatLabel,
                        icon: Icons.repeat,
                        color: AppColors.fieldCool,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReminderEmptyCard extends StatelessWidget {
  const ReminderEmptyCard({required this.onAddReminder, super.key});

  final VoidCallback onAddReminder;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 32,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(34),
            ),
            child: const AppAssetImage(
              assetPath: AppImages.remindersSupport,
              borderRadius: BorderRadius.all(Radius.circular(34)),
            ),
          ),
          const SizedBox(height: 20),
          EmptyState(
            title: context.l10n.reminderWidgetAddFirst,
            message: context.l10n.reminderWidgetKeepReady,
            icon: Icons.favorite_border,
            actionLabel: context.l10n.reminderAddBtn,
            onActionPressed: onAddReminder,
          ),
        ],
      ),
    );
  }
}

class ReminderFormCard extends StatelessWidget {
  const ReminderFormCard({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 28,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class ReminderSelectorField extends StatelessWidget {
  const ReminderSelectorField({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.accent = AppColors.teal,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.charcoal),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.fieldWarm,
            borderRadius: AppRadius.mdBorder,
          ),
          child: Row(
            children: [
              Icon(icon, color: accent, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(value, style: AppTextStyles.bodyStrong)),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.muted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReminderNotificationTile extends StatelessWidget {
  const ReminderNotificationTile({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white.withValues(alpha: 0.78),
      radius: 24,
      shadow: AppShadows.softCard,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.14),
              borderRadius: AppRadius.mdBorder,
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: AppColors.teal,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.reminderWidgetSend,
                  style: AppTextStyles.bodyStrong,
                ),
                SizedBox(height: 2),
                Text(
                  context.l10n.reminderWidgetPlaceholder,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.white,
            activeTrackColor: AppColors.coral,
          ),
        ],
      ),
    );
  }
}

class ReminderChoiceWrap<T> extends StatelessWidget {
  const ReminderChoiceWrap({
    required this.items,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    super.key,
  });

  final List<T> items;
  final T selected;
  final String Function(T item) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          AppChip(
            label: labelOf(item),
            selected: item == selected,
            onTap: () => onSelected(item),
          ),
      ],
    );
  }
}

class ReminderStatusBadge extends StatelessWidget {
  const ReminderStatusBadge({required this.status, super.key});

  final ReminderStatus status;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, label) = switch (status) {
      ReminderStatus.upcoming => (
        AppColors.fieldCool,
        AppColors.teal,
        context.l10n.remindersStatusUpcoming,
      ),
      ReminderStatus.dueSoon => (
        AppColors.lostSoft,
        AppColors.coral,
        context.l10n.remindersStatusDueSoon,
      ),
      ReminderStatus.completed => (
        AppColors.successSoft,
        AppColors.green,
        context.l10n.remindersStatusCompleted,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.pillBorder,
      ),
      child: Text(label, style: AppTextStyles.chip.copyWith(color: foreground)),
    );
  }
}

class ReminderCategoryMeta {
  const ReminderCategoryMeta({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

ReminderCategoryMeta reminderCategoryMeta(
  BuildContext context,
  ReminderCategory category,
) {
  return switch (category) {
    ReminderCategory.vaccination => ReminderCategoryMeta(
      label: context.l10n.reminderTypeVaccination,
      icon: Icons.vaccines_outlined,
      color: AppColors.coral,
    ),
    ReminderCategory.deworming => ReminderCategoryMeta(
      label: context.l10n.reminderTypeDeworming,
      icon: Icons.health_and_safety_outlined,
      color: AppColors.teal,
    ),
    ReminderCategory.grooming => ReminderCategoryMeta(
      label: context.l10n.reminderTypeGrooming,
      icon: Icons.content_cut_rounded,
      color: AppColors.green,
    ),
    ReminderCategory.vetVisit => ReminderCategoryMeta(
      label: context.l10n.reminderTypeVetVisit,
      icon: Icons.local_hospital_outlined,
      color: AppColors.coralDark,
    ),
    ReminderCategory.medication => ReminderCategoryMeta(
      label: context.l10n.reminderTypeMedication,
      icon: Icons.medication_outlined,
      color: AppColors.charcoal,
    ),
  };
}

String reminderBucketLabel(BuildContext context, ReminderBucket bucket) {
  return switch (bucket) {
    ReminderBucket.today => context.l10n.remindersBucketToday,
    ReminderBucket.tomorrow => context.l10n.remindersBucketTomorrow,
    ReminderBucket.thisWeek => context.l10n.remindersBucketThisWeek,
    ReminderBucket.later => context.l10n.remindersBucketLater,
  };
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    required this.title,
    required this.caption,
    required this.color,
    required this.icon,
  });

  final String title;
  final String caption;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white.withValues(alpha: 0.82),
      radius: 24,
      shadow: AppShadows.softCard,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: AppRadius.mdBorder,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.title),
          const SizedBox(height: 2),
          Text(caption, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  const _PetAvatar({required this.pet, required this.size});

  final PetModel pet;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(size * 0.36),
      ),
      child: AppAssetImage(
        assetPath: pet.photoUrl ?? AppImages.petCardFor(pet.type),
        borderRadius: BorderRadius.circular(size * 0.36),
      ),
    );
  }
}

class _UnknownPetAvatar extends StatelessWidget {
  const _UnknownPetAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.fieldWarm,
        borderRadius: BorderRadius.circular(size * 0.36),
      ),
      child: const Icon(Icons.pets, color: AppColors.coral),
    );
  }
}

class _RemindersBackdrop extends StatelessWidget {
  const _RemindersBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -26,
          top: 76,
          child: _Glow(
            width: 170,
            height: 170,
            color: AppColors.teal.withValues(alpha: 0.14),
          ),
        ),
        Positioned(
          left: -40,
          top: 220,
          child: _Glow(
            width: 210,
            height: 210,
            color: AppColors.coral.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          right: 38,
          top: 190,
          child: Icon(
            Icons.pets,
            size: 28,
            color: AppColors.white.withValues(alpha: 0.4),
          ),
        ),
        Positioned(
          left: 42,
          bottom: 170,
          child: Icon(
            Icons.favorite,
            size: 18,
            color: AppColors.teal.withValues(alpha: 0.22),
          ),
        ),
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.width, required this.height, required this.color});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
