import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginHelper {
  LoginHelper._();

  static final LoginHelper loginHelper = LoginHelper._();

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> signUp(
      {required String email, required String password}) async {
    Map<String, dynamic> response = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      response["user"] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          response["error"] = "This email is already used by another user...";
          break;
        case "weak-password":
          response["error"] =
              "The password must be greater than 6 characters...";
          break;
        case "operation-not-allowed":
          response["error"] = "This authentication method is disabled...";
          break;
      }
    }

    return response;
  }

  Future<Map<String, dynamic>> signIn(
      {required String email, required String password}) async {
    Map<String, dynamic> response = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      response["user"] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          response["error"] = "This user does not exists...";
          break;
        case "wrong-password":
          response["error"] = "Your password is wrong...";
          break;
        case "operation-not-allowed":
          response["error"] = "This authentication method is disabled...";
          break;
      }
    }

    return response;
  }

  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> response = {};

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      response["user"] = user;
    } catch (e) {
      if (e is PlatformException) {
        response["error"] = e.message;
      } else {
        response["error"] = e.toString();
      }
    }

    return response;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
