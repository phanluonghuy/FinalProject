import 'package:finalproject/data/models/topic_model.dart';
import 'package:finalproject/data/models/user_model.dart';
import 'package:finalproject/data/repositories/auth_repo.dart';
import 'package:finalproject/data/repositories/topic_repo.dart';
import 'package:finalproject/data/repositories/user_repo.dart';
import 'package:finalproject/reuseable/constants/strings.dart';
import 'package:finalproject/reuseable/constants/text_styles.dart';
import 'package:finalproject/reuseable/widgets/image_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/reuseable/constants/theme.dart';
import 'package:finalproject/features/auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  UserModel? _userInfo;

  @override
  void initState() {
    super.initState();
    // Call the getAllAchievements function when the widget is initialized
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    String uid = _currentUser.uid;
    UserModel? userInfo = await UserRepo().getUserByID(uid);

    setState(() {
      _userInfo = userInfo;
    });
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
              // Action when search icon is tapped
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            _userInfo?.avtUrl ?? '',
                            fit: BoxFit
                                .cover, // Ensure the image covers the container
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _userInfo?.name ?? '',
                        style: AppTextStyles.bold26,
                      ),
                      SizedBox(
                        height: 10,
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
                              Text('achievements', style: AppTextStyles.normal16)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => {},
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
                      ImageItem(imageLocation: 'images/topics.png', title: 'View all topics'),
                      SizedBox(height: 10,),
                      ImageItem(imageLocation: 'images/achievement.png', title: 'View all achievements')
                    ],
                  ),
                ),
              ),
          ),
    );
  }
}
