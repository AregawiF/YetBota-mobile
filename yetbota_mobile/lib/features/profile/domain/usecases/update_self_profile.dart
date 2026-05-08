import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/profile/domain/entities/user_profile.dart';
import 'package:yetbota_mobile/features/profile/domain/repositories/profile_repository.dart';

class UpdateSelfProfile {
  const UpdateSelfProfile(this._repo);
  final ProfileRepository _repo;

  Future<Result<UserProfile>> call({
    required String firstName,
    required String lastName,
    required String username,
  }) =>
      _repo.updateSelf(
        firstName: firstName,
        lastName: lastName,
        username: username,
      );
}
