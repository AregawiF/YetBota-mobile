import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:yetbota_mobile/features/auth/domain/repositories/auth_repository.dart';

class GetSession {
  const GetSession(this._repo);
  final AuthRepository _repo;

  Future<Result<AuthSession?>> call() => _repo.getSession();
}

