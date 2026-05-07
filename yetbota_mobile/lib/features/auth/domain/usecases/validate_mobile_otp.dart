import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/otp_info.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';

class ValidateMobileOtp {
  const ValidateMobileOtp(this._repo);
  final AuthRepository _repo;

  Future<Result<OtpInfo>> call({
    required String mobile,
    required String otp,
    required String random,
  }) {
    return _repo.validateMobileOtp(mobile: mobile, otp: otp, random: random);
  }
}
