import '../../../../core/bloc/bloc_exports.dart';
import '../../data/reminders_repository.dart';
import 'reminders_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit({RemindersRepository? repository})
    : _repository = repository ?? RemindersRepository.instance,
      super(const RemindersInitial());

  final RemindersRepository _repository;
  String? _currentUserId;

  void setUserId(String userId) {
    _currentUserId = userId;
  }

  Future<void> loadUserReminders([String? userId]) async {
    final uid = userId ?? _currentUserId;
    if (uid == null) {
      emit(const RemindersError('Người dùng chưa đăng nhập'));
      return;
    }

    emit(const RemindersLoading());
    try {
      final reminders = await _repository.getUserReminders(uid);
      if (reminders.isEmpty) {
        emit(const RemindersEmpty());
      } else {
        emit(RemindersLoaded(reminders));
      }
    } catch (_) {
      emit(const RemindersError('Không thể tải nhắc lịch. Vui lòng thử lại.'));
    }
  }

  void reset() {
    emit(const RemindersInitial());
  }
}
