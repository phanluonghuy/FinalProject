import 'dart:async';

import 'package:animated_snack_bar/animated_snack_bar.dart';
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

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isLoading = false;
  bool _hideCurrentPassword = true;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  final AuthRepo _authRepo = AuthRepo();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(AppStrings.changePassword,
                        style: AppTextStyles.bold26),
                    SizedBox(
                      height: 50,
                    ),
                    Text("Current Password", style: AppTextStyles.bold16),
                    TextFormField(
                      style: AppTextStyles.bold20,
                      controller: _currentPasswordController,
                      obscureText: _hideCurrentPassword,
                      cursorColor: AppTheme.primaryColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 6) {
                          return "Password must be least 6 characters";
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: AppTheme.primaryColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: AppTheme.primaryColor)),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _hideCurrentPassword =
                              !_hideCurrentPassword; // Toggle the visibility
                            });
                          },
                          child: Icon(
                            _hideCurrentPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppTheme.primaryColor,
                          ),
                        ),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 6) {
                          return "Password must be least 6 characters";
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor)),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _hidePassword =
                                  !_hidePassword; // Toggle the visibility
                            });
                          },
                          child: Icon(
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Confirm Password",
                      style: AppTextStyles.bold16,
                    ),
                    TextFormField(
                      style: AppTextStyles.bold20,
                      controller: _confirmPasswordController,
                      obscureText: _hideConfirmPassword,
                      cursorColor: AppTheme.primaryColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 6) {
                          return "Password must be least 6 characters";
                        }
                        if (_passwordController.text != value) {
                          return "Password does not match";
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor)),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _hideConfirmPassword =
                                  !_hideConfirmPassword; // Toggle the visibility
                            });
                          },
                          child: Icon(
                            _hideConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Visibility(
                        visible: _isLoading,
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor),
                            strokeWidth: 3,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ElevatedButton(
                onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {_changePassword(context)}
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
                  child: Text("CHANGE PASSWORD",
                      style:
                          AppTextStyles.bold16.copyWith(color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _changePassword(BuildContext pageContext) async {
    setState(() {
      _isLoading = true;
    });

    String currentPassword = _currentPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    bool success =
        await _authRepo.changePassword(currentPassword, confirmPassword);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      AnimatedSnackBar.rectangle(
        'Success',
        'Change password successful',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.dark,
      ).show(context);
      Future.delayed(Duration(milliseconds: 2000), () {
        Navigator.pushNamedAndRemoveUntil(
            pageContext, '/main', (route) => false);
      });
    } else {
      AnimatedSnackBar.rectangle(
        'Error',
        'Your password is wrong',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.dark,
      ).show(context);
    }
  }
}
