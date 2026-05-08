import 'package:equatable/equatable.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

final class ForgotPasswordReset extends ForgotPasswordEvent {
  const ForgotPasswordReset();
}

final class ForgotPasswordMobileSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordMobileSubmitted(this.mobile);

  final String mobile;

  @override
  List<Object?> get props => [mobile];
}

final class ForgotPasswordOtpResendRequested extends ForgotPasswordEvent {
  const ForgotPasswordOtpResendRequested();
}

final class ForgotPasswordOtpSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordOtpSubmitted(this.otp);

  final String otp;

  @override
  List<Object?> get props => [otp];
}

final class ForgotPasswordNewPasswordSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordNewPasswordSubmitted(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}
