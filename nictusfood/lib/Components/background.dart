import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 50,
            right: 30,
            child: Image.asset("assets/appassets/Illustration.png",
                width: size.width * 0.35),
          ),
          Positioned(
            bottom: 75,
            right: 0,
            child: Image.asset("assets/appassets/Illustration.png",
                width: size.width),
          ),
          BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: child)
        ],
      ),
    );
  }
}
