import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/folder_model.dart';
import 'package:finalproject/models/topic_model.dart';

class FolderRepo {
  final _db = FirebaseFirestore.instance;

  Future<FolderModel?> getFolderByID(String folderID) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> folderSnapshot = await _db
          .collection('folders')
          .doc(folderID)
          .get() as DocumentSnapshot<Map<String, dynamic>>;

      if (!folderSnapshot.exists) {
        // Return null if the folder doesn't exist
        return null;
      }

      // Convert the folder snapshot to a FolderModel instance
      FolderModel folder = FolderModel.fromFirestore(folderSnapshot, null);
      return folder;
    } catch (e) {
      print('Error getting folder by ID: $e');
      throw Exception('Failed to get folder by ID: $e');
    }
  }

  Future<void> createFolder(FolderModel folder) async {
    try {
      await _db.collection('folders').add(folder.toFirestore());
    } catch (e) {
      print('Error creating folder: $e');
    }
  }

  Future<List<FolderModel>> getAllFoldersOfOwnerID(String ownerID) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('folders')
          .where('ownerID', isEqualTo: ownerID)
          .get();

      final List<FolderModel> topics = querySnapshot.docs
          .map((doc) => FolderModel.fromFirestore(doc, null))
          .toList();

      return topics;
    } catch (e) {
      // Handle error if any
      print('Error getting topics by ownerID: $e');
      throw Exception('Failed to get topics by ownerID: $e');
    }
  }

  Future<void> updateTopicInFolder(
      String folderID, String topicID, bool value) async {
    try {
      final DocumentReference folderRef =
          _db.collection('folders').doc(folderID);

      // Get the current folder document
      final DocumentSnapshot<Map<String, dynamic>> folderSnapshot =
          await folderRef.get() as DocumentSnapshot<Map<String, dynamic>>;

      if (!folderSnapshot.exists) {
        throw Exception('Folder with ID $folderID does not exist');
      }

      // Get the current topicIDs map from the folder document data
      final Map<String, dynamic>? topicIDsData =
          folderSnapshot.data()?['topicIDs'];
      Map<String, dynamic> updatedTopicIDs = topicIDsData ?? {};

      // Update the value of the specified topicID in the map
      updatedTopicIDs[topicID] = value;

      // Update the folder document with the modified topicIDs map
      await folderRef.update({'topicIDs': updatedTopicIDs});
    } catch (e) {
      print('Error updating topic in folder: $e');
      throw Exception('Failed to update topic in folder: $e');
    }
  }

  Future<void> deleteFolderByID(String folderID) async {
    try {
      final DocumentReference folderRef =
          _db.collection('folders').doc(folderID);

      // Check if the folder exists
      final DocumentSnapshot<Map<String, dynamic>> folderSnapshot =
          await folderRef.get() as DocumentSnapshot<Map<String, dynamic>>;

      if (!folderSnapshot.exists) {
        throw Exception('Folder with ID $folderID does not exist');
      }

      // Delete the folder document
      await folderRef.delete();
    } catch (e) {
      print('Error deleting folder: $e');
      throw Exception('Failed to delete folder: $e');
    }
  }
}
