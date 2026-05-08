import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/profile/domain/entities/user_profile.dart';

abstract interface class ProfileRemoteDataSource {
  Future<Result<UserProfile>> readSelf();
}
