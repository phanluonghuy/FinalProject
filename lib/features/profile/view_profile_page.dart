import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalproject/common/constants/strings.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/Toast_widget.dart';
import 'package:finalproject/common/widgets/image_item.dart';
import 'package:finalproject/features/profile/user_topics_page.dart';
import 'package:finalproject/models/image_helper.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ViewProfilePage extends StatefulWidget {
  String userID;
  ViewProfilePage({required this.userID, super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {

  final _currentUser = FirebaseAuth.instance.currentUser!;
  // UserModel? _userInfo;
  bool _isLoadingUser = true;
  UserRepo _userRepo = UserRepo();
  UserModel? _user;
  UserModel? _userFollow;
  bool _following = false;
  Future<UserModel?>? _userFollowFuture;

  @override
  void initState() {
    super.initState();
    _initializeData();

  }

  Future<void> _initializeData() async {
    try{
      String uid = widget.userID;
      _user = await _userRepo.getUserByID(_currentUser.uid);
      _userFollow = await _userRepo.getUserByID(uid);
      _isLoadingUser = false;
      if (_user?.following!.contains(uid) ?? false) {
          _following = true;
      }
      if (mounted) {
        setState(() {});
      }

    }catch(e) {
      print('Error initializing data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            // Text('${_userInfo?.name}\'s profile',
            Text('${_userFollow?.name}\'s profile',
                style: AppTextStyles.bold20),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              size: 30,
            ), // Action icon
            onPressed: () {
              //setting
            },
            color: Colors.black,
          )
        ],
      ),
      body: _isLoadingUser
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 150, // Specify the desired height
                          width: 150,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: _userFollow?.avatarUrl ?? '',
                                  imageBuilder:
                                      (context, imageProvider) =>
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                  placeholder: (context, url) => Center(
                                      child: LoadingAnimationWidget
                                          .fourRotatingDots(
                                          color:
                                          AppTheme.primaryColor,
                                          size: 30)),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              )

                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _userFollow?.name ?? '',
                        style: AppTextStyles.bold26,
                      ),
                      Text(
                        // _userInfo?.bio ?? '',
                        _userFollow?.bio ?? '',
                        style: AppTextStyles.normal16,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: AppTheme.grey4,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('12', style: AppTextStyles.bold20),
                              Text('active streaks',
                                  style: AppTextStyles.normal16)
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: AppTheme.grey4,
                          ),
                          Column(
                            children: [
                              Text(_userFollow?.followers?.length.toString() ?? "0", style: AppTextStyles.bold20),
                              Text('followers', style: AppTextStyles.normal16)
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: AppTheme.grey4,
                          ),
                          Column(
                            children: [
                              Text(_userFollow?.following?.length.toString() ?? "0", style: AppTextStyles.bold20),
                              Text('following',
                                  style: AppTextStyles.normal16)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      (_currentUser.uid != widget.userID)
                          ? Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_following) {
                                    _user?.following?.remove(widget.userID);
                                    _userFollow?.followers?.remove(_user?.id ?? "");
                                  }
                                  else {
                                    _user?.following?.add(widget.userID);
                                    _userFollow?.followers?.add(_user?.id ?? "");

                                  }
                                  _userRepo.following(_user!, _userFollow!);
                                  setState(() {
                                    _following = !_following;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        40), // Rounded corners
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      (_following) ?  Icon(
                                        Icons.people,
                                        size: 20,
                                        color: Colors.white,
                                      ) : Icon(
                                        Icons.add_alert,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      (_following) ? Text('Following',
                                          style: AppTextStyles.bold16
                                              .copyWith(color: Colors.white)) :
                                      Text('Follow',
                                          style: AppTextStyles.bold16
                                              .copyWith(color: Colors.white)),
                                      SizedBox(
                                        width: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserTopicsPage(
                                  userID: widget
                                      .userID), // Pass the user object to ViewProfilePage
                            ),
                          );
                        },
                        child: ImageItem(
                          imageLocation: 'images/topics.png',
                          title: 'View all topics',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ImageItem(
                          imageLocation: 'images/achievement.png',
                          title: 'View all achievements')
                    ],
                  ),
                ),
              ),
            ),
    );
    ;
  }
}
