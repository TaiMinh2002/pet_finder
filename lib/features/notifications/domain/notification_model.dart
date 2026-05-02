class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timeLabel,
    required this.isRead,
    this.reportId,
    this.chatId,
    this.reminderId,
  });

  final String id;
  final String title;
  final String message;
  final String timeLabel;
  final bool isRead;
  final String? reportId;
  final String? chatId;
  final String? reminderId;
}
