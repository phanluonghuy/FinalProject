import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalproject/common/widgets/Toast_widget.dart';
import 'package:finalproject/models/image_helper.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/auth_repo.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:finalproject/common/constants/strings.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/widgets/image_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/features/auth/login_page.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  final _userRepo = UserRepo();
  final _imageHelper = ImageHelper();
  UserModel? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<String> _loadUserInfo() async {
    String uid = _currentUser.uid;
    UserModel? userInfo = await UserRepo().getUserByID(uid);
    setState(() {
      _userInfo = userInfo;
    });

    return _userInfo?.avatarUrl ?? "";
  }

  Widget _getBadge(int exp) {
    {
      String rank = '5';
      switch (exp) {
        case < 10 :
          rank = '1';
          break;
        case < 50:
          rank = '2';
          break;
        case < 100:
          rank = '3';
          break;
        case < 200:
          rank = '4';
          break;
        default:
          rank = '5';
      }
      return Image.asset('images/rank_$rank.png',
      height: 35);
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
            Container(
              child: Image.asset('images/cat_face.png'),
              height: 60,
            ),
            Text('Profile', // Title
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
              Navigator.pushNamed(context, '/settings');
            },
            color: Colors.black,
          )
        ],
      ),
      body: _userInfo == null
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
                                      child: LoadingAnimationWidget
                                          .twoRotatingArc(
                                              color: AppTheme.primaryColor,
                                              size: 30),
                                    );
                                  }
                                },
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: InkWell(
                                  onTap: () async {
                                    XFile? _file =
                                        await _imageHelper.pickImage();
                                    if (_file == null ? false : true) {
                                      CroppedFile? cropFile =
                                          await _imageHelper.crop(file: _file);
                                      if (cropFile != null) {
                                        File croppedFile = File(cropFile.path);
                                        _userRepo.uploadAvatar(
                                            croppedFile, context);
                                        _loadUserInfo();
                                      } else {
                                        Toast.uploadAvatarFailed(context);
                                      }
                                    } else {
                                      //Toast.uploadAvatarFailed(context);
                                    }
                                  },
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(Icons.mode_edit,
                                              color: Colors.white, size: 25),
                                        )),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            60,
                                          ),
                                        ),
                                        color: AppTheme.primaryColor,
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(2, 4),
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 3,
                                          ),
                                        ]),
                                  ),
                                ),
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
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 15,),
                                _getBadge(_userInfo?.exp ?? 0),
                                SizedBox(width: 10,),
                                Column(
                                  children: [
                                    Text( _userInfo?.exp.toString() ?? '0', style: AppTextStyles.bold20),
                                    Text('exp',
                                        style: AppTextStyles.normal16)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: AppTheme.grey4,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(_userInfo?.followers?.length.toString() ?? "0", style: AppTextStyles.bold20),
                                Text('followers', style: AppTextStyles.normal16)
                              ],
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: AppTheme.grey4,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(_userInfo?.following?.length.toString() ?? "0", style: AppTextStyles.bold20),
                                Text('following',
                                    style: AppTextStyles.normal16)
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/editProfile');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(40), // Rounded corners
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(AppStrings.editProfile,
                                    style: AppTextStyles.bold16
                                        .copyWith(color: Colors.white)),
                                SizedBox(
                                  width: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ImageItem(
                          imageLocation: 'images/topics.png',
                          title: 'View all topics'),
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
  }
}
