import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/otp_info.dart';

abstract interface class AuthRemoteDataSource {
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  });

  Future<Result<OtpInfo>> generateMobileOtp({
    required String mobile,
    required String random,
  });

  Future<Result<OtpInfo>> validateMobileOtp({
    required String mobile,
    required String otp,
    required String random,
  });

  Future<Result<String>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String mobile,
    required String password,
    required String random,
  });
}
