import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';

class Register {
  const Register(this._repo);
  final AuthRepository _repo;

  Future<Result<AuthSession>> call({
    required String firstName,
    required String lastName,
    required String username,
    required String mobile,
    required String password,
    required String random,
  }) {
    return _repo.registerAndSignIn(
      firstName: firstName,
      lastName: lastName,
      username: username,
      mobile: mobile,
      password: password,
      random: random,
    );
  }
}
