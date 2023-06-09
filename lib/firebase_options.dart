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
    apiKey: 'AIzaSyAHC7wDglCJVel-0nTz4JCcHdbENwj_EdA',
    appId: '1:392869690067:web:46f1356a8668aada03b226',
    messagingSenderId: '392869690067',
    projectId: 'planto-iot',
    authDomain: 'planto-iot.firebaseapp.com',
    storageBucket: 'planto-iot.appspot.com',
    measurementId: 'G-YRL0TZFBQ8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcfkDuqt0s1AjdlrOxYUh5LuGk8QD0_Kc',
    appId: '1:392869690067:android:1b2fec2e3881480003b226',
    messagingSenderId: '392869690067',
    projectId: 'planto-iot',
    storageBucket: 'planto-iot.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByUpzZBg4PGOnHZmYoXD60U9fIRHhJEjc',
    appId: '1:392869690067:ios:5d46a6075533782203b226',
    messagingSenderId: '392869690067',
    projectId: 'planto-iot',
    storageBucket: 'planto-iot.appspot.com',
    androidClientId: '392869690067-u0llntka5bo5d63ai6ahknkdhlondnr1.apps.googleusercontent.com',
    iosClientId: '392869690067-g2so1kds8tm0dmo7krmlnbrj55i7qenk.apps.googleusercontent.com',
    iosBundleId: 'com.sempreceub.plantoiot.plantoIotFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyByUpzZBg4PGOnHZmYoXD60U9fIRHhJEjc',
    appId: '1:392869690067:ios:5d46a6075533782203b226',
    messagingSenderId: '392869690067',
    projectId: 'planto-iot',
    storageBucket: 'planto-iot.appspot.com',
    androidClientId: '392869690067-u0llntka5bo5d63ai6ahknkdhlondnr1.apps.googleusercontent.com',
    iosClientId: '392869690067-g2so1kds8tm0dmo7krmlnbrj55i7qenk.apps.googleusercontent.com',
    iosBundleId: 'com.sempreceub.plantoiot.plantoIotFlutter',
  );
}
