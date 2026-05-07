import 'package:grpc/grpc.dart';
import 'package:yetbota_mobile/app/config/app_config.dart';
import 'package:yetbota_mobile/core/grpc/generated/identity/v1/auth.pbgrpc.dart';
import 'package:yetbota_mobile/core/grpc/generated/identity/v1/user.pbgrpc.dart';

/// Owns the gRPC channel(s) and exposes lazily-built typed clients for each
/// service. One instance per app session (created in `bootstrap`).
class GrpcClientFactory {
  GrpcClientFactory(this._config);

  final AppConfig _config;

  ClientChannel? _identityChannel;
  AuthServiceClient? _authClient;
  UserServiceClient? _userClient;

  ClientChannel get identityChannel =>
      _identityChannel ??= _buildChannel(
        host: _config.identityGrpcHost,
        port: _config.identityGrpcPort,
      );

  AuthServiceClient get authClient =>
      _authClient ??= AuthServiceClient(identityChannel);

  UserServiceClient get userClient =>
      _userClient ??= UserServiceClient(identityChannel);

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
