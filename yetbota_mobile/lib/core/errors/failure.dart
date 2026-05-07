sealed class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.code});
  final String? code;
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
