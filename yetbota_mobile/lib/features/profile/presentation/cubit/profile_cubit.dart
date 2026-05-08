import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetbota_mobile/core/auth/token_store.dart';
import 'package:yetbota_mobile/core/types/result.dart';
import 'package:yetbota_mobile/features/profile/domain/usecases/read_self_profile.dart';
import 'package:yetbota_mobile/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ReadSelfProfile readSelfProfile,
    required TokenStore tokenStore,
  })  : _readSelfProfile = readSelfProfile,
        _tokenStore = tokenStore,
        super(const ProfileState()) {
    if (_tokenStore.accessToken != null &&
        _tokenStore.accessToken!.isNotEmpty) {
      load();
    }
    _tokenStoreSub = _tokenStore.events.listen(_onTokenStoreEvent);
  }

  final ReadSelfProfile _readSelfProfile;
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

  void reset() {
    emit(const ProfileState());
  }

  @override
  Future<void> close() async {
    await _tokenStoreSub.cancel();
    return super.close();
  }
}
