import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/reminder_model.dart';

class RemindersRepository {
  RemindersRepository({FirebaseFirestore? firestore}) : _firestore = firestore;

  static RemindersRepository? _instance;
  static RemindersRepository get instance =>
      _instance ??= RemindersRepository();

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _resolvedFirestore =>
      _firestore ?? FirebaseFirestore.instance;

  Future<List<ReminderModel>> getUserReminders(String userId) async {
    final snapshot = await _resolvedFirestore
        .collection('reminders')
        .where('userId', isEqualTo: userId)
        .orderBy('dueAt')
        .get();

    return snapshot.docs
        .map((document) => ReminderModel.fromJson(document.id, document.data()))
        .toList();
  }
}
