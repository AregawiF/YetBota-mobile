import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/core/auth/token_store.dart';
import 'package:yetbota_mobile/core/errors/failure.dart';
import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/profile/domain/entities/user_profile.dart';
import 'package:yetbota_mobile/features/profile/domain/usecases/delete_self_profile.dart';
import 'package:yetbota_mobile/features/profile/domain/usecases/read_self_profile.dart';
import 'package:yetbota_mobile/features/profile/domain/usecases/update_self_profile.dart';
import 'package:yetbota_mobile/features/profile/domain/usecases/upload_profile_photo.dart';
import 'package:yetbota_mobile/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ReadSelfProfile readSelfProfile,
    required UpdateSelfProfile updateSelfProfile,
    required UploadProfilePhoto uploadProfilePhoto,
    required DeleteSelfProfile deleteSelfProfile,
    required TokenStore tokenStore,
  })  : _readSelfProfile = readSelfProfile,
        _updateSelfProfile = updateSelfProfile,
        _uploadProfilePhoto = uploadProfilePhoto,
        _deleteSelfProfile = deleteSelfProfile,
        _tokenStore = tokenStore,
        super(const ProfileState()) {
    if (_tokenStore.accessToken != null &&
        _tokenStore.accessToken!.isNotEmpty) {
      load();
    }
    _tokenStoreSub = _tokenStore.events.listen(_onTokenStoreEvent);
  }

  final ReadSelfProfile _readSelfProfile;
  final UpdateSelfProfile _updateSelfProfile;
  final UploadProfilePhoto _uploadProfilePhoto;
  final DeleteSelfProfile _deleteSelfProfile;
  final TokenStore _tokenStore;
  late final StreamSubscription<TokenStoreEvent> _tokenStoreSub;

  void _onTokenStoreEvent(TokenStoreEvent ev) {
    if (ev is TokenSessionUpdated) {
      load();
    } else if (ev is TokenSessionCleared) {
      reset();
    }
  }

  Future<void> load() async {
    if (state.status == ProfileStatus.loading) return;
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));
    final result = await _readSelfProfile();
    switch (result) {
      case Ok(value: final profile):
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          profile: profile,
          clearError: true,
        ));
      case Err(failure: final failure):
        emit(state.copyWith(
          status: ProfileStatus.failed,
          errorMessage: failure.message,
        ));
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String username,
  }) async {
    if (state.isBusy) return;
    emit(state.copyWith(
      busyAction: ProfileBusyAction.updatingProfile,
      clearBusyError: true,
    ));
    final result = await _updateSelfProfile(
      firstName: firstName,
      lastName: lastName,
      username: username.trim().toLowerCase(),
    );
    switch (result) {
      case Ok(value: final profile):
        emit(state.copyWith(
          profile: profile,
          clearBusy: true,
        ));
      case Err(failure: final failure):
        emit(state.copyWith(
          busyAction: ProfileBusyAction.none,
          busyErrorMessage: failure.message,
        ));
    }
  }

  Future<void> uploadProfilePhotoBytes(Uint8List imageBytes) async {
    if (state.isBusy) return;
    emit(state.copyWith(
      busyAction: ProfileBusyAction.uploadingPhoto,
      clearBusyError: true,
    ));
    final result = await _uploadProfilePhoto(imageBytes);
    switch (result) {
      case Ok(value: final urlFromUpload):
        emit(state.copyWith(clearBusy: true));
        final reload = await _readSelfProfile();
        if (isClosed) return;
        switch (reload) {
          case Ok(value: final profile):
            emit(state.copyWith(
              profile: profile,
              status: ProfileStatus.loaded,
              clearError: true,
            ));
          case Err():
            final prev = state.profile;
            final u = urlFromUpload.trim();
            if (prev != null && u.isNotEmpty) {
              emit(state.copyWith(
                profile: UserProfile(
                  id: prev.id,
                  firstName: prev.firstName,
                  lastName: prev.lastName,
                  username: prev.username,
                  mobile: prev.mobile,
                  rating: prev.rating,
                  contributions: prev.contributions,
                  followers: prev.followers,
                  following: prev.following,
                  status: prev.status,
                  role: prev.role,
                  profileUrl: u,
                  createdAt: prev.createdAt,
                  updatedAt: prev.updatedAt,
                ),
              ));
            }
        }
      case Err(failure: final failure):
        emit(state.copyWith(
          busyAction: ProfileBusyAction.none,
          busyErrorMessage: failure.message,
        ));
    }
  }

  Future<Result<void>> deleteAccount() async {
    if (state.isBusy) {
      return const Err(NetworkFailure('Please wait'));
    }
    emit(state.copyWith(
      busyAction: ProfileBusyAction.deletingAccount,
      clearBusyError: true,
    ));
    final result = await _deleteSelfProfile();
    switch (result) {
      case Ok():
        await _tokenStore.clear(reason: TokenClearReason.userInitiated);
        emit(const ProfileState());
        return const Ok(null);
      case Err(failure: final failure):
        emit(state.copyWith(
          busyAction: ProfileBusyAction.none,
          busyErrorMessage: failure.message,
        ));
        return Err(failure);
    }
  }

  void clearBusyError() {
    if (state.busyErrorMessage != null) {
      emit(state.copyWith(clearBusyError: true));
    }
  }

  void reset() {
    emit(const ProfileState());
  }

  @override
  Future<void> close() async {
    await _tokenStoreSub.cancel();
    return super.close();
  }
}
