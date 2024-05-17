import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<String>? followers;
  List<String>? following;

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
    this.followers,
    this.following
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
      // followers: data?['followers'] == null ? null : List<String>.from(data?['followers'].map((x)=>String.fromEnvironment(x)))
      followers: (data?['followers'] as List?)?.cast<String>() ?? [],  // Type-safe casting for followers
      following: (data?['following'] as List?)?.cast<String>() ?? [],  // Type-safe casting for following
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
      if (followers != null) 'followers': followers,  // Fixed typo here
      if (following != null) 'following': following,  // Fixed typo here
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, email: $email, name: $name, bio: $bio, exp: $exp, avatarUrl: $avatarUrl, birthday: $birthday, country: $country, phone: $phone, followers: $followers, following: $following}';
  }
}
