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
  final _userRepo = UserRepo();
  final _imageHelper = ImageHelper();

  final _currentUser = FirebaseAuth.instance.currentUser!;
  UserModel? _userInfo;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<String> _loadUserInfo() async {
    String uid = widget.userID;
    UserModel? userInfo = await UserRepo().getUserByID(uid);
    setState(() {
      _userInfo = userInfo;
      _isLoadingUser = false;
    });

    return _userInfo?.avatarUrl ?? "";
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
            Text('${_userInfo?.name}\'s profile', // Title
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
                              FutureBuilder<String>(
                                future: _loadUserInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data ?? "",
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
                                    );
                                  } else {
                                    return Center(
                                      child:
                                          LoadingAnimationWidget.twoRotatingArc(
                                              color: AppTheme.primaryColor,
                                              size: 30),
                                    );
                                  }
                                },
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _userInfo?.name ?? '',
                        style: AppTextStyles.bold26,
                      ),
                      Text(
                        _userInfo?.bio ?? '',
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
                              Text('23', style: AppTextStyles.bold20),
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
                              Text('25', style: AppTextStyles.bold20),
                              Text('achievements',
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
                                onPressed: () {
                                  //follow
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
                                      Icon(
                                        Icons.add_alert,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
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
