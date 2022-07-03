// ignore_for_file: prefer_const_constructors

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/customer.dart';
import 'package:nictusfood/screens/errorPage.dart';
import 'package:nictusfood/screens/home.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/screens/onboarding.dart';
import 'package:nictusfood/screens/orderPage.dart';
import 'package:nictusfood/services/utils.dart';
import 'package:nictusfood/themes/nictustheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Box box;
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CustomerAdapter());
  box = await Hive.openBox<Customer>('boxCustomer');
  runApp(MyApp());

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Nictustheme.light();
    return GetMaterialApp(
      routes: {
        "/home": (context) {
          return Home();
        },
        "/orderPage": (context) {
          return OrderPage();
        }
      },
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
  bool? isConnect;
  Future getFirt() async {
    isConnect = await Util().isConnected();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        isFirst = prefs.getBool("isFirst") ?? true;
      });
    }
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
      splashIconSize: 250,
      backgroundColor: Colors.white,
      nextScreen: isFirst != null
          ? false //isFirst!
              // ignore: dead_code
              ? WithPages()
              : isConnect != null
                  ? isConnect!
                      ? Home()
                      : ErrorPage()
                  : Container(
                      color: maincolor,
                      child: Loading(),
                    )
          : Loading(),
      splashTransition: SplashTransition.slideTransition,
    );
  }
}
