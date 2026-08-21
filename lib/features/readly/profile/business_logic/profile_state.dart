import 'package:equatable/equatable.dart';
import 'package:readly/features/readly/profile/model/user_stats.dart';

enum ProfilePictureStatus {
  initial,
  uploading,
  success,
  failure,
}

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserStats stats;
  final ProfilePictureStatus pictureStatus;
  final String? pictureError;

  const ProfileLoaded({
    required this.stats,
    this.pictureStatus = ProfilePictureStatus.initial,
    this.pictureError,
  });

  ProfileLoaded copyWith({
    UserStats? stats,
    ProfilePictureStatus? pictureStatus,
    String? pictureError,
  }) {
    return ProfileLoaded(
      stats: stats ?? this.stats,
      pictureStatus: pictureStatus ?? this.pictureStatus,
      pictureError: pictureError,
    );
  }

  @override
  List<Object?> get props => [
        stats,
        pictureStatus,
        pictureError,
      ];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}