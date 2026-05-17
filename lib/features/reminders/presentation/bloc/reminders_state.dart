import '../../../../core/bloc/bloc_exports.dart';
import '../../domain/reminder_model.dart';

abstract class RemindersState extends BaseState {
  const RemindersState();
}

class RemindersInitial extends RemindersState {
  const RemindersInitial();
}

class RemindersLoading extends RemindersState {
  const RemindersLoading();
}

class RemindersLoaded extends RemindersState {
  const RemindersLoaded(this.reminders);

  final List<ReminderModel> reminders;
}

class RemindersEmpty extends RemindersState {
  const RemindersEmpty();
}

class RemindersError extends RemindersState {
  const RemindersError(this.message);

  final String message;
}
