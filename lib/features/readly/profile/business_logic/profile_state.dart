import 'package:equatable/equatable.dart';
import 'package:readly/features/readly/profile/model/user_stats.dart';

enum ProfilePictureStatus {
  initial,
  uploading,
  success,
  failure,
}

enum ReadingGoalStatus {
  initial,
  saving,
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

  final ReadingGoalStatus readingGoalStatus;
  final String? readingGoalError;

  const ProfileLoaded({
    required this.stats,
    this.pictureStatus = ProfilePictureStatus.initial,
    this.pictureError,
    this.readingGoalStatus = ReadingGoalStatus.initial,
    this.readingGoalError,
  });

  ProfileLoaded copyWith({
    UserStats? stats,
    ProfilePictureStatus? pictureStatus,
    String? pictureError,
    ReadingGoalStatus? readingGoalStatus,
    String? readingGoalError,
  }) {
    return ProfileLoaded(
      stats: stats ?? this.stats,

      pictureStatus:
          pictureStatus ?? this.pictureStatus,

      pictureError:
          pictureError ?? this.pictureError,

      readingGoalStatus:
          readingGoalStatus ?? this.readingGoalStatus,

      readingGoalError:
          readingGoalError,
    );
  }

  @override
  List<Object?> get props => [
        stats,
        pictureStatus,
        pictureError,
        readingGoalStatus,
        readingGoalError,
      ];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}