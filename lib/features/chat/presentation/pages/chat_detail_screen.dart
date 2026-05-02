import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_status_views.dart';
import '../../../mock/mock_data.dart';
import '../../domain/chat_model.dart';
import '../widgets/chat_interaction_widgets.dart';
import '../widgets/chat_widgets.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({required this.chatId, super.key});

  final String chatId;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late final TextEditingController _composerController;
  late ChatModel? _chat;
  late List<ChatMessageModel> _messages;
  var _isSending = false;

  @override
  void initState() {
    super.initState();
    _chat = MockData.tryResolveChat(widget.chatId);
    _messages = List<ChatMessageModel>.from(_chat?.messages ?? const []);
    _composerController = TextEditingController();
  }

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  void _openActions() {
    final chat = _chat;
    if (chat == null) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => ContactQuickActionSheet(
        chat: chat,
        onOpenChat: () {
          sheetContext.safeClose();
          showPetSnackBar(
            context,
            context.l10n.chatAlreadyInThread,
            icon: Icons.chat_bubble_outline,
            backgroundColor: AppColors.teal,
          );
        },
        onViewReport: () {
          sheetContext.safeClose();
          context.goNamed(
            AppRoute.reportDetail.name,
            pathParameters: {'reportId': chat.reportId},
          );
        },
      ),
    );
  }

  Future<void> _sendMessage() async {
    final chat = _chat;
    final text = _composerController.text.trim();
    if (_isSending || text.isEmpty || chat == null) return;
    setState(() => _isSending = true);
    await Future<void>.delayed(const Duration(milliseconds: 240));
    if (!mounted) return;
    setState(() {
      _messages = [
        ..._messages,
        ChatMessageModel(
          id: 'local_${DateTime.now().millisecondsSinceEpoch}',
          text: text,
          timeLabel: 'Just now',
          isMine: true,
        ),
      ];
      _composerController.clear();
      _isSending = false;
    });
    showPetSnackBar(
      context,
      context.l10n.chatMessageSentTo(chat.contactName),
      icon: Icons.send_rounded,
      backgroundColor: AppColors.coral,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chat = _chat;
    if (chat == null) {
      return ChatScaffold(
        bottomNav: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenNarrow,
            18,
            AppSpacing.screenNarrow,
            40,
          ),
          child: AppErrorState(
            title: context.l10n.chatConversationUnavailableTitle,
            message: context.l10n.chatConversationUnavailableDesc,
            retryLabel: context.l10n.chatBackToMessages,
            onRetry: () => context.goNamed(AppRoute.chatList.name),
          ),
        ),
      );
    }

    return ChatScaffold(
      bottomNav: false,
      child: Stack(
        children: [
          CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenNarrow,
                  18,
                  AppSpacing.screenNarrow,
                  148,
                ),
                sliver: SliverList.list(
                  children: [
                    ChatHeader(
                      title: context.l10n.chatConversationTitle,
                      subtitle: context.l10n.chatConversationSubtitle,
                      leading: CircleGlassButton(
                        icon: Icons.arrow_back,
                        onTap: () => context.safeBackNamed(AppRoute.chatList),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ChatDetailHeaderCard(
                      chat: chat,
                      onOpenActions: _openActions,
                    ),
                    const SizedBox(height: 14),
                    QuickActionStrip(
                      onShareLocation: () => showPetSnackBar(
                        context,
                        context.l10n.chatShareLocationReady,
                        icon: Icons.place_outlined,
                        backgroundColor: AppColors.teal,
                      ),
                      onSendPhoto: () => showPetSnackBar(
                        context,
                        context.l10n.chatPhotoPickerLater,
                        icon: Icons.image_outlined,
                        backgroundColor: AppColors.coral,
                      ),
                      onCall: _openActions,
                      onViewReport: () => context.goNamed(
                        AppRoute.reportDetail.name,
                        pathParameters: {'reportId': chat.reportId},
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (final message in _messages) ...[
                      Align(
                        alignment: message.isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: MessageBubble(message: message),
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
            bottom: 28 + MediaQuery.viewInsetsOf(context).bottom,
            child: ChatComposer(
              controller: _composerController,
              isSending: _isSending,
              onSend: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
