import 'package:shared_preferences/shared_preferences.dart';

class SplashRepository {
  static const _onboardingKey = 'has_seen_onboarding';

  final SharedPreferences prefs;

  SplashRepository(this.prefs);

  Future<bool> hasSeenOnboarding() async {
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    await prefs.setBool(_onboardingKey, true);
  }
}