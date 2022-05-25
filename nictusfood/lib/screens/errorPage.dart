// ignore_for_file: file_names

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/main.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: maincolor,
        padding: const EdgeInsets.all(10),
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
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
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
                  Get.offAll(const MySplashScreen());
                },
              ),
              const SizedBox(height: 20),
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
