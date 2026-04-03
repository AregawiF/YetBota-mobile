class AppConfig {
  const AppConfig({
    required this.grpcHost,
    required this.grpcPort,
    required this.grpcUseTls,
  });

  final String grpcHost;
  final int grpcPort;
  final bool grpcUseTls;

  static const dev = AppConfig(
    grpcHost: 'localhost',
    grpcPort: 50051,
    grpcUseTls: false,
  );
}

