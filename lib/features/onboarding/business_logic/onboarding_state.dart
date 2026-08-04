sealed class OnboardingState {
  const OnboardingState();
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

final class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}

final class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);
}