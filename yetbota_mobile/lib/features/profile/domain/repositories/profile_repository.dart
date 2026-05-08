import 'dart:typed_data';

import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/profile/domain/entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<Result<UserProfile>> readSelf();

  Future<Result<UserProfile>> updateSelf({
    required String firstName,
    required String lastName,
    required String username,
  });

  Future<Result<String>> uploadProfilePhoto(Uint8List imageBytes);

  Future<Result<void>> deleteSelf();
}
