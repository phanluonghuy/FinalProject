import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/data/models/achievement_model.dart';
import 'package:finalproject/data/models/topic_model.dart';
import 'package:firebase_core/firebase_core.dart';

class AchievementRepo {
  final _db = FirebaseFirestore.instance;

  Future<void> createAchievement(AchievementModel achievement) async {
    try {
      await _db.collection('achievements').add(achievement.toFirestore());
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<AchievementModel>> getAllAchievements() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('achievements')
          .get(); // Change the type here to match the correct type

      final List<AchievementModel> achievements = querySnapshot.docs
          .map((doc) => AchievementModel.fromFirestore(doc, null))
          .toList();

      return achievements;
    } catch (e) {
      // Handle error
      print('Error: $e');
      return [];
    }
  }
}
