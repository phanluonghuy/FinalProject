import 'package:finalproject/features/main_menu/home_page.dart';
import 'package:finalproject/features/main_menu/library_page.dart';
import 'package:finalproject/features/main_menu/profile_page.dart';
import 'package:finalproject/reuseable/constants/strings.dart';
import 'package:finalproject/reuseable/constants/text_styles.dart';
import 'package:finalproject/reuseable/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List pages = [const HomePage(), const LibraryPage(), const HomePage(), const HomePage()];
  List<BottomNavigationBarItem> barItems = [
    BottomNavigationBarItem(
        icon: Icon(MdiIcons.fromString('home-variant-outline')),
        label: AppStrings.home),
    BottomNavigationBarItem(
        icon: Icon(MdiIcons.fromString('book-open-page-variant-outline')), label: AppStrings.library),
    BottomNavigationBarItem(
        icon: Icon(MdiIcons.fromString('earth')), label: AppStrings.discovery),
    BottomNavigationBarItem(
        icon: Icon(MdiIcons.fromString('account-outline')), label: AppStrings.profile),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          HomePage(),
          LibraryPage(),
          HomePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          _pageController.animateToPage(
            newIndex,
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
          );
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
