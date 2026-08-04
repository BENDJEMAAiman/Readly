import 'package:readly/core/constants/app_assets.dart';
import 'package:readly/features/onboarding/data/models/onboarding_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  final SharedPreferences sharedPreferences;

  OnboardingRepository(this.sharedPreferences);

  List<OnboardingModel> getPages() {
    return const [
      OnboardingModel(
        image: AppAssets.onboarding1,
        title: 'Track your reading,\neffortlessly',
        description:
            "See what you're reading, how far you've gone, and build a habit that sticks.",
      ),

      OnboardingModel(
        image: AppAssets.onboarding2,
        title: 'Never lose a great line\nas you read',
        description:
            "Save quotes and jot down your thoughts as you read, so your favorite moments are always there when you need them.",
      ),

      OnboardingModel(
        image: AppAssets.onboarding3,
        title: 'Build your reading\nstreak',
        description:
            "Set a simple daily goal and watch your streak grow. Ready to start your first book?",
      ),
    ];
  }

  Future<void> completeOnboarding() async {
    await sharedPreferences.setBool('hasSeenOnboarding', true);
  }
}