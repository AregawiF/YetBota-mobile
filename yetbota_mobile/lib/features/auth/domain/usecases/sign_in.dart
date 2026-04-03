import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';

class SignIn {
  const SignIn(this._repo);
  final AuthRepository _repo;

  Future<Result<AuthSession>> call({
    required String email,
    required String password,
  }) {
    return _repo.signIn(email: email, password: password);
  }
}

