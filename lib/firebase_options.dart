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
    apiKey: 'AIzaSyAdbRSu3WTjaPBm4RaxIKHPoug_-TyZE1k',
    appId: '1:997501497079:web:893c156f74927b644badf2',
    messagingSenderId: '997501497079',
    projectId: 'hat-trick-1afd3',
    authDomain: 'hat-trick-1afd3.firebaseapp.com',
    databaseURL: 'https://hat-trick-1afd3-default-rtdb.firebaseio.com',
    storageBucket: 'hat-trick-1afd3.appspot.com',
    measurementId: 'G-1D1VHRPS8X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxJ7R6n0RyU5zs8XxNKRe6uHk_SaFgtMs',
    appId: '1:997501497079:android:197c738398c5c1234badf2',
    messagingSenderId: '997501497079',
    projectId: 'hat-trick-1afd3',
    databaseURL: 'https://hat-trick-1afd3-default-rtdb.firebaseio.com',
    storageBucket: 'hat-trick-1afd3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJISyf5Gu4Qy1dxqrP7zNCCV4eFiXmrwY',
    appId: '1:997501497079:ios:c3c753161d651ec34badf2',
    messagingSenderId: '997501497079',
    projectId: 'hat-trick-1afd3',
    databaseURL: 'https://hat-trick-1afd3-default-rtdb.firebaseio.com',
    storageBucket: 'hat-trick-1afd3.appspot.com',
    androidClientId: '997501497079-rsgtq1n5ii825srehdq5evbgi2gbo5tv.apps.googleusercontent.com',
    iosClientId: '997501497079-c6mvks5nta6qkrpjsbqgdd6vpq5k1ggs.apps.googleusercontent.com',
    iosBundleId: 'com.example.hatTrick',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJISyf5Gu4Qy1dxqrP7zNCCV4eFiXmrwY',
    appId: '1:997501497079:ios:c3c753161d651ec34badf2',
    messagingSenderId: '997501497079',
    projectId: 'hat-trick-1afd3',
    databaseURL: 'https://hat-trick-1afd3-default-rtdb.firebaseio.com',
    storageBucket: 'hat-trick-1afd3.appspot.com',
    androidClientId: '997501497079-rsgtq1n5ii825srehdq5evbgi2gbo5tv.apps.googleusercontent.com',
    iosClientId: '997501497079-c6mvks5nta6qkrpjsbqgdd6vpq5k1ggs.apps.googleusercontent.com',
    iosBundleId: 'com.example.hatTrick',
  );
}
