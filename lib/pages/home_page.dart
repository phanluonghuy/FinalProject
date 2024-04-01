import 'package:finalproject/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/components/custom_colors.dart';
import 'package:finalproject/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  final currentUser = FirebaseAuth.instance.currentUser!;

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
                        color: CustomColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "This is the homescreen",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: CustomColors.grayColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Your email is ${currentUser.email}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: CustomColors.grayColor,
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
  }
}
