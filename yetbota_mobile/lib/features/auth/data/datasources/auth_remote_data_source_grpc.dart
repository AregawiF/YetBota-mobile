import 'package:grpc/grpc.dart';
import 'package:yetbota_mobile/core/errors/failure.dart';
import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/data/datasources/auth_remote_data_source.dart';

class GrpcAuthRemoteDataSource implements AuthRemoteDataSource {
  GrpcAuthRemoteDataSource(this._channel);

  final ClientChannel _channel;

  @override
  Future<Result<String>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      throw const AuthFailure('gRPC auth client not wired');
    } catch (e) {
      if (e is Failure) return Err(e);
      return const Err(AuthFailure('gRPC sign-in failed'));
    }
  }
}

