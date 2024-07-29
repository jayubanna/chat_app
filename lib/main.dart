import 'package:chat_app/view/home_page.dart';
import 'package:chat_app/view/login_page.dart';
import 'package:chat_app/view/massge_page.dart';
import 'package:chat_app/view/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import 'firebase_options.dart';
import 'helper/local_notifications.dart';
@pragma('vm:entry-point')
Future<void> handleBackgroundFCMNotification(
    RemoteMessage remoteMessage) async {
  print("======Background/Terminated STATE========");
  print("FCM Notification arrived...");
  print("==============");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
    print("======FOREGROUND STATE========");
    print("FCM Notification arrived...");
    print("==============");
    LocalNotifications.localNotifications.showSimpleNotification(
      title: remoteMessage.notification!.title,
      body: remoteMessage.notification!.body,
    );
  });

  FirebaseMessaging.onBackgroundMessage(handleBackgroundFCMNotification);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => const SplashScreen(),),
        GetPage(name: "/login_page", page: () => const LoginPage()),
        GetPage(
          name: "/home_page",
          page: () => HomePage(),
          transition: Transition.zoom,
        ),
        GetPage(
          name: "/massge_page",
          page: () => MassgePage(),
        ),
      ],
    );
  }
}
