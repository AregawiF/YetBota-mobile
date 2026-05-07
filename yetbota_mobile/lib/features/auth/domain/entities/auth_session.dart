class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.accessTokenTtl,
    this.refreshTokenTtl,
    this.username,
  });

  final String accessToken;
  final String refreshToken;
  final Duration? accessTokenTtl;
  final Duration? refreshTokenTtl;
  final String? username;
}
