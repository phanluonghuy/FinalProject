import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _storageRef = FirebaseStorage.instance.ref();

class UserModel {
  String? id;
  String? email;
  String? name;
  String? bio;
  int? exp;
  String? avatarUrl;
  DateTime? birthday;
  String? country;
  String? phone;
  // String? id;
  // String? email;
  // String? name;
  // String? bio;
  // int? exp;
  // String? avatarUrl;
  // DateTime? birthday;
  // String? country;
  // String? phone;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.bio,
    this.exp,
    this.avatarUrl,
    this.birthday,
    this.country,
    this.phone,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      id: snapshot.id,
      email: data?['email'],
      name: data?['name'],
      bio: data?['bio'],
      exp: data?['exp'],
      avatarUrl: data?['avatarUrl'],
      birthday: (data?['birthday'] as Timestamp?)?.toDate(),
      country: data?['country'],
      phone: data?['phone'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (bio != null) 'bio': bio,
      if (exp != null) 'exp': exp,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (birthday != null) 'birthday': birthday,
      if (country != null) 'country': country,
      if (phone != null) 'phone': phone,
    };
  }
}
