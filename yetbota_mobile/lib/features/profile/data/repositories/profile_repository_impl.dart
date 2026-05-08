import 'dart:typed_data';

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

  @override
  Future<Result<UserProfile>> updateSelf({
    required String firstName,
    required String lastName,
    required String username,
  }) =>
      _remote.updateSelf(
        firstName: firstName,
        lastName: lastName,
        username: username,
      );

  @override
  Future<Result<String>> uploadProfilePhoto(Uint8List imageBytes) =>
      _remote.uploadProfilePhoto(imageBytes);

  @override
  Future<Result<void>> deleteSelf() => _remote.deleteSelf();
}
