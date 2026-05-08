import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grpc/grpc.dart';
import 'package:yetbota_mobile/core/grpc/generated/identity/v1/auth.pbgrpc.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';

enum TokenClearReason {
  userInitiated,
  refreshFailed,
}

sealed class TokenStoreEvent {
  const TokenStoreEvent();
}

final class TokenSessionUpdated extends TokenStoreEvent {
  const TokenSessionUpdated(this.session);
  final AuthSession session;
}

final class TokenSessionCleared extends TokenStoreEvent {
  const TokenSessionCleared(this.reason);
  final TokenClearReason reason;
}

class TokenStore {
  TokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _kAccess = 'auth_access_token';
  static const _kRefresh = 'auth_refresh_token';
  static const _kUsername = 'auth_username';
  static const _kAccessExp = 'auth_access_expires_at';
  static const _kRefreshExp = 'auth_refresh_expires_at';

  final FlutterSecureStorage _storage;

  AuthSession? _session;
  AuthServiceClient Function()? _authClientGetter;

  Future<bool>? _ongoingRefresh;

  final _events = StreamController<TokenStoreEvent>.broadcast();

  Stream<TokenStoreEvent> get events => _events.stream;

  AuthSession? get current => _session;
  String? get accessToken => _session?.accessToken;
  String? get refreshToken => _session?.refreshToken;
  String? get username => _session?.username;

  bool shouldProactivelyRefresh({
    Duration skew = const Duration(seconds: 30),
  }) {
    final s = _session;
    if (s == null || s.refreshToken.isEmpty) return false;
    if (s.isRefreshExpired()) return false;
    return s.isAccessExpired(skew: skew);
  }

  void wireRefreshClient(AuthServiceClient Function() getter) {
    _authClientGetter = getter;
  }

  Future<void> hydrate() async {
    final access = await _storage.read(key: _kAccess);
    if (access == null || access.isEmpty) {
      _session = null;
      return;
    }
    final refresh = await _storage.read(key: _kRefresh) ?? '';
    final username = await _storage.read(key: _kUsername);
    final accessExp = _parseDate(await _storage.read(key: _kAccessExp));
    final refreshExp = _parseDate(await _storage.read(key: _kRefreshExp));

    _session = AuthSession(
      accessToken: access,
      refreshToken: refresh,
      accessTokenExpiresAt: accessExp,
      refreshTokenExpiresAt: refreshExp,
      username: username,
    );
  }

  Future<void> save(AuthSession session) async {
    _session = session;
    await _storage.write(key: _kAccess, value: session.accessToken);
    await _storage.write(key: _kRefresh, value: session.refreshToken);
    if (session.username != null && session.username!.isNotEmpty) {
      await _storage.write(key: _kUsername, value: session.username);
    }
    await _writeDate(_kAccessExp, session.accessTokenExpiresAt);
    await _writeDate(_kRefreshExp, session.refreshTokenExpiresAt);
    _events.add(TokenSessionUpdated(session));
  }

  Future<void> clear({
    TokenClearReason reason = TokenClearReason.userInitiated,
  }) async {
    _session = null;
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
    await _storage.delete(key: _kUsername);
    await _storage.delete(key: _kAccessExp);
    await _storage.delete(key: _kRefreshExp);
    _events.add(TokenSessionCleared(reason));
  }

  Future<bool> tryRefresh() {
    final existing = _ongoingRefresh;
    if (existing != null) return existing;

    final f = _doRefresh();
    _ongoingRefresh = f;
    f.whenComplete(() => _ongoingRefresh = null);
    return f;
  }

  Future<bool> _doRefresh() async {
    final s = _session;
    final getter = _authClientGetter;
    if (s == null || s.refreshToken.isEmpty || s.username == null) {
      return false;
    }
    if (getter == null) return false;
    if (s.isRefreshExpired()) {
      await clear(reason: TokenClearReason.refreshFailed);
      return false;
    }

    final client = getter();
    try {
      final resp = await client.refresh(
        RefreshRequest(
          refreshToken: s.refreshToken,
          username: s.username,
        ),
      );
      if (!resp.success || resp.code != '00') {
        await clear(reason: TokenClearReason.refreshFailed);
        return false;
      }
      final td = resp.data;
      final now = DateTime.now();
      final newSession = AuthSession(
        accessToken: td.accessToken,
        refreshToken: td.refreshToken,
        accessTokenExpiresAt: td.hasAccessTokenTtl()
            ? now.add(Duration(seconds: td.accessTokenTtl.seconds.toInt()))
            : null,
        refreshTokenExpiresAt: td.hasRefreshTokenTtl()
            ? now.add(Duration(seconds: td.refreshTokenTtl.seconds.toInt()))
            : null,
        username: s.username,
      );
      await save(newSession);
      return true;
    } on GrpcError catch (e) {
      if (e.code == StatusCode.unauthenticated ||
          e.code == StatusCode.permissionDenied ||
          e.code == StatusCode.invalidArgument) {
        await clear(reason: TokenClearReason.refreshFailed);
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> dispose() async {
    await _events.close();
  }

  static DateTime? _parseDate(String? s) {
    if (s == null || s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  Future<void> _writeDate(String key, DateTime? value) async {
    if (value == null) {
      await _storage.delete(key: key);
    } else {
      await _storage.write(key: key, value: value.toIso8601String());
    }
  }
}
