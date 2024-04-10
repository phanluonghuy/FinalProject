import 'package:cloud_firestore/cloud_firestore.dart';

class MUser {
  final String? id;
  final String? email;
  final String? name;
  final String? bio;
  final String? avtUrl;
  final int? exp;

  MUser({
    this.id,
    this.email,
    this.name,
    this.bio,
    this.avtUrl,
    this.exp,
  });

  factory MUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return MUser(
      id: snapshot.id,
      email: data?['email'],
      name: data?['name'],
      bio: data?['bio'],
      avtUrl: data?['avtUrl'],
      exp: data?['exp'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (bio != null) 'bio': bio,
      if (avtUrl != null) 'avtUrl': avtUrl,
      if (exp != null) 'exp': exp,
    };
  }
}
