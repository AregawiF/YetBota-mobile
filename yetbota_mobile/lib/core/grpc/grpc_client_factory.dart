import 'package:grpc/grpc.dart';
import 'package:yetbota_mobile/app/config/app_config.dart';
import 'package:yetbota_mobile/core/auth/token_store.dart';
import 'package:yetbota_mobile/core/grpc/auth_metadata_interceptor.dart';
import 'package:yetbota_mobile/core/grpc/generated/identity/v1/auth.pbgrpc.dart';
import 'package:yetbota_mobile/core/grpc/generated/identity/v1/user.pbgrpc.dart';
import 'package:yetbota_mobile/core/grpc/grpc_invoker.dart';
import 'package:yetbota_mobile/core/grpc/identity_methods.dart';

class GrpcClientFactory {
  GrpcClientFactory({
    required AppConfig config,
    required TokenStore tokenStore,
  })  : _config = config,
        _tokenStore = tokenStore {
    _interceptor = AuthMetadataInterceptor(
      tokenStore: tokenStore,
      publicMethods: kIdentityPublicMethods,
    );
    _invoker = GrpcInvoker(tokenStore);
    tokenStore.wireRefreshClient(() => authClient);
  }

  final AppConfig _config;
  final TokenStore _tokenStore;
  late final AuthMetadataInterceptor _interceptor;
  late final GrpcInvoker _invoker;

  ClientChannel? _identityChannel;
  AuthServiceClient? _authClient;
  UserServiceClient? _userClient;

  TokenStore get tokenStore => _tokenStore;
  GrpcInvoker get invoker => _invoker;

  ClientChannel get identityChannel =>
      _identityChannel ??= _buildChannel(
        host: _config.identityGrpcHost,
        port: _config.identityGrpcPort,
      );

  AuthServiceClient get authClient =>
      _authClient ??= AuthServiceClient(
        identityChannel,
        interceptors: [_interceptor],
      );

  UserServiceClient get userClient =>
      _userClient ??= UserServiceClient(
        identityChannel,
        interceptors: [_interceptor],
      );

  Future<void> shutdown() async {
    await _identityChannel?.shutdown();
    _identityChannel = null;
    _authClient = null;
    _userClient = null;
  }

  ClientChannel _buildChannel({required String host, required int port}) {
    final credentials = _config.grpcUseTls
        ? const ChannelCredentials.secure()
        : const ChannelCredentials.insecure();

    return ClientChannel(
      host,
      port: port,
      options: ChannelOptions(
        credentials: credentials,
        idleTimeout: const Duration(minutes: 5),
        connectionTimeout: const Duration(seconds: 10),
      ),
    );
  }
}
