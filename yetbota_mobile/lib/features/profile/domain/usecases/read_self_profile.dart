import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/profile/domain/entities/user_profile.dart';
import 'package:yetbota_mobile/features/profile/domain/repositories/profile_repository.dart';

class ReadSelfProfile {
  const ReadSelfProfile(this._repo);
  final ProfileRepository _repo;

  Future<Result<UserProfile>> call() => _repo.readSelf();
}
