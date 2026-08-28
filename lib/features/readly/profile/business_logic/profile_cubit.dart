import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/core/network/cloudinary_service.dart';
import 'package:readly/features/auth/data/auth_repository.dart';
import 'package:readly/features/readly/profile/business_logic/profile_state.dart';
import 'package:readly/features/readly/profile/data/profile_repository.dart';
import 'package:readly/features/readly/profile/model/user_stats.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  final CloudinaryService cloudinaryService;
  final AuthRepository authRepository;

  UserStats? _currentStats;

  ProfileCubit(
    this.profileRepository,
    this.cloudinaryService,
    this.authRepository,
  ) : super(const ProfileInitial());

  Future<void> loadUserProfile() async {
    try {
      emit(const ProfileLoading());

      final stats = await profileRepository.fetchUserStats();

      _currentStats = stats;

      emit(ProfileLoaded(stats: stats));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfilePicture(File imageFile) async {
    if (_currentStats == null) return;

    try {
      emit(
        ProfileLoaded(
          stats: _currentStats!,
          pictureStatus: ProfilePictureStatus.uploading,
        ),
      );

      final userId = authRepository.getCurrentUserId();

      final photoUrl = await cloudinaryService.uploadProfilePicture(
        file: imageFile,
        userId: userId,
      );

      debugPrint('NEW CLOUDINARY URL: $photoUrl');

      await authRepository.updateProfilePhoto(photoUrl);

      emit(
        ProfileLoaded(
          stats: _currentStats!,
          pictureStatus: ProfilePictureStatus.success,
        ),
      );
    } catch (e) {
      emit(
        ProfileLoaded(
          stats: _currentStats!,
          pictureStatus: ProfilePictureStatus.failure,
          pictureError: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteProfilePicture() async {
    if (_currentStats == null) return;

    try {
      emit(
        ProfileLoaded(
          stats: _currentStats!,
          pictureStatus: ProfilePictureStatus.uploading,
        ),
      );

      await authRepository.deleteProfilePhoto();

      emit(
        ProfileLoaded(
          stats: _currentStats!,
          pictureStatus: ProfilePictureStatus.success,
        ),
      );
    } catch (e) {
      emit(
        ProfileLoaded(
          stats: _currentStats!,
          pictureStatus: ProfilePictureStatus.failure,
          pictureError: e.toString(),
        ),
      );
    }
  }


  Future<void> updateReadingGoals({
  required int dailyGoalPages,
  required int dailyGoalMinutes,
}) async {
  if (_currentStats == null) return;

  try {
    emit(
      ProfileLoaded(
        stats: _currentStats!,
        readingGoalStatus: ReadingGoalStatus.saving,
      ),
    );

    await profileRepository.updateReadingGoals(
      dailyGoalPages: dailyGoalPages,
      dailyGoalMinutes: dailyGoalMinutes,
    );

    _currentStats = _currentStats!.copyWith(
      dailyGoalPages: dailyGoalPages,
      dailyGoalMinutes: dailyGoalMinutes,
    );

    emit(
      ProfileLoaded(
        stats: _currentStats!,
        readingGoalStatus: ReadingGoalStatus.success,
      ),
    );
  } catch (e) {
    emit(
      ProfileLoaded(
        stats: _currentStats!,
        readingGoalStatus: ReadingGoalStatus.failure,
        readingGoalError: e.toString(),
      ),
    );
  }
}
}
