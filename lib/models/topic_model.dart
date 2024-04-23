import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/record_model.dart';

class TopicModel {
  final String? id;
  final String? title;
  final String? description;
  final String? ownerID;
  final bool? isPublic;
  final DateTime? date;

  TopicModel({
    this.id,
    this.title,
    this.description,
    this.ownerID,
    this.isPublic, // Added isPublic field
    this.date,
  });

  factory TopicModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) throw Exception("Invalid data in Firestore");
    return TopicModel(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      ownerID: data['ownerID'],
      isPublic: data['isPublic'], // Initialize isPublic field
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "description": description,
      "ownerID": ownerID,
      "isPublic": isPublic, // Add isPublic field to Firestore data
      "date": date,
    };
  }

  // Example method to fetch cards associated with this topic
  Future<List<CardModel>> getCards() async {
    final cardsQuerySnapshot =
        await FirebaseFirestore.instance.collection('topics/$id/cards').get();
    return cardsQuerySnapshot.docs
        .map((doc) => CardModel.fromFirestore(doc))
        .toList();
  }

  // Example method to fetch records associated with this topic
  Future<List<RecordModel>> getRecords() async {
    final recordsQuerySnapshot =
        await FirebaseFirestore.instance.collection('topics/$id/records').get();
    return recordsQuerySnapshot.docs
        .map((doc) => RecordModel.fromFirestore(doc))
        .toList();
  }
}
