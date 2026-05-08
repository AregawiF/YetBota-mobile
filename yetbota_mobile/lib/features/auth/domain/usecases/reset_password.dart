import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';

class ResetPassword {
  const ResetPassword(this._repo);
  final AuthRepository _repo;

  Future<Result<void>> call({
    required String mobile,
    required String password,
    required String random,
  }) {
    return _repo.resetPassword(
      mobile: mobile,
      password: password,
      random: random,
    );
  }
}
