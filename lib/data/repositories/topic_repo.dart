import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/data/models/topic.dart';
import 'package:firebase_core/firebase_core.dart';

class TopicRepo {
  final _db = FirebaseFirestore.instance;

  Future<void> createTopic(Topic topic) async {
    final CollectionReference topicRef = _db.collection('topics');

    await topicRef.add(topic.toFirestore());
  }
}
