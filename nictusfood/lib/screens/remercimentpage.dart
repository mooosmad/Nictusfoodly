import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/ordermodel.dart';
import 'package:nictusfood/screens/timeline.dart';

class RemercimentPage extends StatefulWidget {
  final String? idUser;
  final Order? order;
  final bool? showBtn;
  const RemercimentPage(
      {Key? key, required this.idUser, required this.order, this.showBtn})
      : super(key: key);

  @override
  State<RemercimentPage> createState() => _RemercimentPageState();
}

class _RemercimentPageState extends State<RemercimentPage> {
  bool showBtn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Center(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Lottie.asset(
                "assets/lotties/delivered.json",
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "TchêpExpress vous remercie.",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Votre commande est en cours de préparation, vous serez livré dans quelques minutes",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 20),
              myButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget myButton() {
    return Center(
      child: InkWell(
        onTap: () async {
          // Get.offAllNamed("/home");
          Get.to(
            TimelineTacer(
              order: widget.order,
              showBtn: widget.showBtn,
            ),
            transition: Transition.rightToLeft,
          );
        },
        child: Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: maincolor,
          ),
          child: Center(
            child: Text(
              "Je suis ma commande",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
