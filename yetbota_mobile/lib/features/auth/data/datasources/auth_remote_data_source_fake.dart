import 'dart:math';

import 'package:yetbota_mobile/core/errors/failure.dart';
import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_remote_data_source.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<Result<String>> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return const Err(AuthFailure('Email and password are required'));
    }

    final rand = Random.secure();
    final bytes = List<int>.generate(24, (_) => rand.nextInt(256));
    final token = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return Ok(token);
  }
}

