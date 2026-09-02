// Esta classe genérica cobrirá todos os estados exigidos nos requisitos.
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
  final bool invalidData; // Para "dados inválidos"
  StateError(this.message, {this.invalidData = false});
}

class StateComplete<T>
    extends AppState<T> {} // Operação concluída sem retorno de dados
