import 'package:cloud_firestore/cloud_firestore.dart';

class Achievement {
  final String? id;
  final String? title;
  final String? description;
  final int? exp;
  final String? imgUrl;

  Achievement({this.id, this.title, this.description, this.exp, this.imgUrl});

  factory Achievement.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Achievement(
        id: snapshot.id,
        title: data?['title'],
        description: data?['description'],
        exp: data?['exp'],
        imgUrl: data?['imgUrl']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (exp != null) 'exp': exp,
      if (imgUrl != null) 'imgUrl': imgUrl,
    };
  }
}
