import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? currentUser = credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The email address is already in use.');
      } else {
        print('An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User? currentUser = credential.user;
      return currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print('Invalid email or password.');
      } else {
        print('An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(error) {
      print(error.toString());
      return null;
    }
  }
}
