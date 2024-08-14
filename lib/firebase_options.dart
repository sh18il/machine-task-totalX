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
    apiKey: 'AIzaSyBnCWg9mv4kIm4kQhrHPGKVOpeDocMi9jE',
    appId: '1:78282127166:web:407ec1f2ffe3d7a69f5e6f',
    messagingSenderId: '78282127166',
    projectId: 'totalx-a3a4d',
    authDomain: 'totalx-a3a4d.firebaseapp.com',
    storageBucket: 'totalx-a3a4d.appspot.com',
    measurementId: 'G-1BZNZ6VMNH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjFP5yONvHWb3tiW4i7IrbAu1NXCRPrwk',
    appId: '1:78282127166:android:188d17a94c9da2f19f5e6f',
    messagingSenderId: '78282127166',
    projectId: 'totalx-a3a4d',
    storageBucket: 'totalx-a3a4d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQADVApdtqZOtMPJgRO3B47EJCSDvlZ18',
    appId: '1:78282127166:ios:3f88f9bbea61224a9f5e6f',
    messagingSenderId: '78282127166',
    projectId: 'totalx-a3a4d',
    storageBucket: 'totalx-a3a4d.appspot.com',
    iosBundleId: 'com.example.totalx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBQADVApdtqZOtMPJgRO3B47EJCSDvlZ18',
    appId: '1:78282127166:ios:3f88f9bbea61224a9f5e6f',
    messagingSenderId: '78282127166',
    projectId: 'totalx-a3a4d',
    storageBucket: 'totalx-a3a4d.appspot.com',
    iosBundleId: 'com.example.totalx',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBnCWg9mv4kIm4kQhrHPGKVOpeDocMi9jE',
    appId: '1:78282127166:web:ec7d9442d56acc5d9f5e6f',
    messagingSenderId: '78282127166',
    projectId: 'totalx-a3a4d',
    authDomain: 'totalx-a3a4d.firebaseapp.com',
    storageBucket: 'totalx-a3a4d.appspot.com',
    measurementId: 'G-61NKECR019',
  );

}