import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_status_views.dart';
import '../../domain/chat_model.dart';
import '../bloc/chat_cubit.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({required this.chatId, super.key});

  final String chatId;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late final TextEditingController _composerController;
  List<ChatMessage> _messages = [];
  var _isSending = false;

  @override
  void initState() {
    super.initState();
    _composerController = TextEditingController();
    context.read<ChatCubit>().loadMessages(widget.chatId);
  }

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  void _openActions() {
    // Temporary placeholder - will be implemented when we have conversation details
    showPetSnackBar(
      context,
      'Actions will be available soon',
      icon: Icons.more_vert,
      backgroundColor: AppColors.teal,
    );
  }

  Future<void> _sendMessage() async {
    final text = _composerController.text.trim();
    if (_isSending || text.isEmpty) return;

    setState(() => _isSending = true);

    try {
      await context.read<ChatCubit>().sendMessage(
        conversationId: widget.chatId,
        content: text,
      );
      _composerController.clear();
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is MessagesLoaded && state.conversationId == widget.chatId) {
          setState(() {
            _messages = state.messages;
          });
        } else if (state is MessageSent) {
          showPetSnackBar(
            context,
            'Message sent successfully',
            icon: Icons.send_rounded,
            backgroundColor: AppColors.coral,
          );
        } else if (state is ChatError) {
          showPetSnackBar(
            context,
            state.message,
            icon: Icons.error_outline,
            backgroundColor: AppColors.coral,
          );
        }
      },
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ChatError) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenNarrow),
                child: AppErrorState(
                  title: 'Chat Unavailable',
                  message: state.message,
                  retryLabel: 'Back to Messages',
                  onRetry: () => context.goNamed(AppRoute.chatList.name),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Chat'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.goNamed(AppRoute.chatList.name),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: _openActions,
                ),
              ],
            ),
            body: Stack(
              children: [
                CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenNarrow,
                        18,
                        AppSpacing.screenNarrow,
                        100,
                      ),
                      sliver: SliverList.list(
                        children: [
                          for (final message in _messages) ...[
                            Align(
                              alignment: message.senderId == 'current_user_id'
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: _MessageBubble(message: message),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: AppSpacing.screenNarrow,
                  right: AppSpacing.screenNarrow,
                  bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
                  child: _ChatComposer(
                    controller: _composerController,
                    isSending: _isSending,
                    onSend: _sendMessage,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == 'current_user_id';

    return Container(
      margin: EdgeInsets.only(left: isMe ? 50 : 0, right: isMe ? 0 : 50),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? AppColors.teal : AppColors.glass,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: TextStyle(color: isMe ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTime(message.timestamp),
            style: TextStyle(
              color: isMe ? Colors.white70 : Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            onPressed: isSending ? null : onSend,
            icon: isSending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            color: AppColors.teal,
          ),
        ],
      ),
    );
  }
}
