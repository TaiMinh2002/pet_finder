import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../domain/chat_model.dart';
import '../bloc/chat_cubit.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ChatError) {
          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.chatTitle)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.coral),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ChatCubit>().loadConversations(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final conversations = state is ConversationsLoaded
            ? state.conversations
            : <ChatConversation>[];
        final sortedConversations = [...conversations]
          ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.chatTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () {
                  // TODO: Implement search
                },
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.screenNarrow),
                sliver: SliverList.list(
                  children: [
                    const _ConversationSearchCard(),
                    const SizedBox(height: 22),
                    if (sortedConversations.isEmpty)
                      const _ChatEmptyCard()
                    else
                      for (
                        var index = 0;
                        index < sortedConversations.length;
                        index++
                      ) ...[
                        _ChatConversationTile(
                          conversation: sortedConversations[index],
                        ),
                        if (index != sortedConversations.length - 1)
                          const SizedBox(height: 12),
                      ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ConversationSearchCard extends StatelessWidget {
  const _ConversationSearchCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: AppTextStyles.bodyStrong,
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.muted,
                ),
                filled: true,
                fillColor: AppColors.fieldWarm,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
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
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.tune_rounded, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

class _ChatEmptyCard extends StatelessWidget {
  const _ChatEmptyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.muted),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: AppTextStyles.headingMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation by responding to a pet report or contacting someone who found your pet.',
            style: AppTextStyles.body.copyWith(color: AppColors.muted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ChatConversationTile extends StatelessWidget {
  const _ChatConversationTile({required this.conversation});

  final ChatConversation conversation;

  @override
  Widget build(BuildContext context) {
    final otherUserName = conversation.participantNames.firstWhere(
      (name) => name != 'Bạn',
      orElse: () => 'Unknown',
    );

    return GestureDetector(
      onTap: () {
        context.goNamed(
          AppRoute.chatDetail.name,
          pathParameters: {'chatId': conversation.id},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.sky,
              child: Text(
                otherUserName[0].toUpperCase(),
                style: TextStyle(
                  color: AppColors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          otherUserName,
                          style: AppTextStyles.bodyStrong,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.coral,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.lastMessage.isEmpty
                        ? 'No messages yet'
                        : conversation.lastMessage,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.muted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(conversation.lastMessageTime),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${(difference.inDays / 7).floor()}w';
    }
  }
}
