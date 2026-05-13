/// Base state class for all BLoC states
abstract class BaseState {
  const BaseState();
}

/// Base loading state
class LoadingState extends BaseState {
  const LoadingState();

  @override
  bool operator ==(Object other) => other is LoadingState;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Base error state with message
class ErrorState extends BaseState {
  const ErrorState(this.message, [this.details]);

  final String message;
  final Object? details;

  @override
  bool operator ==(Object other) =>
      other is ErrorState &&
      other.message == message &&
      other.details == details;

  @override
  int get hashCode => Object.hash(message, details);
}

/// Base success state
class SuccessState extends BaseState {
  const SuccessState();

  @override
  bool operator ==(Object other) => other is SuccessState;

  @override
  int get hashCode => runtimeType.hashCode;
}
