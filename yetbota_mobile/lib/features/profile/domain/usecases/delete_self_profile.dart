import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/profile/domain/repositories/profile_repository.dart';

class DeleteSelfProfile {
  const DeleteSelfProfile(this._repo);
  final ProfileRepository _repo;

  Future<Result<void>> call() => _repo.deleteSelf();
}
