import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/data/models/user.dart';
import 'package:firebase_core/firebase_core.dart';

class UserRepo {
  final _db = FirebaseFirestore.instance;

  Future<void> createUserWithUID(MUser user, String? uid) async {
    try {
      await _db.collection('users').doc(uid).set(user.toFirestore());
    } catch(e) {
      print('Error: $e');
    }
  }

  Future<MUser?> getUserByID(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _db.collection('users').doc(uid).get();

      if (userDoc.exists) {
        MUser user = MUser.fromFirestore(userDoc, null);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }

}