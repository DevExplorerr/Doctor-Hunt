import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthRepository extends GetxService {
  static AuthRepository get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> _saveUserData(String uid, String email, String name) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'role': 'patient',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw "Account created, but failed to save profile data.";
    }
  }

  Future<UserCredential> signUpWithEmail(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _saveUserData(userCredential.user!.uid, email, fullName);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please log in.';
      case 'user-not-found':
        return "No account found with this email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return "This account has been disabled. Contact support.";
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'too-many-requests':
        return "Too many login attempts. Try again later.";
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
