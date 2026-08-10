import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:readly/core/network/dio_client.dart';
import 'package:readly/features/auth/data/auth_repository.dart';
import 'package:readly/features/auth/data/auth_web_service.dart';
import 'package:readly/features/bottom%20navigation/library/library/data/library_web_service.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/data/search_repository.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/data/search_web_service.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/data/search_details_repository.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/data/search_details_web_service.dart';
import 'package:readly/features/onboarding/data/onboarding_repository.dart';
import 'package:readly/features/splash/data/splash_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readly/features/bottom%20navigation/library/library/data/library_repository.dart';

//library api search
final searchWebService = SearchWebService(DioClient.dio);
final searchRepository = SearchRepository(searchWebService);

final searchDetailsWebService = SearchDetailsWebService(DioClient.dio);
final searchDetailsRepository = SearchDetailsRepository(
  searchDetailsWebService,
);

//auth
final firebaseAuth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();

final authWebService = AuthWebService(firebaseAuth, googleSignIn);
final authRepository = AuthRepository(authWebService);

// Shared Preferences
late SharedPreferences sharedPreferences;

// Splash
late SplashRepository splashRepository;

//onboarding
late OnboardingRepository onboardingRepository;

final firebaseFirestore = FirebaseFirestore.instance;
final firebaseStorage = FirebaseStorage.instance;

final libraryWebService = LibraryWebService(
  FirebaseFirestore.instance,
  FirebaseStorage.instance,
  FirebaseAuth.instance,
);

final libraryRepository = LibraryRepository(
  libraryWebService,
);



Future<void> initializeDependencies() async {
  sharedPreferences = await SharedPreferences.getInstance();

  splashRepository = SplashRepository(sharedPreferences);
  onboardingRepository = OnboardingRepository(sharedPreferences);
}
