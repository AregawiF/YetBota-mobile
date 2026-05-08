import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/check_mobile.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/generate_mobile_otp.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/reset_password.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/validate_mobile_otp.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/forgot_password_event.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required CheckMobile checkMobile,
    required GenerateMobileOtp generateOtp,
    required ValidateMobileOtp validateOtp,
    required ResetPassword resetPassword,
  })  : _checkMobile = checkMobile,
        _generateOtp = generateOtp,
        _validateOtp = validateOtp,
        _resetPassword = resetPassword,
        super(const ForgotPasswordState()) {
    on<ForgotPasswordReset>((_, emit) => emit(const ForgotPasswordState()));
    on<ForgotPasswordMobileSubmitted>(_onMobileSubmitted);
    on<ForgotPasswordOtpResendRequested>(_onOtpResend);
    on<ForgotPasswordOtpSubmitted>(_onOtpSubmitted);
    on<ForgotPasswordNewPasswordSubmitted>(_onNewPasswordSubmitted);
  }

  final CheckMobile _checkMobile;
  final GenerateMobileOtp _generateOtp;
  final ValidateMobileOtp _validateOtp;
  final ResetPassword _resetPassword;

  Future<void> _onMobileSubmitted(
    ForgotPasswordMobileSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final random = _newRandom();
    emit(state.copyWith(
      mobile: event.mobile,
      random: random,
      requestingOtp: true,
      clearError: true,
    ));

    final checkResult = await _checkMobile(mobile: event.mobile);
    switch (checkResult) {
      case Ok(value: final isRegistered):
        if (!isRegistered) {
          emit(state.copyWith(
            requestingOtp: false,
            errorMessage:
                'No account found for this phone number. Please sign up.',
          ));
          return;
        }
      case Err(failure: final failure):
        emit(state.copyWith(
          requestingOtp: false,
          errorMessage: failure.message,
        ));
        return;
    }

    final result = await _generateOtp(mobile: event.mobile, random: random);
    switch (result) {
      case Ok(value: final info):
        emit(state.copyWith(
          mobile: event.mobile,
          random: random,
          otpInfo: info,
          step: ForgotPasswordStep.otp,
          requestingOtp: false,
          clearError: true,
        ));
      case Err(failure: final failure):
        emit(state.copyWith(
          requestingOtp: false,
          errorMessage: failure.message,
        ));
    }
  }

  Future<void> _onOtpResend(
    ForgotPasswordOtpResendRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final mobile = state.mobile;
    final random = state.random;
    if (mobile == null || random == null) return;

    emit(state.copyWith(requestingOtp: true, clearError: true));

    final result = await _generateOtp(mobile: mobile, random: random);
    switch (result) {
      case Ok(value: final info):
        emit(state.copyWith(otpInfo: info, requestingOtp: false));
      case Err(failure: final failure):
        emit(state.copyWith(
          requestingOtp: false,
          errorMessage: failure.message,
        ));
    }
  }

  Future<void> _onOtpSubmitted(
    ForgotPasswordOtpSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final mobile = state.mobile;
    final random = state.random;
    if (mobile == null || random == null) {
      emit(state.copyWith(
        errorMessage: 'Please re-enter your phone number.',
      ));
      return;
    }
    emit(state.copyWith(verifyingOtp: true, clearError: true));

    final result = await _validateOtp(
      mobile: mobile,
      otp: event.otp,
      random: random,
    );
    switch (result) {
      case Ok(value: final info):
        emit(state.copyWith(
          otpInfo: info,
          step: ForgotPasswordStep.newPassword,
          verifyingOtp: false,
          clearError: true,
        ));
      case Err(failure: final failure):
        emit(state.copyWith(
          verifyingOtp: false,
          errorMessage: failure.message,
        ));
    }
  }

  Future<void> _onNewPasswordSubmitted(
    ForgotPasswordNewPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final mobile = state.mobile;
    final random = state.random;
    if (mobile == null || random == null) {
      emit(state.copyWith(
        errorMessage: 'Session expired. Please restart password reset.',
      ));
      return;
    }
    emit(state.copyWith(submittingPassword: true, clearError: true));

    final result = await _resetPassword(
      mobile: mobile,
      password: event.password,
      random: random,
    );
    switch (result) {
      case Ok():
        emit(state.copyWith(
          step: ForgotPasswordStep.done,
          submittingPassword: false,
          clearError: true,
        ));
      case Err(failure: final failure):
        emit(state.copyWith(
          submittingPassword: false,
          errorMessage: failure.message,
        ));
    }
  }

  static final _rng = Random.secure();

  static String _newRandom() {
    final bytes = List<int>.generate(16, (_) => _rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
