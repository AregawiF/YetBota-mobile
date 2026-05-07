import 'package:equatable/equatable.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object?> get props => [username, password];
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Emitted by the registration flow when a brand-new session has been established (Register -> Login). Lets the global AuthBloc transition straight into Authenticated without re-running Login.
final class AuthSessionEstablished extends AuthEvent {
  const AuthSessionEstablished(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => [session.accessToken, session.username];
}
