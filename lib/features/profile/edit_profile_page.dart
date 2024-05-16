import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_icons/country_icons.dart';
import 'package:finalproject/common/constants/countries.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/Toast_widget.dart';
import 'package:finalproject/models/image_helper.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const EditProfile());
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  final _userRepo = UserRepo();
  final _imageHelper = ImageHelper();

  UserModel? _user;
  late DateTime? _pickedDate;
  int _indexCountry = -1;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _countryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  Future<UserModel?> _loadUserInfo() async {
    String uid = _currentUser.uid;
    UserModel? userInfo = await UserRepo().getUserByID(uid);
    _pickedDate = userInfo?.birthday ?? DateTime.now();
    return userInfo;
  }

  bool isNumeric(String str) {
    return RegExp(r'^-?[0-9]+$').hasMatch(str);
  }

  void _selectBirthday() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _user?.birthday ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    ).whenComplete(() => {});
    if (pickedDate != null) {
      _pickedDate = pickedDate;
      int day = pickedDate.day;
      int month = pickedDate.month;
      int year = pickedDate.year;
      String formattedDate =
          '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      _birthdayController.text = formattedDate;
    }
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

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
          onTap: () {
            _indexCountry = index;
            _countryController.text = countryList.elementAt(index).name;
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

  Widget _showUser(UserModel? _user) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Center(
            child: Container(
                height: 150,
                width: 150,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(

                        imageUrl: _user?.avatarUrl ?? "",
                        imageBuilder: (context, imageProvider) =>
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover),
                              ),
                            ),
                        placeholder: (context, url) => Center(
                            child:
                            LoadingAnimationWidget.fourRotatingDots(
                                color: AppTheme.primaryColor,
                                size: 30)),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: InkWell(
                        onTap: () async {
                          XFile? _file = await _imageHelper.pickImage();
                          if (_file == null ? false : true) {
                            CroppedFile? cropFile =
                            await _imageHelper.crop(file: _file);
                            if (cropFile != null) {
                              File croppedFile = File(cropFile.path);
                              _userRepo.uploadAvatar(
                                  croppedFile, context);
                              _loadUserInfo();
                            } else {
                              Toast.uploadAvatarFailed(context);
                            }
                          } else {
                            Toast.uploadAvatarFailed(context);
                          }
                        },
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Icons.mode_edit,
                                    color: Colors.white, size: 25),
                              )),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  60,
                                ),
                              ),
                              color: AppTheme.primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(2, 4),
                                  color: Colors.black.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 3,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          SizedBox(height: 30),
          Divider(
            height: 2,
            thickness: 0.5,
          ),
          SizedBox(height: 20),
          Text(
            "Name",
            style: AppTextStyles.bold20,
          ),
          SizedBox(height: 10),
          TextFormField(
            style: AppTextStyles.bold16,
            controller: _usernameController,
            cursorColor: AppTheme.primaryColor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your full name";
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Full name",
              hintStyle: AppTextStyles.bold16,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor)),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Bio",
            style: AppTextStyles.bold20,
          ),
          SizedBox(height: 10),
          TextFormField(
            style: AppTextStyles.bold16,
            controller: _bioController,
            cursorColor: AppTheme.primaryColor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintStyle: AppTextStyles.bold16,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor)),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Email",
            style: AppTextStyles.bold20,
          ),
          SizedBox(height: 10),
          TextFormField(
            style: AppTextStyles.bold16,
            controller: _emailController,
            cursorColor: AppTheme.primaryColor,
            readOnly: true,
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
          SizedBox(height: 20),
          Text(
            "Phone Number",
            style: AppTextStyles.bold20,
          ),
          SizedBox(height: 10),
          TextFormField(
            style: AppTextStyles.bold16,
            controller: _phoneController,
            cursorColor: AppTheme.primaryColor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              if (!isNumeric(value)) {
                return "Not a phone number";
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintStyle: AppTextStyles.bold16,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor)),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Date of birth",
            style: AppTextStyles.bold20,
          ),
          SizedBox(height: 10),
          TextFormField(
            style: AppTextStyles.bold16,
            controller: _birthdayController,
            cursorColor: AppTheme.primaryColor,
            readOnly: true,
            onTap: _selectBirthday,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select your birthday";
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Your email",
              hintStyle: AppTextStyles.bold16,
              suffixIcon: Icon(Icons.date_range_rounded,
                  color: AppTheme.primaryColor),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor)),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Country",
            style: AppTextStyles.bold20,
          ),
          SizedBox(height: 10),
          TextFormField(
            style: AppTextStyles.bold16,
            controller: _countryController,
            cursorColor: AppTheme.primaryColor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            readOnly: true,
            onTap: _selectCountry,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select your country";
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Your email",
              hintStyle: AppTextStyles.bold16,
              suffixIcon: Icon(
                Icons.arrow_drop_down_outlined,
                color: AppTheme.primaryColor,
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor)),
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                backgroundColor: AppTheme.primaryColor),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _user?.name = _usernameController.text;
                _user?.bio = _bioController.text;
                _user?.phone = _phoneController.text;
                _user?.birthday = _pickedDate;
                _user?.country = _countryController.text;
                _userRepo.updateUser(_user!, context);
              }
            },
            child: Text("UPDATE",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Info", style: AppTextStyles.bold20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<UserModel?>(
          future: _loadUserInfo(),
          builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
            if (snapshot.hasData) {
               _user = snapshot.data;
               if (_countryController.text.isEmpty) {
                 _countryController.text = _user?.country ?? "";
               }
               _usernameController.text = _user?.name ?? "";
               _bioController.text = _user?.bio ?? "";
               _emailController.text = _user?.email ?? "";
               _phoneController.text = _user?.phone ?? "";
               DateTime _birthday = _user?.birthday ?? DateTime.now();
               _birthdayController.text =
               '${_birthday.year}-${_birthday.month.toString().padLeft(2, '0')}-${_birthday.day.toString().padLeft(2, '0')}';
               if (_indexCountry==-1) {
                 _indexCountry = countryList.indexWhere((country) => country.name.toLowerCase() == _countryController.text.toLowerCase());
               }

              return _showUser(_user);
            } else {
              return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppTheme.primaryColor.withOpacity(0.5), size: 80));
            }
          },
        ),
      ),
    );
  }
}
