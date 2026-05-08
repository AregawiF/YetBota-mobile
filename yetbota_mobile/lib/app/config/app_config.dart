import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig({
    required this.identityGrpcHost,
    required this.identityGrpcPort,
    required this.grpcUseTls,
  });

  final String identityGrpcHost;
  final int identityGrpcPort;
  final bool grpcUseTls;

  static AppConfig dev() {
    const overrideHost = String.fromEnvironment('IDENTITY_GRPC_HOST');
    const overridePort = int.fromEnvironment('IDENTITY_GRPC_PORT');
    const overrideTls = bool.fromEnvironment('GRPC_USE_TLS');

    final host = overrideHost.isNotEmpty
        ? overrideHost
        : _defaultLocalHost();
    final port = overridePort != 0 ? overridePort : 6969;

    return AppConfig(
      identityGrpcHost: host,
      identityGrpcPort: port,
      grpcUseTls: overrideTls,
    );
  }

  static String _defaultLocalHost() {
    if (kIsWeb) return 'localhost';
    try {
      if (Platform.isAndroid) return '10.0.2.2';
    } catch (_) {
      // Platform may throw on web; the kIsWeb guard above handles that path.
    }
    return 'localhost';
  }
}
