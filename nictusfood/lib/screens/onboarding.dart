// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:nictusfood/constant/colors.dart';

class WithPages extends StatefulWidget {
  const WithPages({Key? key}) : super(key: key);

  @override
  _WithPages createState() => _WithPages();
}

class _WithPages extends State<WithPages> {
  static var style = GoogleFonts.poppins(
    fontSize: 25,
    fontWeight: FontWeight.w600,
  );
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  final pages = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LiquidSwipe(
          pages: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Lottie.asset(
                    'assets/lotties/tchepexrpess1.json',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height / 2,
                    repeat: false,
                    options: LottieOptions(),
                    frameRate: FrameRate.max,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Bienvenue 😊",
                        style: style,
                      ),
                      Text(
                        "sur Tchep Express",
                        style: style.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Êtes vous prêt ? On y va",
                        style: style.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Lottie.asset(
                    'assets/lotties/deliv.json',
                    fit: BoxFit.cover,
                    frameRate: FrameRate.max,
                    repeat: false,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Recevez",
                        style: style,
                      ),
                      Text(
                        "En 30 min",
                        style: style.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Votre commande",
                        style: style.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          slideIconWidget: const Icon(Icons.arrow_back_ios),
          onPageChangeCallback: (i) {},
          waveType: WaveType.liquidReveal,
          liquidController: liquidController,
          enableSideReveal: true,
          ignoreUserGestureWhileAnimating: true,
        ),
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
}
