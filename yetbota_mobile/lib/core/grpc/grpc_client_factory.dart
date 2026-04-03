import 'package:grpc/grpc.dart';
import 'package:yetbota_mobile/app/config/app_config.dart';

class GrpcClientFactory {
  GrpcClientFactory(this._config);

  final AppConfig _config;

  ClientChannel createChannel() {
    final credentials = _config.grpcUseTls
        ? const ChannelCredentials.secure()
        : const ChannelCredentials.insecure();

    return ClientChannel(
      _config.grpcHost,
      port: _config.grpcPort,
      options: ChannelOptions(credentials: credentials),
    );
  }
}

