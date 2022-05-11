import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:nictusfood/constant/colors.dart';

class WithPages extends StatefulWidget {
  static const style = TextStyle(
    fontSize: 25,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w600,
  );

  const WithPages({Key? key}) : super(key: key);

  @override
  _WithPages createState() => _WithPages();
}

class _WithPages extends State<WithPages> {
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  final pages = [
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
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Column(
            children: const <Widget>[
              Text(
                "Bienvenue 😊",
                style: WithPages.style,
              ),
              Text(
                "sur Tchep Express",
                style: WithPages.style,
              ),
              Text(
                "Êtes vous prêt ? On y va",
                style: WithPages.style,
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      color: maincolor,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Lottie.asset(
            'assets/lotties/delivery.json',
            fit: BoxFit.cover,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Column(
            children: const <Widget>[
              Text(
                "Choisissez",
                style: WithPages.style,
              ),
              Text(
                "Commandez",
                style: WithPages.style,
              ),
              Text(
                "Patientez 30 min",
                style: WithPages.style,
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
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Column(
            children: const <Widget>[
              Text(
                "Recevez",
                style: WithPages.style,
              ),
              Text(
                "en 30min",
                style: WithPages.style,
              ),
              Text(
                "Votre Commande",
                style: WithPages.style,
              ),
            ],
          ),
        ],
      ),
    ),
    // Container(
    //   color: maincolor,
    //   width: double.infinity,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisSize: MainAxisSize.max,
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: <Widget>[
    //       Image.asset(
    //         'assets/appassets/Illustration.png',
    //         fit: BoxFit.cover,
    //       ),
    //       const Padding(
    //         padding: EdgeInsets.all(20.0),
    //       ),
    //       Column(
    //         children: const <Widget>[
    //           Text(
    //             "Can be",
    //             style: WithPages.style,
    //           ),
    //           Text(
    //             "Used for",
    //             style: WithPages.style,
    //           ),
    //           Text(
    //             "Onboarding Design",
    //             style: WithPages.style,
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // ),
    // Container(
    //   color: Colors.white,
    //   width: double.infinity,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisSize: MainAxisSize.max,
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: <Widget>[
    //       Image.asset(
    //         'assets/appassets/Illustration.png',
    //         fit: BoxFit.cover,
    //       ),
    //       const Padding(
    //         padding: EdgeInsets.all(20.0),
    //       ),
    //       Column(
    //         children: const <Widget>[
    //           Text(
    //             "Do",
    //             style: WithPages.style,
    //           ),
    //           Text(
    //             "Try it",
    //             style: WithPages.style,
    //           ),
    //           Text(
    //             "Thank You",
    //             style: WithPages.style,
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // ),
  ];

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return SizedBox(
      width: 25.0,
      child: Center(
        child: Material(
          color: Colors.black,
          type: MaterialType.card,
          child: SizedBox(
            width: 8.0 * zoom,
            height: 4.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            LiquidSwipe(
              pages: pages,
              slideIconWidget: const Icon(Icons.arrow_back_ios),
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              liquidController: liquidController,
              enableSideReveal: true,
              ignoreUserGestureWhileAnimating: true,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  const Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(pages.length, _buildDot),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FlatButton(
                  onPressed: () {
                    liquidController.animateToPage(
                        page: pages.length - 1, duration: 700);
                  },
                  child: const Text("Skip to End"),
                  color: Colors.white.withOpacity(0.01),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FlatButton(
                  onPressed: () {
                    liquidController.jumpToPage(
                        page:
                            liquidController.currentPage + 1 > pages.length - 1
                                ? 0
                                : liquidController.currentPage + 1);
                  },
                  child: const Text("Next"),
                  color: Colors.white.withOpacity(0.01),
                ),
              ),
            )
          ],
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
