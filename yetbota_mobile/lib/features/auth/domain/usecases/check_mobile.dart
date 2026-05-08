import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';

class CheckMobile {
  const CheckMobile(this._repo);
  final AuthRepository _repo;

  Future<Result<bool>> call({required String mobile}) {
    return _repo.isMobileRegistered(mobile: mobile);
  }
}
