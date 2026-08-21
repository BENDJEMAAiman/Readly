import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:readly/features/auth/data/auth_web_service.dart';
import 'package:readly/features/auth/model/user_entity.dart';

class AuthRepository {
  final AuthWebService authWebService;
  AuthRepository(this.authWebService);

  UserEntity _mapUser(User firebaseUser) {
    debugPrint('================ USER DEBUG ================');
    debugPrint('UID: ${firebaseUser.uid}');
    debugPrint('EMAIL: ${firebaseUser.email}');
    debugPrint('DISPLAY NAME FROM FIREBASE: ${firebaseUser.displayName}');
    debugPrint('PHOTO URL FROM FIREBASE: ${firebaseUser.photoURL}');
    debugPrint('EMAIL VERIFIED: ${firebaseUser.emailVerified}');
    debugPrint('============================================');
    return UserEntity(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      emailVerified: firebaseUser.emailVerified,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  Future<UserEntity> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await authWebService.signUpWithEmail(email: email, password: password);
      await authWebService.updateDisplayName(name);
      await authWebService.sendEmailVerif();
      final currentUser = authWebService.getCurrentUser();

      if (currentUser == null) {
        throw Exception("Failed to retrieve the authenticated user.");
      }

      return _mapUser(currentUser);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('An account already exists with this email.');

        case 'invalid-email':
          throw Exception('Please enter a valid email address.');

        case 'weak-password':
          throw Exception('Password should be at least 6 characters.');

        default:
          throw Exception('Failed to create account. Please try again.');
      }
    }
  }

  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await authWebService.signInWithEmail(email: email, password: password);
      final currentUser = authWebService.getCurrentUser();
      if (currentUser == null) {
        throw Exception("Failed to retrieve the authenticated user.");
      }
      return _mapUser(currentUser);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw Exception('Please enter a valid email address.');

        case 'invalid-credential':
          throw Exception('Invalid email or password.');

        case 'user-disabled':
          throw Exception('This account has been disabled.');

        default:
          throw Exception('Failed to sign in. Please try again.');
      }
    }
  }

  Future<UserEntity?> checkAuthStatus() async {
    try {
      var currentUser = authWebService.getCurrentUser();
      if (currentUser == null) {
        return null;
      }

      await authWebService.reloadUser();
      currentUser = authWebService.getCurrentUser();

      if (currentUser == null) {
        return null;
      }

      return _mapUser(currentUser);
    } on FirebaseAuthException {
      throw Exception("Failed to check authentication status.");
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await authWebService.resetPassword(email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw Exception('Please enter a valid email address.');

        case 'user-not-found':
          throw Exception('No account found with this email.');

        default:
          throw Exception('Failed to send password reset email.');
      }
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final currentUser = authWebService.getCurrentUser();

      if (currentUser == null) {
        throw Exception('No authenticated user found.');
      }

      await authWebService.sendEmailVerif();
    } on FirebaseAuthException {
      throw Exception('Failed to send verification email.');
    }
  }

  Future<void> signOut() async {
    try {
      await authWebService.signOut();
    } on FirebaseAuthException {
      throw Exception('Failed to sign out.');
    }
  }

  Future<UserEntity> signInWithGoogle() async {
    try {
      final credential = await authWebService.signInWithGoogle();
      final currentUser = credential.user;

      if (currentUser == null) {
        throw Exception("Failed to retrieve the authenticated user.");
      }

      return _mapUser(currentUser);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception(
            'An account already exists with a different sign-in method.',
          );

        case 'invalid-credential':
          throw Exception('The Google credentials are invalid.');

        default:
          throw Exception('Google sign in failed. Please try again.');
      }
    }
  }

  Future<void> updateProfilePhoto(String photoUrl) async {
    try {
      await authWebService.updatePhotoUrl(photoUrl);
    } on FirebaseAuthException {
      throw Exception('Failed to update profile picture.');
    }
  }

  String getCurrentUserId() {
    final user = authWebService.getCurrentUser();

    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    return user.uid;
  }

  Future<void> deleteProfilePhoto() async {
    try {
      await authWebService.deletePhotoUrl();
    } on FirebaseAuthException {
      throw Exception('Failed to delete profile picture.');
    }
  }
}
