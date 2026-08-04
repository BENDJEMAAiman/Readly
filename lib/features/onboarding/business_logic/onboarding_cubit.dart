import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/onboarding/business_logic/onboarding_state.dart';
import 'package:readly/features/onboarding/data/onboarding_repository.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository onboardingRepository;

  OnboardingCubit(this.onboardingRepository)
      : super(const OnboardingInitial());

  Future<void> finishOnboarding() async {
    try {
      await onboardingRepository.completeOnboarding();

      emit(const OnboardingCompleted());
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }
}