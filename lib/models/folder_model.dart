import 'package:cloud_firestore/cloud_firestore.dart';

class FolderModel {
  final String? id;
  final String? ownerID;
  final String? title;
  final DateTime? date;
  final Map<String, bool>? topicIDs;

  FolderModel({
    this.id,
    this.ownerID,
    this.title,
    this.date,
    this.topicIDs,
  });

  factory FolderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) throw Exception("Invalid data in Firestore");
    final Map<String, dynamic> topicIDsData = data['topicIDs'] ?? {};
    final Map<String, bool> topicIDs = Map<String, bool>.from(topicIDsData);
    return FolderModel(
      id: snapshot.id,
      ownerID: data['ownerID'],
      title: data['title'],
      date: (data['date'] as Timestamp).toDate(),
      topicIDs: Map<String, bool>.from(data['topicIDs'] ?? topicIDs),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "ownerID": ownerID,
      "title": title,
      "date": date,
      "topicIDs": topicIDs,
    };
  }
}
