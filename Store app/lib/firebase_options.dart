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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDdgi5-e3Ye2UG5_DQKHdLlMxDnDO6msAc',
    appId: '1:862152512683:web:3f272ce228bdea0444d3ee',
    messagingSenderId: '862152512683',
    projectId: 'dehkanbaba-uz',
    authDomain: 'dehkanbaba-uz.firebaseapp.com',
    storageBucket: 'dehkanbaba-uz.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsgcurzbhDPl108JdyP9ukwrYXLEibDP8',
    appId: '1:862152512683:android:07b3318d56bdd6a744d3ee',
    messagingSenderId: '862152512683',
    projectId: 'dehkanbaba-uz',
    storageBucket: 'dehkanbaba-uz.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVzSAVlDZmBP5GUGRSbmPWxKXeylW9g7g',
    appId: '1:862152512683:ios:3c60e6256cb6f81744d3ee',
    messagingSenderId: '862152512683',
    projectId: 'dehkanbaba-uz',
    storageBucket: 'dehkanbaba-uz.appspot.com',
    iosClientId: '862152512683-dbv03tjspbiv37o1b7j1fq3sn31bt88d.apps.googleusercontent.com',
    iosBundleId: 'com.dehkanbabastore.uz',
  );
}
