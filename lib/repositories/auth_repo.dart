import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepo _userRepo = UserRepo();

  // final String? id;
  // final String? email;
  // final String? name;
  // final String? bio;
  // final int? exp;
  // final String? avatarUrl;
  // final DateTime? birthday;
  // final String? country;
  // final String? phone;
  Future<User?> signUpClassic(
      String email, String password, String name,String bio,int exp,String avatarUrl,DateTime birthday,String country,String phone) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? currentUser = credential.user;



      _userRepo.createUserWithUID(
          UserModel(
              email: email,name: name,bio: bio,exp: exp,avatarUrl: avatarUrl,birthday:birthday,country: country,phone: phone),
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

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    bool success = false;
    var user = await _auth.currentUser!;
    final cred = await EmailAuthProvider.credential(email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {
        success = true;
      }).catchError((error) {
        print(error);
      });
    }).catchError((err) {
      print(err);
    });

    return success;
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
