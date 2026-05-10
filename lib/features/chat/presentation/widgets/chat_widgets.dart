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
import '../../../../core/widgets/status_badge.dart';
import '../../../mock/mock_data.dart';
import '../../../pets/domain/pet_model.dart';
import '../../../reports/domain/pet_report_model.dart';
import '../../domain/chat_model.dart';

class ChatScaffold extends StatelessWidget {
  const ChatScaffold({required this.child, super.key, this.bottomNav = true});

  final Widget child;
  final bool bottomNav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const _ChatBackdrop(),
              child,
              if (bottomNav)
                const Positioned(
                  left: 18,
                  right: 18,
                  bottom: 22,
                  child: ChatBottomNavigation(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBottomNavigation extends StatelessWidget {
  const ChatBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      AppBottomNavItem(
        icon: Icons.home_rounded,
        label: context.l10n.commonHome,
      ),
      AppBottomNavItem(
        icon: Icons.chat_bubble_outline,
        label: context.l10n.commonMessages,
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
              context.goNamed(AppRoute.chatList.name);
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
            onTap: () => context.goNamed(AppRoute.chatList.name),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.coral,
                shape: BoxShape.circle,
                boxShadow: AppShadows.primaryButton,
                border: Border.all(color: AppColors.white, width: 4),
              ),
              child: const Icon(
                Icons.chat_bubble_rounded,
                color: AppColors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChatHeader extends StatelessWidget {
  const ChatHeader({
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

class ChatHeroCard extends StatelessWidget {
  const ChatHeroCard({super.key});

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
                Text(context.l10n.chatHeroTitle, style: AppTextStyles.title),
                SizedBox(height: 8),
                Text(context.l10n.chatHeroBody, style: AppTextStyles.body),
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
              assetPath: AppImages.chatHero,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatConversationTile extends StatelessWidget {
  const ChatConversationTile({required this.chat, super.key});

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    final pet = _resolvePet(chat.petId);
    final statusType = switch (chat.reportStatus) {
      PetReportStatus.resolved ||
      PetReportStatus.closed => StatusBadgeType.reunited,
      PetReportStatus.active ||
      PetReportStatus.possibleMatch ||
      PetReportStatus.reported => StatusBadgeType.active,
    };

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () => context.goNamed(
        AppRoute.chatDetail.name,
        pathParameters: {'chatId': chat.id},
      ),
      child: AppCard(
        color: AppColors.white.withValues(alpha: 0.82),
        radius: 28,
        shadow: AppShadows.softCard,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ChatAvatar(pet: pet, role: chat.role, size: 56),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.contactName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyStrong,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        chat.timeLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.reportTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    chat.lastMessage,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      StatusBadge(
                        label: switch (chat.reportStatus) {
                          PetReportStatus.resolved || PetReportStatus.closed =>
                            context.l10n.chatStatusResolved,
                          PetReportStatus.active =>
                            context.l10n.chatStatusActive,
                          PetReportStatus.possibleMatch =>
                            context.l10n.chatStatusPossibleMatch,
                          PetReportStatus.reported =>
                            context.l10n.chatStatusReported,
                        },
                        type: statusType,
                      ),
                      const SizedBox(width: 8),
                      AppChip(
                        label: _roleLabel(context, chat.role),
                        color: AppColors.fieldCool,
                      ),
                      const Spacer(),
                      if (chat.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.coral,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(999),
                            ),
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: AppTextStyles.chip.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatEmptyCard extends StatelessWidget {
  const ChatEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 32,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(22),
      child: EmptyState(
        title: context.l10n.chatListEmptyTitle,
        message: context.l10n.chatEmptyMessage,
        icon: Icons.chat_bubble_outline_rounded,
      ),
    );
  }
}

class ChatDetailHeaderCard extends StatelessWidget {
  const ChatDetailHeaderCard({
    required this.chat,
    required this.onOpenActions,
    super.key,
  });

  final ChatModel chat;
  final VoidCallback onOpenActions;

  @override
  Widget build(BuildContext context) {
    final pet = _resolvePet(chat.petId);

    return AppCard(
      color: AppColors.glass,
      radius: 28,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ChatAvatar(pet: pet, role: chat.role, size: 54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat.contactName, style: AppTextStyles.title),
                const SizedBox(height: 4),
                Text(
                  '${chat.petName} • ${chat.reportTitle}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppChip(
                      label: _roleLabel(context, chat.role),
                      color: AppColors.fieldCool,
                    ),
                    AppChip(
                      label: context.l10n.chatDistanceAway('1.2'),
                      icon: Icons.place_outlined,
                      color: AppColors.fieldWarm,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              CircleGlassButton(
                icon: Icons.call_outlined,
                onTap: onOpenActions,
              ),
              const SizedBox(height: 8),
              CircleGlassButton(
                icon: Icons.more_horiz_rounded,
                onTap: onOpenActions,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuickActionStrip extends StatelessWidget {
  const QuickActionStrip({
    required this.onShareLocation,
    required this.onSendPhoto,
    required this.onCall,
    required this.onViewReport,
    super.key,
  });

  final VoidCallback onShareLocation;
  final VoidCallback onSendPhoto;
  final VoidCallback onCall;
  final VoidCallback onViewReport;

  @override
  Widget build(BuildContext context) {
    final actions = <({String label, IconData icon, Color color})>[
      (
        label: context.l10n.chatShareLocation,
        icon: Icons.place_outlined,
        color: AppColors.teal,
      ),
      (
        label: context.l10n.chatSendPhoto,
        icon: Icons.image_outlined,
        color: AppColors.coral,
      ),
      (
        label: context.l10n.chatCall,
        icon: Icons.call_outlined,
        color: AppColors.green,
      ),
      (
        label: context.l10n.chatViewReport,
        icon: Icons.visibility_outlined,
        color: AppColors.coralDark,
      ),
    ];

    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final action = actions[index];
          final callback = switch (index) {
            0 => onShareLocation,
            1 => onSendPhoto,
            2 => onCall,
            _ => onViewReport,
          };
          return InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: callback,
            child: AppCard(
              color: AppColors.white.withValues(alpha: 0.8),
              radius: 24,
              shadow: AppShadows.softCard,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: action.color.withValues(alpha: 0.14),
                        borderRadius: AppRadius.mdBorder,
                      ),
                      child: Icon(action.icon, color: action.color),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      action.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.charcoal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.message, super.key});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    final background = message.isMine ? AppColors.coral : AppColors.white;
    final foreground = message.isMine ? AppColors.white : AppColors.charcoal;
    final alignment = message.isMine
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 290),
          padding: EdgeInsets.all(
            message.type == ChatMessageType.image ? 10 : 14,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(24),
              topRight: const Radius.circular(24),
              bottomLeft: Radius.circular(message.isMine ? 24 : 8),
              bottomRight: Radius.circular(message.isMine ? 8 : 24),
            ),
            boxShadow: AppShadows.softCard,
          ),
          child: message.type == ChatMessageType.image
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 148,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: AppAssetImage(
                          assetPath: AppImages.chatContact,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message.text,
                      style: AppTextStyles.body.copyWith(color: foreground),
                    ),
                  ],
                )
              : Text(
                  message.text,
                  style: AppTextStyles.body.copyWith(color: foreground),
                ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            message.timeLabel,
            style: AppTextStyles.caption.copyWith(color: AppColors.muted),
          ),
        ),
      ],
    );
  }
}

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({
    required this.pet,
    required this.role,
    required this.size,
    super.key,
  });

  final PetModel pet;
  final ChatParticipantRole role;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(size * 0.34),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppAssetImage(
            assetPath: pet.photoUrl ?? AppImages.petCardFor(pet.type),
            borderRadius: BorderRadius.circular(size * 0.34),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              width: size * 0.24,
              height: size * 0.24,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                switch (role) {
                  ChatParticipantRole.owner => Icons.person,
                  ChatParticipantRole.reporter => Icons.flag_outlined,
                  ChatParticipantRole.helper => Icons.favorite_outline,
                },
                size: size * 0.14,
                color: AppColors.coral,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

PetModel _resolvePet(String petId) {
  return MockData.pets.firstWhere(
    (item) => item.id == petId,
    orElse: () => MockData.pets.first,
  );
}

String _roleLabel(BuildContext context, ChatParticipantRole role) {
  return switch (role) {
    ChatParticipantRole.owner => context.l10n.chatRoleOwner,
    ChatParticipantRole.reporter => context.l10n.chatRoleReporter,
    ChatParticipantRole.helper => context.l10n.chatRoleHelper,
  };
}

class _ChatBackdrop extends StatelessWidget {
  const _ChatBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -20,
          top: 82,
          child: _Glow(
            width: 180,
            height: 180,
            color: AppColors.teal.withValues(alpha: 0.14),
          ),
        ),
        Positioned(
          left: -36,
          top: 240,
          child: _Glow(
            width: 210,
            height: 210,
            color: AppColors.coral.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          right: 42,
          top: 210,
          child: Icon(
            Icons.pets,
            size: 26,
            color: AppColors.white.withValues(alpha: 0.42),
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
