import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/generate_mobile_otp.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/register.dart';
import 'package:yetbota_mobile/features/auth/domain/usecases/validate_mobile_otp.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/register_event.dart';
import 'package:yetbota_mobile/features/auth/presentation/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required GenerateMobileOtp generateOtp,
    required ValidateMobileOtp validateOtp,
    required Register register,
  })  : _generateOtp = generateOtp,
        _validateOtp = validateOtp,
        _register = register,
        super(const RegisterState()) {
    on<RegisterMobileSubmitted>(_onMobileSubmitted);
    on<RegisterOtpResendRequested>(_onOtpResend);
    on<RegisterOtpSubmitted>(_onOtpSubmitted);
    on<RegisterDetailsSubmitted>(_onDetailsSubmitted);
    on<RegisterReset>((_, emit) => emit(const RegisterState()));
  }

  final GenerateMobileOtp _generateOtp;
  final ValidateMobileOtp _validateOtp;
  final Register _register;

  Future<void> _onMobileSubmitted(
    RegisterMobileSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    final random = _newRandom();
    emit(state.copyWith(
      mobile: event.mobile,
      random: random,
      requestingOtp: true,
      clearError: true,
    ));

    final result = await _generateOtp(mobile: event.mobile, random: random);
    switch (result) {
      case Ok(value: final info):
        emit(state.copyWith(
          mobile: event.mobile,
          random: random,
          otpInfo: info,
          step: RegisterStep.otp,
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
    RegisterOtpResendRequested event,
    Emitter<RegisterState> emit,
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
    RegisterOtpSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    final mobile = state.mobile;
    final random = state.random;
    if (mobile == null || random == null) {
      emit(state.copyWith(
        errorMessage: 'Please enter your phone number first.',
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
          step: RegisterStep.details,
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

  Future<void> _onDetailsSubmitted(
    RegisterDetailsSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    final mobile = state.mobile;
    final random = state.random;
    if (mobile == null || random == null) {
      emit(state.copyWith(
        errorMessage: 'Session expired. Please restart sign up.',
      ));
      return;
    }

    emit(state.copyWith(registering: true, clearError: true));

    final result = await _register(
      firstName: event.firstName,
      lastName: event.lastName,
      username: event.username,
      mobile: mobile,
      password: event.password,
      random: random,
    );
    switch (result) {
      case Ok(value: final session):
        emit(state.copyWith(
          session: session,
          step: RegisterStep.done,
          registering: false,
          clearError: true,
        ));
      case Err(failure: final failure):
        emit(state.copyWith(
          registering: false,
          errorMessage: failure.message,
        ));
    }
  }

  static final _rng = Random.secure();

  static String _newRandom() {
    final bytes = List<int>.generate(16, (_) => _rng.nextInt(256));
    return bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}
