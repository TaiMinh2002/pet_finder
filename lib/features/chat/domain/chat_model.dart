import '../../reports/domain/pet_report_model.dart';

enum ChatParticipantRole { owner, reporter, helper }

enum ChatMessageType { text, image }

class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.timeLabel,
    required this.isMine,
    this.type = ChatMessageType.text,
  });

  final String id;
  final String text;
  final String timeLabel;
  final bool isMine;
  final ChatMessageType type;
}

class ChatModel {
  const ChatModel({
    required this.id,
    required this.contactName,
    required this.reportTitle,
    required this.reportId,
    required this.petName,
    required this.petId,
    required this.lastMessage,
    required this.timeLabel,
    required this.unreadCount,
    required this.role,
    required this.reportStatus,
    required this.messages,
  });

  final String id;
  final String contactName;
  final String reportTitle;
  final String reportId;
  final String petName;
  final String petId;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;
  final ChatParticipantRole role;
  final PetReportStatus reportStatus;
  final List<ChatMessageModel> messages;
}
