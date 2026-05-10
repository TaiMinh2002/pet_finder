import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_state.dart';

/// Base cubit with common functionality
abstract class BaseCubit<T extends BaseState> extends Cubit<T> {
  BaseCubit(super.initialState);

  /// Emit loading state
  void emitLoading() {
    if (state is! LoadingState) {
      emit(const LoadingState() as T);
    }
  }

  /// Emit error state with message
  void emitError(String message, [Object? details]) {
    emit(ErrorState(message, details) as T);
  }

  /// Emit success state
  void emitSuccess() {
    emit(const SuccessState() as T);
  }

  /// Safe emit that checks if cubit is not closed
  void safeEmit(T state) {
    if (!isClosed) {
      emit(state);
    }
  }

  /// Execute async operation with error handling
  Future<void> executeAsync<R>(
    Future<R> Function() operation, {
    void Function(R result)? onSuccess,
    void Function(String error)? onError,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) emitLoading();
      
      final result = await operation();
      
      if (onSuccess != null) {
        onSuccess(result);
      } else {
        emitSuccess();
      }
    } catch (error) {
      final errorMessage = error.toString();
      if (onError != null) {
        onError(errorMessage);
      } else {
        emitError(errorMessage, error);
      }
    }
  }
}