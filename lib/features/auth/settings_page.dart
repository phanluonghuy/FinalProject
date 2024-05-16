import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
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
                  title: Text("Security", style: AppTextStyles.bold20),
                  onTap: () {},
                  leading: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.backgroundIcon),
                      child: Icon(CupertinoIcons.checkmark_shield_fill,
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
                  onTap: () {},
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
