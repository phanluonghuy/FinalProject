import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepo _userRepo = UserRepo();

  Future<User?> signUpClassic(
      String email, String password, String name) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? currentUser = credential.user;

      _userRepo.createUserWithUID(
          UserModel(
              email: email, name: name, avtUrl: 'defaultava.png', bio: ''),
          currentUser?.uid);

      return currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The email address is already in use.');
      } else {
        print('An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
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
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
