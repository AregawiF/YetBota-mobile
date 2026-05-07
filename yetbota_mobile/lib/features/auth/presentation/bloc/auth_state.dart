import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.errorMessage});
  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

final class AuthAuthenticating extends AuthState {
  const AuthAuthenticating();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({
    required this.accessToken,
    this.username,
  });

  final String accessToken;
  final String? username;

  @override
  List<Object?> get props => [accessToken, username];
}
