import 'package:yetbota_mobile/core/errors/failure.dart';
import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._local, this._remote);
  final AuthLocalDataSource _local;
  final AuthRemoteDataSource _remote;

  @override
  Future<Result<AuthSession?>> getSession() async {
    try {
      final token = await _local.readToken();
      if (token == null || token.isEmpty) return const Ok(null);
      return Ok(AuthSession(token: token));
    } catch (_) {
      return const Err(StorageFailure('Failed to read session'));
    }
  }

  @override
  Future<Result<AuthSession>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final remoteResult = await _remote.signIn(email: email, password: password);
      switch (remoteResult) {
        case Ok(value: final token):
          await _local.writeToken(token);
          return Ok(AuthSession(token: token));
        case Err(failure: final failure):
          return Err(failure);
      }
    } catch (_) {
      return const Err(StorageFailure('Failed to persist session'));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _local.clearToken();
      return const Ok(null);
    } catch (_) {
      return const Err(StorageFailure('Failed to clear session'));
    }
  }
}

