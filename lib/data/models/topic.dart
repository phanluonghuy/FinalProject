import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  final String? title;
  final String? description;
  
  Topic({
    this.title,
    this.description
  });

  factory Topic.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Topic(
      title: data?['title'],
      description: data?['description'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (description != null) "description": description,
    };
  }
}