
import 'package:readly/features/readly/profile/data/profile_web_service.dart';
import 'package:readly/features/readly/profile/model/user_stats.dart';


class ProfileRepository {
  final ProfileWebService profileWebService;

  ProfileRepository(this.profileWebService);

  Future<UserStats> fetchUserStats() {
    return profileWebService.fetchUserStats();
  }
}