import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/readly/profile/business_logic/profile_state.dart';
import 'package:readly/features/readly/profile/data/profile_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit(this.profileRepository)
      : super(const ProfileInitial());

  Future<void> loadUserProfile() async {
    try {
      emit(const ProfileLoading());

      final stats = await profileRepository.fetchUserStats();

      emit(ProfileLoaded(stats));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}