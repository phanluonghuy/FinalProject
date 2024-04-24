import 'package:finalproject/features/main_menu/home_page.dart';
import 'package:finalproject/features/main_menu/library_page.dart';
import 'package:finalproject/features/main_menu/profile_page.dart';
import 'package:finalproject/common/constants/strings.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  int _currentIndex = 0;

  List pages = [
    const HomePage(),
    const LibraryPage(),
    const HomePage(),
    const ProfilePage()
  ];
  List<BottomNavigationBarItem> barItems = [
    BottomNavigationBarItem(
        icon: Icon(MdiIcons.fromString('home-variant-outline')),
        label: AppStrings.home),
    BottomNavigationBarItem(
        icon: Icon(MdiIcons.fromString('book-open-page-variant-outline')),
        label: AppStrings.library),
    BottomNavigationBarItem(
        icon: Icon(MdiIcons.fromString('earth')), label: AppStrings.discovery),
    BottomNavigationBarItem(
        icon: Icon(MdiIcons.fromString('account-outline')),
        label: AppStrings.profile),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: barItems,
        selectedLabelStyle: AppTextStyles.bold12,
        unselectedLabelStyle: AppTextStyles.bold12,
        iconSize: 28,
        backgroundColor: Colors.white,
        unselectedItemColor: AppTheme.grey2,
        selectedItemColor: AppTheme.primaryColor,
        showUnselectedLabels: true,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
