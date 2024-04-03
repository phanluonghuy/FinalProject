import 'package:finalproject/features/main_menu/home_page.dart';
import 'package:finalproject/features/main_menu/library_page.dart';
import 'package:finalproject/reuseable/themes/app_theme.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  List pages = [
    HomePage(),
    LibraryPage(),
    HomePage(),
    HomePage()
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
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.library_books), label: 'Library'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discovery'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedLabelStyle: TextStyle(
          fontFamily: 'Lato',
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
          fontSize: 12),
      unselectedLabelStyle: TextStyle(
          fontFamily: 'Lato',
          fontWeight: FontWeight.bold,
          color: AppTheme.grey2,
          fontSize: 12),
      iconSize: 24,
      backgroundColor: Colors.white,
      unselectedItemColor: AppTheme.grey2,
      selectedItemColor: AppTheme.primaryColor,
      showUnselectedLabels: true,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    )
    );
  }
}