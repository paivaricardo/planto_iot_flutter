import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  static final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;

  static Stream<User?> get authStateChanges => _firebaseAuthInstance.authStateChanges();

  static User? get currentUser => _firebaseAuthInstance.currentUser;

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await _firebaseAuthInstance.signInWithCredential(credential);
  }

  // Sign out from social providers
  static Future<void> signOutSocialProviders() async {
    await GoogleSignIn().signOut();
    signOut();
  }

  static Future<void> signOut() async {
    await _firebaseAuthInstance.signOut();
  }
}