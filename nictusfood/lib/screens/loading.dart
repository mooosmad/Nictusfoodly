import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nictusfood/constant/colors.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: maincolor,
      child: Center(
        child: Lottie.asset("assets/lotties/62265-walking-taco.json",
            width: 130, height: 130),
      ),
    );
  }
}
