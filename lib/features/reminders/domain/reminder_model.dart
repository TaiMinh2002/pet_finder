enum ReminderCategory { vaccination, deworming, grooming, vetVisit, medication }

enum ReminderBucket { today, tomorrow, thisWeek, later }

enum ReminderStatus { upcoming, dueSoon, completed }

class ReminderModel {
  const ReminderModel({
    required this.id,
    required this.petId,
    required this.title,
    required this.category,
    required this.bucket,
    required this.dateLabel,
    required this.timeLabel,
    required this.repeatLabel,
    required this.notes,
    required this.notificationsEnabled,
    required this.status,
  });

  final String id;
  final String petId;
  final String title;
  final ReminderCategory category;
  final ReminderBucket bucket;
  final String dateLabel;
  final String timeLabel;
  final String repeatLabel;
  final String notes;
  final bool notificationsEnabled;
  final ReminderStatus status;
}
