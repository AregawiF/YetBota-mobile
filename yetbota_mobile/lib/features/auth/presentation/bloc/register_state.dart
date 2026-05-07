import 'package:equatable/equatable.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:yetbota_mobile/features/auth/domain/entities/otp_info.dart';

enum RegisterStep {
  mobile,
  otp,
  details,
  done,
}

class RegisterState extends Equatable {
  const RegisterState({
    this.step = RegisterStep.mobile,
    this.mobile,
    this.random,
    this.otpInfo,
    this.session,
    this.requestingOtp = false,
    this.verifyingOtp = false,
    this.registering = false,
    this.errorMessage,
  });

  final RegisterStep step;

  final String? mobile;

  final String? random;

  final OtpInfo? otpInfo;

  final AuthSession? session;

  final bool requestingOtp;
  final bool verifyingOtp;
  final bool registering;
  final String? errorMessage;

  bool get isBusy => requestingOtp || verifyingOtp || registering;

  RegisterState copyWith({
    RegisterStep? step,
    String? mobile,
    String? random,
    OtpInfo? otpInfo,
    AuthSession? session,
    bool? requestingOtp,
    bool? verifyingOtp,
    bool? registering,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RegisterState(
      step: step ?? this.step,
      mobile: mobile ?? this.mobile,
      random: random ?? this.random,
      otpInfo: otpInfo ?? this.otpInfo,
      session: session ?? this.session,
      requestingOtp: requestingOtp ?? this.requestingOtp,
      verifyingOtp: verifyingOtp ?? this.verifyingOtp,
      registering: registering ?? this.registering,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        step,
        mobile,
        random,
        otpInfo,
        session?.accessToken,
        requestingOtp,
        verifyingOtp,
        registering,
        errorMessage,
      ];
}
