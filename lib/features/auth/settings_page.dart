import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: AppTextStyles.bold20),
      ),
      body: Padding(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              ListTile(
                  title: Text("Personal Info", style: AppTextStyles.bold20),
                  onTap: () {},
                  leading: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.backgroundIcon),
                      child: Icon(CupertinoIcons.person_fill,
                          color: Colors.amber)),
                  trailing: Icon(CupertinoIcons.right_chevron)),
              SizedBox(height: 20),
              ListTile(
                  title: Text("Notification", style: AppTextStyles.bold20),
                  onTap: () {},
                  leading: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.backgroundIcon),
                      child: Icon(Icons.notifications_rounded,
                          color: Colors.redAccent)),
                  trailing: Icon(CupertinoIcons.right_chevron)),
              SizedBox(height: 20),
              ListTile(
                  title: Text("Gerenal", style: AppTextStyles.bold20),
                  onTap: () {},
                  leading: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.backgroundIcon),
                      child: Icon(CupertinoIcons.rectangle_on_rectangle,
                          color: Colors.deepPurple)),
                  trailing: Icon(CupertinoIcons.right_chevron)),
              SizedBox(height: 20),
              ListTile(
                  title: Text("Accessibility", style: AppTextStyles.bold20),
                  onTap: () {},
                  leading: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.backgroundIcon),
                      child: Icon(CupertinoIcons.compass_fill,
                          color: Colors.amber)),
                  trailing: Icon(CupertinoIcons.right_chevron)),
              SizedBox(height: 20),
              ListTile(
                  title: Text("Change Password", style: AppTextStyles.bold20),
                  onTap: () {
                    Navigator.pushNamed(context, '/changePassword');
                  },
                  leading: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.backgroundIcon),
                      child: Icon(Icons.password,
                          color: Colors.green)),
                  trailing: Icon(CupertinoIcons.right_chevron)),
              SizedBox(height: 20),
              ListTile(
                  title: Text("Find Friends", style: AppTextStyles.bold20),
                  onTap: () {},
                  leading: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.backgroundIcon),
                      child: Icon(CupertinoIcons.person_2_fill,
                          color: Colors.amber)),
                  trailing: Icon(CupertinoIcons.right_chevron)),
              SizedBox(height: 20),
              ListTile(
                  title: Text("Help Center", style: AppTextStyles.bold20),
                  onTap: () {},
                  leading: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.backgroundIcon),
                      child: Icon(Icons.help_center,
                          color: Colors.green)),
                  trailing: Icon(CupertinoIcons.right_chevron)),
              SizedBox(height: 20),
              ListTile(
                  title: Text("About", style: AppTextStyles.bold20),
                  onTap: () {},
                  leading: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.backgroundIcon),
                      child: Icon(CupertinoIcons.square_pencil_fill ,
                          color: Colors.deepPurple)),
                  trailing: Icon(CupertinoIcons.right_chevron)),
              SizedBox(height: 20),
              ListTile(
                  title: Text("Logout", style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  )),
                  onTap: () async {
                    showModalBottomSheet(context: context, builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height/3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                        child: Column(
                          children: [
                            Text("Logout",style: AppTextStyles.bold26.copyWith(color: Colors.red)),
                            SizedBox(height: 20,),
                            Divider(height: 1,),
                            SizedBox(height: 20,),
                            Text("Are you sure you want to log out?",style: AppTextStyles.bold20,),
                            SizedBox(height: 30,),
                            Row(
                              children: [
                                Expanded(child: ElevatedButton(
                                  onPressed: () => {
                                    Navigator.pop(context)
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40), // Rounded corners
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Cancel",
                                        style:
                                        AppTextStyles.bold16.copyWith(color: AppTheme.primaryColor)),
                                  ),
                                )),
                                SizedBox(width: 15,),
                                Expanded(child: ElevatedButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pushNamedAndRemoveUntil(context, '/welcome', ((route) => false));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40), // Rounded corners
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Yes, Logout",
                                        style:
                                        AppTextStyles.bold16.copyWith(color: Colors.white)),
                                  ),
                                ))
                              ],
                            )
                          ],
                        ),
                      );
                    });

                  },
                  leading: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.backgroundIcon),
                      child: Icon(Icons.logout ,
                          color: Colors.red)),),
              SizedBox(height: 20),
            ],
          )),
    );
  }
}
