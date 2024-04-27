import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final String? bio;
  final int? exp;
  final String? avatarUrl;
  final DateTime? birthday;
  final String? country;
  final String? phone;

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
      birthday: data?['birthday'],
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
