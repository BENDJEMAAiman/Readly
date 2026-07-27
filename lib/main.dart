import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:readly/core/routing/app_router.dart';
import 'package:readly/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized!");
  } on FirebaseException catch (e) {
    debugPrint('Firebase initialization failed: ${e.message}');
    rethrow;
  } catch (e) {
    debugPrint('Unexpected error during Firebase initialization: $e');
    rethrow;
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: ThemeData(fontFamily: "Baloo2"),
    );
  }
}
