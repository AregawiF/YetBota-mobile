import 'package:equatable/equatable.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/otp_info.dart';

enum ForgotPasswordStep {
  mobile,
  otp,
  newPassword,
  done,
}

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.step = ForgotPasswordStep.mobile,
    this.mobile,
    this.random,
    this.otpInfo,
    this.requestingOtp = false,
    this.verifyingOtp = false,
    this.submittingPassword = false,
    this.errorMessage,
  });

  final ForgotPasswordStep step;
  final String? mobile;
  final String? random;
  final OtpInfo? otpInfo;

  final bool requestingOtp;
  final bool verifyingOtp;
  final bool submittingPassword;
  final String? errorMessage;

  bool get isBusy =>
      requestingOtp || verifyingOtp || submittingPassword;

  ForgotPasswordState copyWith({
    ForgotPasswordStep? step,
    String? mobile,
    String? random,
    OtpInfo? otpInfo,
    bool? requestingOtp,
    bool? verifyingOtp,
    bool? submittingPassword,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      mobile: mobile ?? this.mobile,
      random: random ?? this.random,
      otpInfo: otpInfo ?? this.otpInfo,
      requestingOtp: requestingOtp ?? this.requestingOtp,
      verifyingOtp: verifyingOtp ?? this.verifyingOtp,
      submittingPassword: submittingPassword ?? this.submittingPassword,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        step,
        mobile,
        random,
        otpInfo,
        requestingOtp,
        verifyingOtp,
        submittingPassword,
        errorMessage,
      ];
}
