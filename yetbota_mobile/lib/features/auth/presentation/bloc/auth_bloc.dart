import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/get_session.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/sign_in.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/sign_out.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetSession getSession,
    required SignIn signIn,
    required SignOut signOut,
  })  : _getSession = getSession,
        _signIn = signIn,
        _signOut = signOut,
        super(const AuthUnknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  final GetSession _getSession;
  final SignIn _signIn;
  final SignOut _signOut;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final result = await _getSession();
    switch (result) {
      case Ok(value: final session):
        if (session == null) {
          emit(const AuthUnauthenticated());
        } else {
          emit(AuthAuthenticated(token: session.token));
        }
      case Err(failure: final failure):
        emit(AuthUnauthenticated(errorMessage: failure.message));
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthAuthenticating());
    final result = await _signIn(email: event.email, password: event.password);
    switch (result) {
      case Ok(value: final session):
        emit(AuthAuthenticated(token: session.token));
      case Err(failure: final failure):
        emit(AuthUnauthenticated(errorMessage: failure.message));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signOut();
    switch (result) {
      case Ok():
        emit(const AuthUnauthenticated());
      case Err(failure: final failure):
        emit(AuthUnauthenticated(errorMessage: failure.message));
    }
  }
}

