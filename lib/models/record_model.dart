import 'package:cloud_firestore/cloud_firestore.dart';

class RecordModel {
  final String? id;
  final String? userID;
  final int? score;
  final int? time;

  RecordModel({this.id, this.userID, this.score, this.time});

  factory RecordModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) throw Exception("Invalid data in Firestore");
    return RecordModel(
      id: snapshot.id,
      userID: data['userID'],
      score: data['score'],
      time: data['time'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userID": userID,
      "score": score,
      "time": time,
    };
  }
}
