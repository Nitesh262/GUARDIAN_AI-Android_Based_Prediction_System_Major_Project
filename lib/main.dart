import 'dart:math';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fake_news_detection/colors.dart';
import 'package:fake_news_detection/homescreen.dart';
import 'package:fake_news_detection/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
      splash: Image.asset('assets/mainlogowithoutbackground.png'),
      nextScreen: StreamBuilder(    //stream builder start to check the  instance user
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return home();
            } else {
              return login();
            }
          }),
      duration: 4,
      backgroundColor: appBarColor,
      splashIconSize: 300,
    )
    );
  }

  /*checkOption() {
    StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return home();
          } else {
            return login();
          }
        });
  }*/
}
