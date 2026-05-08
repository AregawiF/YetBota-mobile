import 'package:equatable/equatable.dart';
import 'package:yetbota_mobile/features/profile/domain/entities/user_profile.dart';

enum ProfileStatus { initial, loading, loaded, failed }

enum ProfileBusyAction { none, updatingProfile, uploadingPhoto, deletingAccount }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.busyAction = ProfileBusyAction.none,
    this.busyErrorMessage,
  });

  final ProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;

  /// Secondary busy state for mutations while keeping `profile` visible.
  final ProfileBusyAction busyAction;
  final String? busyErrorMessage;

  bool get isBusy => busyAction != ProfileBusyAction.none;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? errorMessage,
    bool clearError = false,
    bool clearProfile = false,
    ProfileBusyAction? busyAction,
    String? busyErrorMessage,
    bool clearBusyError = false,
    bool clearBusy = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: clearProfile ? null : (profile ?? this.profile),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      busyAction:
          clearBusy ? ProfileBusyAction.none : (busyAction ?? this.busyAction),
      busyErrorMessage: clearBusy || clearBusyError
          ? null
          : (busyErrorMessage ?? this.busyErrorMessage),
    );
  }

  @override
  List<Object?> get props =>
      [status, profile, errorMessage, busyAction, busyErrorMessage];
}
