import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../mock/mock_data.dart';
import '../../domain/notification_model.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = MockData.notifications;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const _NotificationsBackdrop(),
              CustomScrollView(
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
                        Row(
                          children: [
                            _CircleButton(
                              icon: Icons.arrow_back,
                              onTap: () => context.safeBackNamed(AppRoute.home),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.notiTitle,
                                    style: AppTextStyles.heroTitle.copyWith(
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.l10n.notiSubtitle,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        if (notifications.isEmpty)
                          AppCard(
                            radius: 30,
                            color: AppColors.glass,
                            shadow: AppShadows.raisedCard,
                            padding: EdgeInsets.all(22),
                            child: EmptyState(
                              title: context.l10n.notiEmptyTitle,
                              message: context.l10n.notiEmptyDesc,
                              icon: Icons.notifications_none,
                            ),
                          )
                        else
                          for (
                            var index = 0;
                            index < notifications.length;
                            index++
                          ) ...[
                            _NotificationCard(
                              notification: notifications[index],
                            ),
                            if (index != notifications.length - 1)
                              const SizedBox(height: 12),
                          ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final title = _localizedTitle(context, notification);
    final message = _localizedMessage(context, notification);
    final timeLabel = _localizedTime(context, notification);
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () {
        final reminderId = notification.reminderId;
        if (reminderId != null && reminderId.isNotEmpty) {
          context.goNamed(
            AppRoute.remindersDetail.name,
            pathParameters: {'reminderId': reminderId},
          );
          return;
        }
        final chatId = notification.chatId;
        if (chatId != null && chatId.isNotEmpty) {
          context.goNamed(
            AppRoute.chatDetail.name,
            pathParameters: {'chatId': chatId},
          );
          return;
        }
        final reportId = notification.reportId;
        if (reportId != null && reportId.isNotEmpty) {
          context.goNamed(
            AppRoute.reportDetail.name,
            pathParameters: {'reportId': reportId},
          );
        }
      },
      child: AppCard(
        radius: 28,
        color: notification.isRead
            ? AppColors.white.withValues(alpha: 0.8)
            : AppColors.glass,
        shadow: AppShadows.softCard,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: notification.isRead
                    ? AppColors.fieldCool
                    : AppColors.lostSoft,
                borderRadius: AppRadius.mdBorder,
              ),
              child: Icon(
                notification.isRead
                    ? Icons.notifications_active_outlined
                    : Icons.campaign_outlined,
                color: notification.isRead ? AppColors.teal : AppColors.coral,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title, style: AppTextStyles.bodyStrong),
                      ),
                      const SizedBox(width: 10),
                      Text(timeLabel, style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(message, style: AppTextStyles.body),
                  if (!notification.isRead) ...[
                    const SizedBox(height: 10),
                    Text(
                      context.l10n.notiOpenReport,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.coralDark,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _localizedTitle(BuildContext context, NotificationModel notification) {
  return switch (notification.id) {
    'notification_nearby' => context.l10n.notiMockNearbyTitle,
    'notification_found' => context.l10n.notiMockFoundTitle,
    'notification_reminder' => context.l10n.notiMockReminderTitle,
    _ => notification.title,
  };
}

String _localizedMessage(BuildContext context, NotificationModel notification) {
  return switch (notification.id) {
    'notification_nearby' => context.l10n.notiMockNearbyMessage,
    'notification_found' => context.l10n.notiMockFoundMessage,
    'notification_reminder' => context.l10n.notiMockReminderMessage,
    _ => notification.message,
  };
}

String _localizedTime(BuildContext context, NotificationModel notification) {
  return switch (notification.timeLabel) {
    'Now' => context.l10n.timeNow,
    '18 min ago' => context.l10n.timeMinutesAgo(18),
    '2 hr ago' => context.l10n.timeHoursAgo(2),
    _ => notification.timeLabel,
  };
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

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

class _NotificationsBackdrop extends StatelessWidget {
  const _NotificationsBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -36,
          top: 84,
          child: _Glow(
            color: AppColors.teal.withValues(alpha: 0.16),
            size: 176,
          ),
        ),
        Positioned(
          left: -58,
          top: 244,
          child: _Glow(
            color: AppColors.coral.withValues(alpha: 0.12),
            size: 214,
          ),
        ),
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
