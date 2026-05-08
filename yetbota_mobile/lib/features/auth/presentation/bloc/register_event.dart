import 'package:equatable/equatable.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

final class RegisterMobileSubmitted extends RegisterEvent {
  const RegisterMobileSubmitted(this.mobile);

  final String mobile;

  @override
  List<Object?> get props => [mobile];
}

final class RegisterOtpResendRequested extends RegisterEvent {
  const RegisterOtpResendRequested();
}

final class RegisterOtpSubmitted extends RegisterEvent {
  const RegisterOtpSubmitted(this.otp);

  final String otp;

  @override
  List<Object?> get props => [otp];
}

final class RegisterDetailsSubmitted extends RegisterEvent {
  const RegisterDetailsSubmitted({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String username;
  final String password;

  @override
  List<Object?> get props => [firstName, lastName, username, password];
}

final class RegisterReset extends RegisterEvent {
  const RegisterReset();
}
