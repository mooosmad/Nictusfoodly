import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/ordermodel.dart';
import 'package:nictusfood/screens/orderPage.dart';
import 'package:nictusfood/screens/seeCommade.dart';

class RemercimentPage extends StatefulWidget {
  final String? idUser;
  final Order? order;
  const RemercimentPage({Key? key, required this.idUser, required this.order})
      : super(key: key);

  @override
  State<RemercimentPage> createState() => _RemercimentPageState();
}

class _RemercimentPageState extends State<RemercimentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Lottie.asset(
                "assets/lotties/delivered.json",
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Succès",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "TchêpExpress vous remercie et votre commande est en cours de préparation",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
              Text(
                "Votre commande sera livrée dans quelques minutes",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
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
            SeeCommande(
              order: widget.order,
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
