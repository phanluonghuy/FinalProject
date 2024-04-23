import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:firebase_core/firebase_core.dart';

class TopicRepo {
  final _db = FirebaseFirestore.instance;

  Future<void> createTopic(TopicModel topic, List<CardModel> cards) async {
    final CollectionReference topicRef = _db.collection('topics');

    DocumentReference topicDocRef = await topicRef.add(topic.toFirestore());
    WriteBatch batch = _db.batch();
    for (var card in cards) {
      CollectionReference cardsRef = topicDocRef.collection('cards');
      batch.set(cardsRef.doc(), card.toFirestore());
    }
    await batch.commit();
  }

  Future<List<TopicModel>> getAllTopics() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('topics')
          .get(); // Change the type here to match the correct type

      final List<TopicModel> topics = querySnapshot.docs
          .map((doc) => TopicModel.fromFirestore(doc, null))
          .toList();

      return topics;
    } catch (e) {
      // Handle error if any
      print('Error getting all topics: $e');
      throw Exception('Failed to get all topics: $e');
    }
  }

  Future<List<TopicModel>> getAllTopicsByOwnerID(String ownerID) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('topics')
          .where('ownerID', isEqualTo: ownerID)
          .get();

      final List<TopicModel> topics = querySnapshot.docs
          .map((doc) => TopicModel.fromFirestore(doc, null))
          .toList();

      return topics;
    } catch (e) {
      // Handle error if any
      print('Error getting topics by ownerID: $e');
      throw Exception('Failed to get topics by ownerID: $e');
    }
  }

  Future<List<CardModel>> getAllCardsForTopic(String topicId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('topics/$topicId/cards')
          .get(); // Change the type here to match the correct type

      final List<CardModel> cards = querySnapshot.docs
          .map((doc) => CardModel.fromFirestore(doc))
          .toList();

      return cards;
    } catch (e) {
      // Handle error if any
      print('Error getting all cards for topic $topicId: $e');
      throw Exception('Failed to get all cards for topic $topicId: $e');
    }
  }
}
