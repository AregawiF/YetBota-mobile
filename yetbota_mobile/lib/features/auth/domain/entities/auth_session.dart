class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.accessTokenExpiresAt,
    this.refreshTokenExpiresAt,
    this.username,
  });

  final String accessToken;
  final String refreshToken;

  final DateTime? accessTokenExpiresAt;
  final DateTime? refreshTokenExpiresAt;

  final String? username;

  bool get hasRefreshToken => refreshToken.isNotEmpty;

  bool isAccessExpired({Duration skew = const Duration(seconds: 10)}) {
    final at = accessTokenExpiresAt;
    if (at == null) return false;
    return DateTime.now().isAfter(at.subtract(skew));
  }

  bool isRefreshExpired({Duration skew = const Duration(seconds: 10)}) {
    final at = refreshTokenExpiresAt;
    if (at == null) return false;
    return DateTime.now().isAfter(at.subtract(skew));
  }

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? accessTokenExpiresAt,
    DateTime? refreshTokenExpiresAt,
    String? username,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accessTokenExpiresAt:
          accessTokenExpiresAt ?? this.accessTokenExpiresAt,
      refreshTokenExpiresAt:
          refreshTokenExpiresAt ?? this.refreshTokenExpiresAt,
      username: username ?? this.username,
    );
  }
}
