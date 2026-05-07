import 'package:yetbota_mobile/core/errors/failure.dart';
import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/otp_info.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._local, this._remote);

  final AuthLocalDataSource _local;
  final AuthRemoteDataSource _remote;

  @override
  Future<Result<AuthSession?>> getSession() async {
    try {
      final session = await _local.readSession();
      return Ok(session);
    } catch (_) {
      return const Err(StorageFailure('Failed to read session'));
    }
  }

  @override
  Future<Result<AuthSession>> signIn({
    required String username,
    required String password,
  }) async {
    final remoteResult = await _remote.login(
      username: username,
      password: password,
    );
    switch (remoteResult) {
      case Ok(value: final session):
        try {
          await _local.writeSession(session);
        } catch (_) {
          return const Err(StorageFailure('Failed to persist session'));
        }
        return Ok(session);
      case Err(failure: final failure):
        return Err(failure);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _local.clear();
      return const Ok(null);
    } catch (_) {
      return const Err(StorageFailure('Failed to clear session'));
    }
  }

  @override
  Future<Result<OtpInfo>> generateMobileOtp({
    required String mobile,
    required String random,
  }) {
    return _remote.generateMobileOtp(mobile: mobile, random: random);
  }

  @override
  Future<Result<OtpInfo>> validateMobileOtp({
    required String mobile,
    required String otp,
    required String random,
  }) {
    return _remote.validateMobileOtp(
      mobile: mobile,
      otp: otp,
      random: random,
    );
  }

  @override
  Future<Result<AuthSession>> registerAndSignIn({
    required String firstName,
    required String lastName,
    required String username,
    required String mobile,
    required String password,
    required String random,
  }) async {
    final regResult = await _remote.register(
      firstName: firstName,
      lastName: lastName,
      username: username,
      mobile: mobile,
      password: password,
      random: random,
    );
    switch (regResult) {
      case Err(failure: final failure):
        return Err(failure);
      case Ok():
        return signIn(username: username, password: password);
    }
  }
}
