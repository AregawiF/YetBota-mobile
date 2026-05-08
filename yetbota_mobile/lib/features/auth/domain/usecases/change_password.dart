import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';

class ChangePassword {
  const ChangePassword(this._repo);

  final AuthRepository _repo;

  Future<Result<void>> call({
    required String currentPassword,
    required String newPassword,
  }) =>
      _repo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
}
