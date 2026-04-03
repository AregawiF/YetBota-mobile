import 'package:yetbota_mobile/core/types/result.dart';

abstract interface class AuthRemoteDataSource {
  Future<Result<String>> signIn({
    required String email,
    required String password,
  });
}

