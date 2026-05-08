import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/otp_info.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';

class GenerateMobileOtp {
  const GenerateMobileOtp(this._repo);
  final AuthRepository _repo;

  Future<Result<OtpInfo>> call({
    required String mobile,
    required String random,
  }) {
    return _repo.generateMobileOtp(mobile: mobile, random: random);
  }
}
