import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/common/constants/strings.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/features/main_menu/home_page.dart';
import 'package:finalproject/features/auth/welcome_page.dart';
import 'package:finalproject/repositories/auth_repo.dart';
import 'package:finalproject/common/widgets/single_choice_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _hidePassword = true;
  bool _rememberPassword = false;
  final AuthRepo _authRepo = AuthRepo();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(AppStrings.welcomeBack, style: AppTextStyles.bold26),
                  SizedBox(
                    height: 50,
                  ),
                  Text(AppStrings.email, style: AppTextStyles.bold16),
                  TextFormField(
                    style: AppTextStyles.bold20,
                    controller: _emailController,
                    cursorColor: AppTheme.primaryColor,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryColor)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryColor)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppStrings.password,
                    style: AppTextStyles.bold16,
                  ),
                  TextFormField(
                    style: AppTextStyles.bold20,
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    cursorColor: AppTheme.primaryColor,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryColor)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryColor)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _hidePassword = !_hidePassword; // Toggle the visibility
                          });
                        },
                        child: Icon(
                          _hidePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Visibility(
                      visible: _isLoading,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                          strokeWidth: 3,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.all(0),
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    ),

                    title: Text("Remember me",style: AppTextStyles.bold20),
                    value: _rememberPassword,
                    onChanged: (newValue) {
                      setState(() {
                        _rememberPassword = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(height: 1),
                  SizedBox(
                    height: 35,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgot');
                      },
                      child: Text(AppStrings.forgotPassword,
                          style: AppTextStyles.bold20
                              .copyWith(color: AppTheme.primaryColor)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ElevatedButton(
                  onPressed: () => {_signIn(context)},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(40), // Rounded corners
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(AppStrings.signIn,
                        style: AppTextStyles.bold16
                            .copyWith(color: Colors.white)),
                  ),
                ),
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _signIn(BuildContext pageContext) async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _authRepo.signInWithEmailAndPassword(email, password);

    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      Navigator.pushNamedAndRemoveUntil(pageContext, '/main', (route) => false);
    } else {
      showDialog(
        context: pageContext,
        builder: (BuildContext context) {
          return const SingleChoiceDialog(
              title: 'Log in unsuccessfully',
              message: 'Your email or password is not correct');
        },
      );
    }
  }
}
