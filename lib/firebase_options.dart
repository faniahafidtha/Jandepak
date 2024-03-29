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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDMzeQyp2WD_GofGMU3Vt3M-UBOwKcvqg0',
    appId: '1:236460009382:web:9a43677b9af20a59029167',
    messagingSenderId: '236460009382',
    projectId: 'jandepak-9c12a',
    authDomain: 'jandepak-9c12a.firebaseapp.com',
    storageBucket: 'jandepak-9c12a.appspot.com',
    measurementId: 'G-EC5D1H2TYH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5w12sRiVKOiCblWFEZKTD_SYAvNiAZiY',
    appId: '1:236460009382:android:4a15286da7e24407029167',
    messagingSenderId: '236460009382',
    projectId: 'jandepak-9c12a',
    storageBucket: 'jandepak-9c12a.appspot.com',
  );
}
