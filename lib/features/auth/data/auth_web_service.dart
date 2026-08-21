import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthWebService {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  AuthWebService(this.firebaseAuth, this.googleSignIn);

  //sign up
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  //sign in
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  //send verification email
  Future<void> sendEmailVerif() async {
    try {
      await firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> reloadUser() async {
    try {
      await firebaseAuth.currentUser?.reload();
    } on FirebaseAuthException {
      rethrow;
    }
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in cancelled.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> updateDisplayName(String name) async {
    try {
      await firebaseAuth.currentUser?.updateDisplayName(name);
      await firebaseAuth.currentUser?.reload();
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    try {
      await firebaseAuth.currentUser?.updatePhotoURL(photoUrl);

      await firebaseAuth.currentUser?.reload();
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> deletePhotoUrl() async {
    try {
      await firebaseAuth.currentUser?.updatePhotoURL(null);
      await firebaseAuth.currentUser?.reload();
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
