import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/data/models/achievement.dart';
import 'package:finalproject/data/models/topic.dart';
import 'package:firebase_core/firebase_core.dart';

class AchievementRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> createAchievement(Achievement achievement) async {
    try {
      await _db.collection('achievements').add(achievement.toFirestore());
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<Achievement>> getAllAchievements() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('achievements')
          .get(); // Change the type here to match the correct type

      final List<Achievement> achievements = querySnapshot.docs
          .map((doc) => Achievement.fromFirestore(doc, null))
          .toList();

      return achievements;
    } catch (e) {
      // Handle error
      print('Error: $e');
      return [];
    }
  }
}
