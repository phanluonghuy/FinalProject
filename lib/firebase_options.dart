// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC4VtHqueI8ABgGDi2XNb3zpGQuTIWBFBY',
    appId: '1:941419136023:web:2ba12e40343f3c0acec852',
    messagingSenderId: '941419136023',
    projectId: 'finalprojectflutter-55c38',
    authDomain: 'finalprojectflutter-55c38.firebaseapp.com',
    storageBucket: 'finalprojectflutter-55c38.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDAbyU_yePcS0avXcrZlEW08hUKncCpnWE',
    appId: '1:941419136023:android:d4b7b12d64766499cec852',
    messagingSenderId: '941419136023',
    projectId: 'finalprojectflutter-55c38',
    storageBucket: 'finalprojectflutter-55c38.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC91ooI1yVDjV9dNvUp7GdDE5P7TTgdJe4',
    appId: '1:941419136023:ios:1c447bcf59651238cec852',
    messagingSenderId: '941419136023',
    projectId: 'finalprojectflutter-55c38',
    storageBucket: 'finalprojectflutter-55c38.appspot.com',
    iosBundleId: 'com.example.finalproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC91ooI1yVDjV9dNvUp7GdDE5P7TTgdJe4',
    appId: '1:941419136023:ios:17fc7e234077e0becec852',
    messagingSenderId: '941419136023',
    projectId: 'finalprojectflutter-55c38',
    storageBucket: 'finalprojectflutter-55c38.appspot.com',
    iosBundleId: 'com.example.finalproject.RunnerTests',
  );
}
