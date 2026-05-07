import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _usernameKey = 'auth_username';

  Future<AuthSession?> readSession() async {
    final access = await _storage.read(key: _accessTokenKey);
    if (access == null || access.isEmpty) return null;

    final refresh = await _storage.read(key: _refreshTokenKey);
    final username = await _storage.read(key: _usernameKey);

    return AuthSession(
      accessToken: access,
      refreshToken: refresh ?? '',
      username: username,
    );
  }

  Future<void> writeSession(AuthSession session) async {
    await _storage.write(key: _accessTokenKey, value: session.accessToken);
    await _storage.write(key: _refreshTokenKey, value: session.refreshToken);
    if (session.username != null && session.username!.isNotEmpty) {
      await _storage.write(key: _usernameKey, value: session.username);
    }
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _usernameKey);
  }
}
