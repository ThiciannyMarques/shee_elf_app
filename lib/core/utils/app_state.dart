sealed class AppState<T> {}

class StateInitial<T> extends AppState<T> {}

class StateLoading<T> extends AppState<T> {}

class StateEmpty<T> extends AppState<T> {}

class StateSuccess<T> extends AppState<T> {
  final T data;
  StateSuccess(this.data);
}

class StateError<T> extends AppState<T> {
  final String message;
  StateError(this.message);
}

class StateComplete<T> extends AppState<T> {}
