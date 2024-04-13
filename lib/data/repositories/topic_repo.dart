import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/data/models/card_model.dart';
import 'package:finalproject/data/models/topic_model.dart';
import 'package:firebase_core/firebase_core.dart';

class TopicRepo {
  final _db = FirebaseFirestore.instance;

  Future<void> createTopic(TopicModel topic, List<CardModel> cards) async {
    final CollectionReference topicRef = _db.collection('topics');

    // Add the topic to Firestore
    DocumentReference topicDocRef = await topicRef.add(topic.toFirestore());

    // Create a batch operation for adding cards
    WriteBatch batch = _db.batch();

    // Add each card to the "cards" subcollection under the topic
    for (var card in cards) {
      CollectionReference cardsRef = topicDocRef.collection('cards');
      batch.set(cardsRef.doc(), card.toFirestore());
    }

    // Commit the batch operation
    await batch.commit();
  }
}
