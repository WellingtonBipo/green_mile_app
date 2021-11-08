class Failure implements Exception {
  final String message;
  Failure(this.message);
}

class HttpBadRequest extends Failure {
  final int statusCode;
  HttpBadRequest(
    String message,
    this.statusCode,
  ) : super(message);
}

class HttpFailure extends Failure {
  HttpFailure([String? message]) : super(message ?? 'Erro na conexão');
}
