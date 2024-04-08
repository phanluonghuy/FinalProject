import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/data/models/user.dart';
import 'package:firebase_core/firebase_core.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> createUser(MUser user) async {
    await _db.collection('users').add(user.toFirestore());
  }
}
