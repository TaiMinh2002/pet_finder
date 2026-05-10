import '../domain/chat_model.dart';

/// Mock chat repository
class ChatRepository {
  static ChatRepository? _instance;
  static ChatRepository get instance => _instance ??= ChatRepository._();
  ChatRepository._();

  final List<ChatConversation> _conversations = [];
  final Map<String, List<ChatMessage>> _messages = {};

  /// Get user conversations
  Future<List<ChatConversation>> getConversations(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock conversations
    if (_conversations.isEmpty) {
      _conversations.addAll([
        ChatConversation(
          id: 'chat_1',
          participantIds: [userId, 'user_2'],
          participantNames: ['Bạn', 'Nguyễn Văn A'],
          lastMessage: 'Tôi đã thấy chó của bạn gần công viên',
          lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
          unreadCount: 2,
          reportId: 'report_1',
        ),
        ChatConversation(
          id: 'chat_2',
          participantIds: [userId, 'user_3'],
          participantNames: ['Bạn', 'Trần Thị B'],
          lastMessage: 'Cảm ơn bạn đã thông tin',
          lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
          unreadCount: 0,
          reportId: 'report_2',
        ),
      ]);
    }
    
    return _conversations.where((conv) => conv.participantIds.contains(userId)).toList();
  }

  /// Get messages for conversation
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!_messages.containsKey(conversationId)) {
      // Mock messages
      _messages[conversationId] = [
        ChatMessage(
          id: 'msg_1',
          conversationId: conversationId,
          senderId: 'user_2',
          senderName: 'Nguyễn Văn A',
          content: 'Xin chào, tôi đã thấy chó của bạn',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          messageType: MessageType.text,
        ),
        ChatMessage(
          id: 'msg_2',
          conversationId: conversationId,
          senderId: 'current_user_id',
          senderName: 'Bạn',
          content: 'Thật sao? Ở đâu vậy?',
          timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
          messageType: MessageType.text,
        ),
        ChatMessage(
          id: 'msg_3',
          conversationId: conversationId,
          senderId: 'user_2',
          senderName: 'Nguyễn Văn A',
          content: 'Gần công viên Hoàng Hoa Thám',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          messageType: MessageType.text,
        ),
      ];
    }
    
    return _messages[conversationId] ?? [];
  }

  /// Send message
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String content,
    MessageType messageType = MessageType.text,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final message = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      timestamp: DateTime.now(),
      messageType: messageType,
    );

    if (!_messages.containsKey(conversationId)) {
      _messages[conversationId] = [];
    }
    
    _messages[conversationId]!.add(message);
    
    // Update conversation last message
    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      _conversations[convIndex] = _conversations[convIndex].copyWith(
        lastMessage: content,
        lastMessageTime: message.timestamp,
      );
    }
    
    return message;
  }

  /// Start new conversation
  Future<ChatConversation> startConversation({
    required String userId,
    required String otherUserId,
    required String otherUserName,
    String? reportId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final conversation = ChatConversation(
      id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      participantIds: [userId, otherUserId],
      participantNames: ['Bạn', otherUserName],
      lastMessage: '',
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
      reportId: reportId,
    );
    
    _conversations.insert(0, conversation);
    return conversation;
  }

  /// Mark conversation as read
  Future<void> markAsRead(String conversationId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
    }
  }
}