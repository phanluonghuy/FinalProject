import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  String? id;
  String? term;
  String? definition;
  String? imgUrl;
  bool? star;

  CardModel({this.id, this.term, this.definition, this.imgUrl, this.star});

  factory CardModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) throw Exception("Invalid data in Firestore");
    return CardModel(
      id: snapshot.id,
      term: data['front'],
      definition: data['back'],
      imgUrl: data['imgUrl'],
      star: data['star']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "front": term,
      "back": definition,
      "imgUrl": imgUrl,
      "star": star,
    };
  }
}
