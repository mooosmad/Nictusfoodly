// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nictusfood/auth/confirmemail.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/screens/home.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/screens/onboarding.dart';
import 'package:nictusfood/services/utils.dart';
import 'package:nictusfood/themes/nictustheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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
      splashIconSize: 300,
      backgroundColor: maincolor,
      nextScreen: isFirst != null
          ? false //isFirst!
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

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: maincolor,
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/lotties/64788-no-internet.json",
                  height: MediaQuery.of(context).size.height / 2),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  ),
                ),
                child: Text(
                  "REESAYER",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Get.offAll(MySplashScreen());
                },
              ),
              SizedBox(height: 20),
              Text(
                "Veuillez verifier votre connexion internet puis Réesayer",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
