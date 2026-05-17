import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
    this.dueAt,
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
  final DateTime? dueAt;

  factory ReminderModel.fromJson(String id, Map<String, dynamic> json) {
    final dueAt = _parseDate(json['dueAt']);
    return ReminderModel(
      id: id,
      petId: (json['petId'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      category: _parseCategory(json['type']),
      bucket: _bucketFor(dueAt),
      dateLabel: dueAt == null ? '' : DateFormat('dd/MM/yyyy').format(dueAt),
      timeLabel: dueAt == null ? '' : DateFormat('HH:mm').format(dueAt),
      repeatLabel: _repeatLabel(json['repeatType']),
      notes: (json['notes'] as String?) ?? '',
      notificationsEnabled: (json['notificationsEnabled'] as bool?) ?? true,
      status: _statusFor(json['isDone'], dueAt),
      dueAt: dueAt,
    );
  }

  static ReminderCategory _parseCategory(Object? value) {
    return switch (value) {
      'deworming' => ReminderCategory.deworming,
      'grooming' => ReminderCategory.grooming,
      'vet_visit' || 'vetVisit' => ReminderCategory.vetVisit,
      'medication' => ReminderCategory.medication,
      _ => ReminderCategory.vaccination,
    };
  }

  static ReminderBucket _bucketFor(DateTime? dueAt) {
    if (dueAt == null) return ReminderBucket.later;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueAt.year, dueAt.month, dueAt.day);
    final difference = dueDay.difference(today).inDays;

    if (difference <= 0) return ReminderBucket.today;
    if (difference == 1) return ReminderBucket.tomorrow;
    if (difference <= 7) return ReminderBucket.thisWeek;
    return ReminderBucket.later;
  }

  static ReminderStatus _statusFor(Object? isDone, DateTime? dueAt) {
    if (isDone == true) return ReminderStatus.completed;
    if (dueAt == null) return ReminderStatus.upcoming;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueAt.year, dueAt.month, dueAt.day);
    return dueDay.isAfter(today)
        ? ReminderStatus.upcoming
        : ReminderStatus.dueSoon;
  }

  static String _repeatLabel(Object? value) {
    return switch (value) {
      'daily' => 'Daily',
      'weekly' => 'Weekly',
      'monthly' => 'Monthly',
      'yearly' => 'Yearly',
      final String label when label.trim().isNotEmpty => label,
      _ => 'One time',
    };
  }

  static DateTime? _parseDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
