import 'package:email_otp/email_otp.dart';
import 'package:finalproject/common/widgets/Toast_widget.dart';
import 'package:finalproject/common/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:country_icons/country_icons.dart';
import 'package:finalproject/common/constants/strings.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/single_choice_dialog.dart';
import 'package:finalproject/repositories/auth_repo.dart';
import 'package:finalproject/reuseable/constants/WidgetStyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _authRepo = AuthRepo();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  EmailOTP myAuth = EmailOTP();

  int _currentStep = 0;

  void validateAndContinue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void sendVerifyLink() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text);
  }
  void sendOTP() async {
    if (_formKey.currentState!.validate()) {
      myAuth.setConfig(
          appEmail: "contact@triolingo.com",
          appName: "Triolingo OTP",
          userEmail: _emailController.text,
          otpLength: 4,
          otpType: OTPType.digitsOnly);
      if (await myAuth.sendOTP() == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("OTP has been sent"),
        ));
        setState(() {
          _currentStep++;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Oops, OTP send failed"),
        ));
      }
    }
  }

  void verifyOTP(String otp) async {
    if (await myAuth.verifyOTP(otp: otp) == true) {
      setState(() {
        _currentStep++;
      });
    } else {
      Toast.wrongOTP(context);
    }
  }

  void updatePassword() {}

  bool isNumeric(String str) {
    return RegExp(r'^-?[0-9]+$').hasMatch(str);
  }

  List<Widget> getSteps() {
    return [
      Form(
        key: _formKey,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Forgot Password 🔑", style: AppTextStyles.bold20),
                SizedBox(height: 10),
                Text(
                    "Enter your emaill address to get an link to reset your password.",
                    style: AppTextStyles.normal16),
                SizedBox(height: 20),
                TextFormField(
                  style: AppTextStyles.bold16,
                  controller: _emailController,
                  cursorColor: AppTheme.primaryColor,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (!emailValid) {
                      return "Check your email address";
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Your email",
                    hintStyle: AppTextStyles.bold16,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor)),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: AppTheme.primaryColor),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sendVerifyLink();
                      setState(() {
                        _currentStep++;
                      });
                    }
                  },
                  child: Text("Countinue",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MessageBubble(message: "Open your ${_emailController.text} to reset your 🔑"),
              SizedBox(height: 50),
              Container(
                child: Image.asset('images/cat_full.png'),
                height: 250,
              ),
              SizedBox(height: 30),
              Text("Welcome back!",
                  style: AppTextStyles.title),
              SizedBox(height: 20,),
              Text("You have received an email to reset your password.",
                  style: AppTextStyles.normal16,textAlign: TextAlign.center,),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: AppTheme.primaryColor),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
                }, child: Text("CONTINUE TO HOME",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 18)),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    ];
  }

  PageController controller = PageController(initialPage: 0, keepPage: true);

  Widget _pageViewItems(int index) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Expanded(child: getSteps().elementAt(index)),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: PageView(
          key: ValueKey<int>(_currentStep),
          controller: controller,
          scrollDirection: Axis.horizontal,
          onPageChanged: (idx) {
            setState(() {
              _currentStep = idx;
            });
          },
          children: getSteps().asMap().entries.map((entry) {
            return _pageViewItems(_currentStep);
          }).toList(),
        ),
      ),
    );
  }

}
