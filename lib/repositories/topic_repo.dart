import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/record_model.dart';
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

  Future<TopicModel?> getTopicByID(String topicID) async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _db
        .collection('topics')
        .doc(topicID)
        .get(); // Change the type here to match the correct type

    if (!docSnapshot.exists) {
      // Return null if the document doesn't exist
      return null;
    }

    return TopicModel.fromFirestore(docSnapshot, null);
  } catch (e) {
    // Handle error if any
    print('Error getting topic by ID $topicID: $e');
    throw Exception('Failed to get topic by ID $topicID: $e');
  }
}


  Future<List<TopicModel>> getAllTopics() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('topics')
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Return an empty list if there are no documents
        return [];
      }

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

  Future<void> updateCardStar(String topicId, String cardId, bool star) async {
    try {
      await _db.collection('topics/$topicId/cards')
          .doc(cardId).update({
        'star': star,
      });
    } catch (e) {
      print('Error updating card star $cardId: $e');
      throw Exception('Fail to update card star for $cardId: $e');
    }
  }

  Future<void> addRecord(RecordModel record, String topicId) async {
      final CollectionReference recordRef = _db.collection('topics/$topicId/record');
      await recordRef.add(record.toFirestore());
  }

  Future<List<RecordModel>> getAllRecord(String topicId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('topics/$topicId/record')
          .get();

      final List<RecordModel> records = querySnapshot.docs
          .map((doc) => RecordModel.fromFirestore(doc))
          .toList();

      records.sort((a, b) {
        int scoreComparison = b.score != null && a.score != null ? b.score!.compareTo(a.score!) : 0;
        if (scoreComparison != 0) {
          return scoreComparison;
        }
        return b.time?.compareTo != null?(a.time!.toInt()): 0;
      });



      return records;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  Future<List<CardModel>> getCardsByStar(String topicId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('topics/$topicId/cards')
          .where('star', isEqualTo: true)
          .get();

      final List<CardModel> cards = querySnapshot.docs
          .map((doc) => CardModel.fromFirestore(doc))
          .toList();

      return cards;
    } catch (e) {
      print('Error getting cards by star for topic $topicId: $e');
      throw Exception('Failed to get cards by star for topic $topicId: $e');
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
