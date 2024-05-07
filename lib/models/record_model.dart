import 'package:cloud_firestore/cloud_firestore.dart';

class RecordModel {
  final String? id;
  final String? userID;
  final num? score;
  final num? time;
  final num? percent;

  RecordModel({this.id, this.userID, this.score, this.time, this.percent});

  factory RecordModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) throw Exception("Invalid data in Firestore");
    return RecordModel(
      id: snapshot.id,
      userID: data['userID'],
      score: data['score'],
      time: data['time'],
      percent: data['percent'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userID": userID,
      "score": score,
      "time": time,
      "percent": percent,
    };
  }
}
