import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../mock/mock_data.dart';
import '../widgets/chat_widgets.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [...MockData.chats]
      ..sort((a, b) => b.unreadCount.compareTo(a.unreadCount));

    return ChatScaffold(
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
                ChatHeader(
                  title: context.l10n.chatTitle,
                  subtitle: context.l10n.chatSubtitle,
                  trailing: CircleGlassButton(
                    icon: Icons.search_rounded,
                    onTap: () => context.goNamed(AppRoute.chatList.name),
                  ),
                ),
                const SizedBox(height: 18),
                const ChatHeroCard(),
                const SizedBox(height: 14),
                const _ConversationSearchCard(),
                const SizedBox(height: 22),
                if (chats.isEmpty)
                  const ChatEmptyCard()
                else
                  for (var index = 0; index < chats.length; index++) ...[
                    ChatConversationTile(chat: chats[index]),
                    if (index != chats.length - 1) const SizedBox(height: 12),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationSearchCard extends StatelessWidget {
  const _ConversationSearchCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white.withValues(alpha: 0.84),
      radius: 28,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: AppTextStyles.bodyStrong,
              decoration: InputDecoration(
                hintText: context.l10n.chatSearchHint,
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.muted.withValues(alpha: 0.72),
                ),
                filled: true,
                fillColor: AppColors.fieldWarm,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.mdBorder,
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.coral,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.coral,
              borderRadius: AppRadius.lgBorder,
            ),
            child: const Icon(Icons.tune_rounded, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
