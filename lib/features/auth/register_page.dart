import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_icons/country_icons.dart';
import 'package:email_otp/email_otp.dart';
import 'package:finalproject/common/constants/strings.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/Toast_widget.dart';
import 'package:finalproject/common/widgets/single_choice_dialog.dart';
import 'package:finalproject/repositories/auth_repo.dart';
import 'package:finalproject/reuseable/constants/WidgetStyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authRepo = AuthRepo();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  final _birthdayController = TextEditingController();
  final _countryController = TextEditingController();

  EmailOTP myAuth = EmailOTP();
  bool password = true;
  bool confirmPassword = true;
  int _indexCountry = -1;
  int _currentStep = 0;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  Future<bool> checkEmailExits() async {
    var query = FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: _emailController.text).limit(1);
    var querySnapshot = await query.get();
    return querySnapshot.docs.isNotEmpty;
  }

  void validateAndContinue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep++;
      });
    }
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Oops, OTP send failed"),
        ));
      }
    }
  }

  void verifyOTP(String otp) async {
    if (await myAuth.verifyOTP(otp: otp) == true ) {
      setState(() {
        _currentStep++;
      });

    } else {
      Toast.wrongOTP(context);
    }
  }

  bool isNumeric(String str) {
    return RegExp(r'^-?[0-9]+$').hasMatch(str);
  }

  void _selectCountry() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ScrollablePositionedList.builder(
        itemCount: countryList.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(countryList.elementAt(index).name,
              style: AppTextStyles.normal16),
          leading: SizedBox(
              height: 25,
              width: 25,
              child: CountryIcons.getSvgFlag(
                  countryList.elementAt(index).isoCode)),
          // leading: Icon(Icons.add),
          onTap: () {
            setState(() {
              _indexCountry = index;
              _countryController.text = countryList.elementAt(index).name;
            });
            Navigator.pop(context);
          },
          trailing: (index == _indexCountry)
              ? Icon(Icons.check, color: Colors.green)
              : null,
        ),
        itemScrollController: itemScrollController,
        scrollOffsetController: scrollOffsetController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetListener: scrollOffsetListener,
        initialScrollIndex: (_indexCountry - 2 < 0) ? 0 : _indexCountry - 2,
      ),
    );
  }

  void _selectBirthday() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2025),
    ).whenComplete(() => {});
    if (pickedDate != null) {
      int day = pickedDate.day;
      int month = pickedDate.month;
      int year = pickedDate.year;
      String formattedDate =
          '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      _birthdayController.text = formattedDate;
    }
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
                Text("What is your email address ? 📩",
                    style: AppTextStyles.bold20),
                SizedBox(height: 10),
                Text(
                    "Enter your email address to get an OTP code to verify your email.",
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        // _isLoading = true; // Activate loading indicator
                      });

                      // Check if the email exists
                      var check = await checkEmailExits();

                      setState(() {
                        // _isLoading = false; // Deactivate loading indicator

                        if (check) { // If the email exists
                          // Show error message: Email already in use
                          Toast.emailExits(context);
                        } else {
                          sendOTP();
                          _currentStep++; // Proceed to the next step
                        }
                      });
                    }

                  },
                  child: Text("Continue",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("You've got mail 📩", style: AppTextStyles.bold20),
            SizedBox(height: 10),
            Text(
                "We have sent OTP verification code to your email address. Check your email and enter the code below",
                style: AppTextStyles.normal16),
            SizedBox(height: 20),
            OtpTextField(
              numberOfFields: 4,
              borderColor: AppTheme.primaryColor,
              fillColor: AppTheme.primaryColor2,
              fieldWidth: 70,
              textStyle: AppTextStyles.bold20,
              showFieldAsBox: true,
              onCodeChanged: (String code) {},
              keyboardType: TextInputType.number,
              onSubmit: (String verificationCode)  {
                if (!isNumeric(verificationCode)) {
                  Toast.wrongFormatInt(context);
                  return;
                }
                verifyOTP(verificationCode);
              }, // end onSubmit
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              child: Text("Back",
                  style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
      Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("What is your name ?", style: AppTextStyles.bold20),
              TextFormField(
                style: AppTextStyles.bold16,
                controller: _usernameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: AppTheme.primaryColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your full name";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Full name",
                  hintStyle: AppTextStyles.bold16,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor)),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                      child: Text("Back",
                          style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: AppTheme.primaryColor),
                      onPressed: validateAndContinue,
                      child: Text("Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
      Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create a password", style: AppTextStyles.bold20),
              TextFormField(
                style: AppTextStyles.bold16,
                controller: _passwordController,
                cursorColor: AppTheme.primaryColor,
                obscureText: password,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  if (value.length < 6) {
                    return "Password must be least 6 characters";
                  }
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: AppTextStyles.bold16,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        password = !password;
                      });
                    },
                    icon: Icon(
                      password ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor)),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                style: AppTextStyles.bold16,
                controller: _password2Controller,
                cursorColor: AppTheme.primaryColor,
                obscureText: confirmPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  if (value.length < 6) {
                    return "Password must be least 6 characters";
                  }
                  if (value.compareTo(_passwordController.text)!=0) {
                    return "Confirm password doesn't match";
                  }
                },
                decoration: InputDecoration(
                  hintText: "Confirm password",
                  hintStyle: AppTextStyles.bold16,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        confirmPassword = !confirmPassword;
                      });
                    },
                    icon: Icon(
                      confirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor)),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                      child: Text("Back",
                          style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: AppTheme.primaryColor),
                      onPressed: validateAndContinue,
                      child: Text("Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
      Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("What is your birthday ?", style: AppTextStyles.bold20),
              TextFormField(
                style: AppTextStyles.bold16,
                controller: _birthdayController,
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select your birthday";
                  }
                },
                onTap: () {
                  _selectBirthday();
                },
                cursorColor: AppTheme.primaryColor,
                decoration: const InputDecoration(
                  hintText: "Your birthday",
                  suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                  hintStyle: AppTextStyles.bold16,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor)),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                      child: Text("Back",
                          style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: AppTheme.primaryColor),
                      onPressed: validateAndContinue,
                      child: Text("Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
      Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Where do you from ?", style: AppTextStyles.bold20),
              TextFormField(
                style: AppTextStyles.bold16,
                controller: _countryController,
                cursorColor: AppTheme.primaryColor,
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select your country";
                  }
                },
                onTap: () {
                  _selectCountry();
                },
                decoration: const InputDecoration(
                  hintText: "Your country",
                  hintStyle: AppTextStyles.bold16,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor)),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                      child: Text("Back",
                          style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: AppTheme.primaryColor),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _register(context);
                        }
                      },
                      child: Text("Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    ];
  }

  Widget _pageViewItems(int index) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: _stepProgress()),
        SizedBox(
          height: 20,
        ),
        Expanded(child: getSteps().elementAt(index)),
      ],
    );
  }

  Widget _stepProgress() {
    return StepProgressIndicator(
      totalSteps: 5,
      currentStep: _currentStep,
      size: 25,
      padding: 0,
      selectedColor: AppTheme.primaryColor,
      unselectedColor: AppTheme.primaryColor2,
      roundedEdges: Radius.circular(20),
      selectedGradientColor: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppTheme.primaryColor.withOpacity(0.5), AppTheme.primaryColor],
      ),
      unselectedGradientColor: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Colors.grey.shade200],
      ),
    );
  }

  PageController controller = PageController(initialPage: 0, keepPage: true);

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    _birthdayController.dispose();
    _countryController.dispose();
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
  void _register(BuildContext pageContext) async {
    User? user = await _authRepo.signUpClassic(_emailController.text,_passwordController.text,_usernameController.text,"",0,AppStrings.defaultAvatarUrl,DateTime.parse(_birthdayController.text),_countryController.text,"");
    if (user != null) {
      Navigator.pushNamedAndRemoveUntil(pageContext, '/main', (route) => false);
    } else {
      showDialog(
        context: pageContext,
        builder: (BuildContext context) {
          return const SingleChoiceDialog(
              title: 'Create account unsuccessfully',
              message: 'Something gone wrong!');
        },
      );
    }
  }
}
