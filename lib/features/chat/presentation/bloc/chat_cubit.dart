import '../../../../core/bloc/bloc_exports.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat_model.dart';

/// Chat states
abstract class ChatState extends BaseState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ConversationsLoaded extends ChatState {
  const ConversationsLoaded(this.conversations);
  final List<ChatConversation> conversations;
  
  @override
  bool operator ==(Object other) =>
      other is ConversationsLoaded && 
      other.conversations.length == conversations.length;
  
  @override
  int get hashCode => conversations.hashCode;
}

class MessagesLoaded extends ChatState {
  const MessagesLoaded(this.messages, this.conversationId);
  final List<ChatMessage> messages;
  final String conversationId;
  
  @override
  bool operator ==(Object other) =>
      other is MessagesLoaded && 
      other.conversationId == conversationId &&
      other.messages.length == messages.length;
  
  @override
  int get hashCode => Object.hash(messages, conversationId);
}

class MessageSent extends ChatState {
  const MessageSent(this.message);
  final ChatMessage message;
  
  @override
  bool operator ==(Object other) =>
      other is MessageSent && other.message == message;
  
  @override
  int get hashCode => message.hashCode;
}

class ChatError extends ChatState {
  const ChatError(this.message);
  final String message;
  
  @override
  bool operator ==(Object other) =>
      other is ChatError && other.message == message;
  
  @override
  int get hashCode => message.hashCode;
}

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? ChatRepository.instance,
        super(const ChatInitial());

  final ChatRepository _chatRepository;
  String? _currentUserId;

  void setUserId(String userId) {
    _currentUserId = userId;
  }

  Future<void> loadConversations() async {
    final uid = _currentUserId;
    if (uid == null) {
      emit(const ChatError('Người dùng chưa đăng nhập'));
      return;
    }

    emit(const ChatLoading());

    try {
      final conversations = await _chatRepository.getConversations(uid);
      emit(ConversationsLoaded(conversations));
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }

  Future<void> loadMessages(String conversationId) async {
    emit(const ChatLoading());

    try {
      final messages = await _chatRepository.getMessages(conversationId);
      emit(MessagesLoaded(messages, conversationId));
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }

  Future<void> sendMessage({
    required String conversationId,
    required String content,
    MessageType messageType = MessageType.text,
  }) async {
    final uid = _currentUserId;
    if (uid == null) {
      emit(const ChatError('Người dùng chưa đăng nhập'));
      return;
    }

    try {
      final message = await _chatRepository.sendMessage(
        conversationId: conversationId,
        senderId: uid,
        senderName: 'Bạn',
        content: content,
        messageType: messageType,
      );
      
      emit(MessageSent(message));
      
      // Reload messages to show the new message
      loadMessages(conversationId);
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }

  Future<void> startConversation({
    required String otherUserId,
    required String otherUserName,
    String? reportId,
  }) async {
    final uid = _currentUserId;
    if (uid == null) {
      emit(const ChatError('Người dùng chưa đăng nhập'));
      return;
    }

    emit(const ChatLoading());

    try {
      final conversation = await _chatRepository.startConversation(
        userId: uid,
        otherUserId: otherUserId,
        otherUserName: otherUserName,
        reportId: reportId,
      );
      
      // Load messages for the new conversation
      loadMessages(conversation.id);
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }

  Future<void> markAsRead(String conversationId) async {
    final uid = _currentUserId;
    if (uid == null) return;

    try {
      await _chatRepository.markAsRead(conversationId, uid);
    } catch (error) {
      // Silent fail for mark as read
    }
  }
}