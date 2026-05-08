import 'package:grpc/grpc.dart';
import 'package:yetbota_mobile/core/errors/failure.dart';
import 'package:yetbota_mobile/core/grpc/generated/identity/v1/auth.pbgrpc.dart';
import 'package:yetbota_mobile/core/grpc/generated/identity/v1/user.pbgrpc.dart';
import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/otp_info.dart';

class GrpcAuthRemoteDataSource implements AuthRemoteDataSource {
  GrpcAuthRemoteDataSource({
    required AuthServiceClient authClient,
    required UserServiceClient userClient,
  })  : _authClient = authClient,
        _userClient = userClient;

  final AuthServiceClient _authClient;
  final UserServiceClient _userClient;

  static const _successCode = '00';

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async {
    try {
      final resp = await _authClient.login(
        LoginRequest(username: username, password: password),
      );
      if (!resp.success || resp.code != _successCode) {
        return Err(_envelopeFailure(resp.code, resp.message));
      }
      return Ok(_sessionFromTokenData(resp.data, username: username));
    } on GrpcError catch (e) {
      return Err(_grpcToFailure(e));
    } catch (e) {
      return Err(NetworkFailure('Login failed: $e'));
    }
  }

  @override
  Future<Result<void>> logout({
    required String refreshToken,
    required String username,
  }) async {
    if (refreshToken.isEmpty) {
      return const Ok(null);
    }
    try {
      final resp = await _authClient.logout(
        LogoutRequest(refreshToken: refreshToken, username: username),
      );
      if (!resp.success || resp.code != _successCode) {
        return Err(_envelopeFailure(resp.code, resp.message));
      }
      return const Ok(null);
    } on GrpcError catch (e) {
      return Err(_grpcToFailure(e));
    } catch (e) {
      return Err(NetworkFailure('Logout failed: $e'));
    }
  }

  @override
  Future<Result<OtpInfo>> generateMobileOtp({
    required String mobile,
    required String random,
  }) async {
    try {
      final resp = await _authClient.generateMobileOTP(
        GenerateMobileOTPRequest(mobile: mobile, random: random),
      );
      if (!resp.success || resp.code != _successCode) {
        return Err(_envelopeFailure(resp.code, resp.message));
      }
      return Ok(_otpFromData(resp.data));
    } on GrpcError catch (e) {
      return Err(_grpcToFailure(e));
    } catch (e) {
      return Err(NetworkFailure('Failed to send code: $e'));
    }
  }

  @override
  Future<Result<OtpInfo>> validateMobileOtp({
    required String mobile,
    required String otp,
    required String random,
  }) async {
    try {
      final resp = await _authClient.validateOTP(
        ValidateOTPRequest(otp: otp, mobile: mobile, random: random),
      );
      if (!resp.success || resp.code != _successCode) {
        return Err(_envelopeFailure(resp.code, resp.message));
      }
      return Ok(_otpFromData(resp.data));
    } on GrpcError catch (e) {
      return Err(_grpcToFailure(e));
    } catch (e) {
      return Err(NetworkFailure('Failed to verify code: $e'));
    }
  }

  @override
  Future<Result<String>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String mobile,
    required String password,
    required String random,
  }) async {
    try {
      final resp = await _userClient.register(
        RegisterRequest(
          firstName: firstName,
          lastName: lastName,
          username: username,
          mobile: mobile,
          password: password,
          random: random,
        ),
      );
      if (!resp.success || resp.code != _successCode) {
        return Err(_envelopeFailure(resp.code, resp.message));
      }
      return Ok(resp.data.username);
    } on GrpcError catch (e) {
      return Err(_grpcToFailure(e));
    } catch (e) {
      return Err(NetworkFailure('Registration failed: $e'));
    }
  }

  @override
  Future<Result<bool>> checkMobile({required String mobile}) async {
    try {
      final resp =
          await _userClient.checkMobile(CheckMobileRequest(mobile: mobile));
      if (!resp.success || resp.code != _successCode) {
        return Err(_envelopeFailure(resp.code, resp.message));
      }
      return Ok(resp.data);
    } on GrpcError catch (e) {
      return Err(_grpcToFailure(e));
    } catch (e) {
      return Err(NetworkFailure('Failed to check mobile: $e'));
    }
  }

  @override
  Future<Result<void>> newPassword({
    required String mobile,
    required String password,
    required String random,
  }) async {
    try {
      final resp = await _authClient.newPassword(
        NewPasswordRequest(
          password: password,
          random: random,
          mobile: mobile,
        ),
      );
      if (!resp.success || resp.code != _successCode) {
        return Err(_envelopeFailure(resp.code, resp.message));
      }
      return const Ok(null);
    } on GrpcError catch (e) {
      return Err(_grpcToFailure(e));
    } catch (e) {
      return Err(NetworkFailure('Failed to set new password: $e'));
    }
  }

  AuthSession _sessionFromTokenData(TokenData data, {String? username}) {
    final now = DateTime.now();
    return AuthSession(
      accessToken: data.accessToken,
      refreshToken: data.refreshToken,
      accessTokenExpiresAt: data.hasAccessTokenTtl()
          ? now.add(Duration(seconds: data.accessTokenTtl.seconds.toInt()))
          : null,
      refreshTokenExpiresAt: data.hasRefreshTokenTtl()
          ? now.add(Duration(seconds: data.refreshTokenTtl.seconds.toInt()))
          : null,
      username: username,
    );
  }

  OtpInfo _otpFromData(OTPData data) => OtpInfo(
        requestCount: data.otpReqCount,
        maxRequests: data.maxOtpReq,
        errorCount: data.otpErrCount,
        maxErrors: data.maxOtpErr,
      );

  Failure _envelopeFailure(String code, String message) {
    final msg = message.isEmpty ? 'Request failed (code $code)' : message;
    return ServerFailure(msg, code: code);
  }

  Failure _grpcToFailure(GrpcError e) {
    final msg = (e.message == null || e.message!.isEmpty)
        ? 'Request failed (${e.codeName})'
        : e.message!;
    switch (e.code) {
      case StatusCode.unauthenticated:
      case StatusCode.permissionDenied:
        return AuthFailure(msg);
      case StatusCode.invalidArgument:
      case StatusCode.failedPrecondition:
      case StatusCode.outOfRange:
        return ValidationFailure(msg);
      case StatusCode.unavailable:
      case StatusCode.deadlineExceeded:
        return NetworkFailure(msg);
      default:
        return ServerFailure(msg, code: e.codeName);
    }
  }
}
