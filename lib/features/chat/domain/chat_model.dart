enum MessageType { text, image, location }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.messageType = MessageType.text,
    this.imageUrl,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final MessageType messageType;
  final String? imageUrl;

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? content,
    DateTime? timestamp,
    MessageType? messageType,
    String? imageUrl,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      messageType: messageType ?? this.messageType,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          conversationId == other.conversationId &&
          senderId == other.senderId &&
          senderName == other.senderName &&
          content == other.content &&
          timestamp == other.timestamp &&
          messageType == other.messageType &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      conversationId.hashCode ^
      senderId.hashCode ^
      senderName.hashCode ^
      content.hashCode ^
      timestamp.hashCode ^
      messageType.hashCode ^
      imageUrl.hashCode;
}

class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.participantIds,
    required this.participantNames,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.reportId,
    this.avatarUrl,
  });

  final String id;
  final List<String> participantIds;
  final List<String> participantNames;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String? reportId;
  final String? avatarUrl;

  ChatConversation copyWith({
    String? id,
    List<String>? participantIds,
    List<String>? participantNames,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    String? reportId,
    String? avatarUrl,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      participantNames: participantNames ?? this.participantNames,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      reportId: reportId ?? this.reportId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConversation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          participantIds == other.participantIds &&
          participantNames == other.participantNames &&
          lastMessage == other.lastMessage &&
          lastMessageTime == other.lastMessageTime &&
          unreadCount == other.unreadCount &&
          reportId == other.reportId &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      participantIds.hashCode ^
      participantNames.hashCode ^
      lastMessage.hashCode ^
      lastMessageTime.hashCode ^
      unreadCount.hashCode ^
      reportId.hashCode ^
      avatarUrl.hashCode;
}
