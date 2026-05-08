import 'package:grpc/grpc.dart';
import 'package:yetbota_mobile/core/auth/token_store.dart';

class GrpcInvoker {
  GrpcInvoker(this._tokenStore);

  final TokenStore _tokenStore;

  Future<R> run<R>(Future<R> Function() call) async {
    try {
      return await call();
    } on GrpcError catch (e) {
      if (e.code != StatusCode.unauthenticated) rethrow;
      final ok = await _tokenStore.tryRefresh();
      if (!ok) rethrow;
      return await call();
    }
  }
}
