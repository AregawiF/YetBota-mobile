import 'package:grpc/grpc.dart';
import 'package:yetbota_mobile/core/auth/token_store.dart';

/// Attach access_token to every non-public outgoing call.
class AuthMetadataInterceptor implements ClientInterceptor {
  AuthMetadataInterceptor({
    required this.tokenStore,
    required this.publicMethods,
  });

  final TokenStore tokenStore;
  final Set<String> publicMethods;

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    if (publicMethods.contains(method.path)) {
      return invoker(method, request, options);
    }
    final newOptions = options.mergedWith(
      CallOptions(providers: [_provideAuth]),
    );
    return invoker(method, request, newOptions);
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    if (publicMethods.contains(method.path)) {
      return invoker(method, requests, options);
    }
    final newOptions = options.mergedWith(
      CallOptions(providers: [_provideAuth]),
    );
    return invoker(method, requests, newOptions);
  }

  Future<void> _provideAuth(
    Map<String, String> metadata,
    String uri,
  ) async {
    if (tokenStore.shouldProactivelyRefresh()) {
      await tokenStore.tryRefresh();
    }
    final t = tokenStore.accessToken;
    if (t != null && t.isNotEmpty) {
      metadata['authorization'] = 'Bearer $t';
    }
  }
}
