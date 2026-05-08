import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:yetbota_mobile/features/profile/domain/entities/user_profile.dart';
import 'package:yetbota_mobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required ProfileRemoteDataSource remote})
      : _remote = remote;

  final ProfileRemoteDataSource _remote;

  @override
  Future<Result<UserProfile>> readSelf() => _remote.readSelf();
}
