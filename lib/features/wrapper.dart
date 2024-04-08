import 'package:finalproject/features/main_menu/home_page.dart';
import 'package:finalproject/features/main_menu/main_page.dart';
import 'package:finalproject/features/auth/welcome_page.dart';
import 'package:finalproject/data/repositories/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainPage();
          } else {
            return const WelcomePage();
          }
        },
      ),
    );
  }
}
