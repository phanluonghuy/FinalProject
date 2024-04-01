import 'package:finalproject/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/components/custom_colors.dart';
import 'package:finalproject/pages/login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final AuthService _auth = AuthService();

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
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: CustomColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Learn vocabulary, quiz,... anywhere and anytime. Fast, free and forever.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: CustomColors.grayColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10), // Reduce vertical margin here
                child: ElevatedButton(
                  onPressed: () {
                    // Add your button onPressed logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "GET STARTED",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10), // Reduce vertical margin here
                child: ElevatedButton(
                  onPressed: () {
                    // Add your button onPressed logic here
                    _navigateToLoginPage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: BorderSide(
                          color: CustomColors.primaryColor2, width: 0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "I ALREADY HAVE AN ACCOUNT",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: CustomColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLoginPage() {
    Navigator.pushNamed(
        context, '/login');
  }
}
