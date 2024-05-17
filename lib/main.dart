import 'package:finalproject/features/auth/change_password_page.dart';
import 'package:finalproject/features/auth/forgotPasword_page.dart';
import 'package:finalproject/features/auth/register_page.dart';
import 'package:finalproject/features/auth/settings_page.dart';
import 'package:finalproject/features/profile/edit_profile_page.dart';
import 'package:finalproject/firebase_options.dart';
import 'package:finalproject/features/main_menu/home_page.dart';
import 'package:finalproject/features/main_menu/control_page.dart';
import 'package:finalproject/features/auth/welcome_page.dart';
import 'package:finalproject/wrapper.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/auth/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Triolingo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primaryColor),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const Wrapper(),
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/main': (context) => ControlPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot': (context) => const ForgotPage(),
        '/editProfile': (context) => const EditProfile(),
        '/settings': (context) => const SettingPage(),
        '/changePassword': (context) => const ChangePasswordPage()
      },
    );
  }
}
