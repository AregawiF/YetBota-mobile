import 'dart:typed_data';

import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/profile/domain/repositories/profile_repository.dart';

class UploadProfilePhoto {
  const UploadProfilePhoto(this._repo);
  final ProfileRepository _repo;

  Future<Result<String>> call(Uint8List imageBytes) =>
      _repo.uploadProfilePhoto(imageBytes);
}
