import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/widgets/Toast_widget.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:image_cropper/image_cropper.dart';

class UserRepo {
  final _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _storageRef = FirebaseStorage.instance.ref();

  Future<void> createUserWithUID(UserModel user, String? uid) async {
    try {
      await _db.collection('users').doc(uid).set(user.toFirestore());
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<UserModel?> getUserByID(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _db.collection('users').doc(uid).get();

      if (userDoc.exists) {
        UserModel user = UserModel.fromFirestore(userDoc, null);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }

  Future<void> uploadAvatar(File file, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final width = MediaQuery.of(context).size.width * 0.3;
        return Padding(
          padding: EdgeInsets.only(left: width, right: width),
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 100,
          ),
        );
      },
    );

    String userId = _auth.currentUser?.uid ?? "";
    final avatarImgRef = _storageRef.child("avatars/$userId");
    try {
      avatarImgRef.putFile(file).whenComplete(() async {
        var downloadUrl = await avatarImgRef.getDownloadURL();
        var collection = _db.collection('users');
        collection.doc(userId).update({'avatarUrl': downloadUrl});
      });
      Navigator.pop(context);
      Toast.uploadAvatarSuccess(context);
    } on FirebaseException catch (e) {
      Toast.uploadAvatarFailed(context);
      print(e);
    }
  }
}
