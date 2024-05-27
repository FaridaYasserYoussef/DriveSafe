// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCvCjP3yqwhz6qKrlvmaw7pWUuah8FQfO0',
    appId: '1:554029639423:web:daeff39e0af515e4f18eca',
    messagingSenderId: '554029639423',
    projectId: 'drivesafe-22c94',
    authDomain: 'drivesafe-22c94.firebaseapp.com',
    storageBucket: 'drivesafe-22c94.appspot.com',
    measurementId: 'G-PH2KGHEJR3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAb9BqeeYB_hZlnhcu_Z_JrU-3H62aih3k',
    appId: '1:554029639423:android:a102ae61a0fae3b2f18eca',
    messagingSenderId: '554029639423',
    projectId: 'drivesafe-22c94',
    storageBucket: 'drivesafe-22c94.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXWin2BXlPFa_V0YUqDb1Z3KQw4kr79Tk',
    appId: '1:554029639423:ios:67df62c5129bcdc6f18eca',
    messagingSenderId: '554029639423',
    projectId: 'drivesafe-22c94',
    storageBucket: 'drivesafe-22c94.appspot.com',
    iosBundleId: 'com.example.drivesafe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBXWin2BXlPFa_V0YUqDb1Z3KQw4kr79Tk',
    appId: '1:554029639423:ios:67df62c5129bcdc6f18eca',
    messagingSenderId: '554029639423',
    projectId: 'drivesafe-22c94',
    storageBucket: 'drivesafe-22c94.appspot.com',
    iosBundleId: 'com.example.drivesafe',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCvCjP3yqwhz6qKrlvmaw7pWUuah8FQfO0',
    appId: '1:554029639423:web:cb08178a20ddc0c8f18eca',
    messagingSenderId: '554029639423',
    projectId: 'drivesafe-22c94',
    authDomain: 'drivesafe-22c94.firebaseapp.com',
    storageBucket: 'drivesafe-22c94.appspot.com',
    measurementId: 'G-66FH3HW1G8',
  );
}