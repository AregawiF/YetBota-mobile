import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/otp_info.dart';

abstract interface class AuthRemoteDataSource {
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  });

  Future<Result<void>> logout({
    required String refreshToken,
    required String username,
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

  /// Check if the mobile number is already registered.
  Future<Result<bool>> checkMobile({required String mobile});

  Future<Result<void>> newPassword({
    required String mobile,
    required String password,
    required String random,
  });

  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
