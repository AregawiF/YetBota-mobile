import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession?>> getSession();
  Future<Result<AuthSession>> signIn({
    required String email,
    required String password,
  });
  Future<Result<void>> signOut();
}

