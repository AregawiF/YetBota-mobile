import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/otp_info.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession?>> getSession();

  Future<Result<AuthSession>> signIn({
    required String username,
    required String password,
  });

  Future<Result<void>> signOut();

  Future<Result<OtpInfo>> generateMobileOtp({
    required String mobile,
    required String random,
  });

  Future<Result<OtpInfo>> validateMobileOtp({
    required String mobile,
    required String otp,
    required String random,
  });

  Future<Result<AuthSession>> registerAndSignIn({
    required String firstName,
    required String lastName,
    required String username,
    required String mobile,
    required String password,
    required String random,
  });

  /// Returns `true` when the mobile number is already registered.
  Future<Result<bool>> isMobileRegistered({required String mobile});

  Future<Result<void>> resetPassword({
    required String mobile,
    required String password,
    required String random,
  });

  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
