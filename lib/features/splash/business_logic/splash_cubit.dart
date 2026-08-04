import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/splash/business_logic/splash_state.dart';
import 'package:readly/features/splash/data/splash_repository.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashRepository splashRepository;

  SplashCubit(this.splashRepository) : super(const SplashInitial());
  
  Future<void> initialize() async {
  try {
    final hasSeenOnboarding =
        await splashRepository.hasSeenOnboarding();

    if (!hasSeenOnboarding) {
      emit(const NavigateToOnboarding());
      return;
    }

    emit(const CheckAuthentication());
  } catch (_) {
    emit(const CheckAuthentication());
  }
}
}