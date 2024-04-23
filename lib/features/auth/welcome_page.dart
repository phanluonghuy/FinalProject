import 'package:finalproject/repositories/auth_repo.dart';
import 'package:finalproject/reuseable/constants/strings.dart';
import 'package:finalproject/reuseable/constants/text_styles.dart';
import 'package:finalproject/reuseable/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/reuseable/constants/theme.dart';
import 'package:finalproject/features/auth/login_page.dart';
import 'package:flutter/widgets.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final AuthRepo _auth = AuthRepo();

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
                    MessageBubble(message: AppStrings.hiThere),
                    SizedBox(height: 30),
                    Container(
                      child: Image.asset('images/cat_full.png'),
                      height: 250,
                    ),
                    SizedBox(height: 20),
                    Text(AppStrings.appName,
                        style: AppTextStyles.bold42
                            .copyWith(color: AppTheme.primaryColor)),
                    SizedBox(height: 10),
                    Text(
                      AppStrings.welcomeDescription,
                      style:
                          AppTextStyles.bold20.copyWith(color: AppTheme.grey1),
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
                    _navigateToRegisterPage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(AppStrings.getStarted,
                        style:
                            AppTextStyles.bold16.copyWith(color: Colors.white)),
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
                    backgroundColor: AppTheme.primaryColor2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: BorderSide(color: AppTheme.primaryColor2, width: 0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(AppStrings.iHaveAccount,
                        style: AppTextStyles.bold16
                            .copyWith(color: AppTheme.primaryColor)),
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
    Navigator.pushNamed(context, '/login');
  }

  void _navigateToRegisterPage() {
    Navigator.pushNamed(context, '/register');
  }
}
