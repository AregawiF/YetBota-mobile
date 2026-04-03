sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

