import 'package:finalproject/data/repositories/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/reuseable/themes/app_theme.dart';
import 'package:finalproject/features/auth/login_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final AuthRepo _auth = AuthRepo();
  final currentUser = FirebaseAuth.instance.currentUser!;

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                    Text(
                      "Triolingo",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "This is your library",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: AppTheme.grey1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    MaterialButton(
                      onPressed: logOut,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text('Log out'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logOut() async {
    _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/welcome', ((route) => false));
  }
}
