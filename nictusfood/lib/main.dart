// ignore_for_file: prefer_const_constructors

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/screens/home.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/screens/mymap.dart';
import 'package:nictusfood/screens/onboarding.dart';
import 'package:nictusfood/themes/nictustheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Nictustheme.light();
    return GetMaterialApp(
      theme: theme,
      home: MySplashScreen(),
      title: "Tchep Express",
      debugShowCheckedModeBanner: false,
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool? isFirst;
  Future getFirt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirst = prefs.getBool("isFirst") ?? true;
    });
  }

  @override
  void initState() {
    getFirt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/appassets/logo.png',
      splashIconSize: 300,
      backgroundColor: maincolor,
      nextScreen: isFirst != null
          ? false //isFirst!
              ? WithPages()
              : Home()
          : Loading(),
      splashTransition: SplashTransition.slideTransition,
    );
  }
}
