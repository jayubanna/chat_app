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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA49BxOk1pO0ohhZuYzNYfbGQOBtpEoTVI',
    appId: '1:1079549046066:android:db2f9dcb9d15fb52ccbb2b',
    messagingSenderId: '1079549046066',
    projectId: 'chat-app-ffae8',
    databaseURL: 'https://chat-app-ffae8-default-rtdb.firebaseio.com',
    storageBucket: 'chat-app-ffae8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSszflhHEAKa8f2jzsUZoJzKW203EVlRY',
    appId: '1:1079549046066:ios:c6779db79754b98cccbb2b',
    messagingSenderId: '1079549046066',
    projectId: 'chat-app-ffae8',
    databaseURL: 'https://chat-app-ffae8-default-rtdb.firebaseio.com',
    storageBucket: 'chat-app-ffae8.appspot.com',
    androidClientId: '1079549046066-3m32dnogmqka3ch9ub1tc5okjalvvavt.apps.googleusercontent.com',
    iosClientId: '1079549046066-64r2eomhu7pu8r6t6rqkjgg5i6s9e6ac.apps.googleusercontent.com',
    iosBundleId: 'com.chtt.chatApp',
  );

}