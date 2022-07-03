import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nictusfood/models/ordermodel.dart';

import '../constant/colors.dart';

class SeeCommande extends StatefulWidget {
  final Order? order;
  const SeeCommande({Key? key, required this.order}) : super(key: key);

  @override
  State<SeeCommande> createState() => _SeeCommandeState();
}

class _SeeCommandeState extends State<SeeCommande> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statut de la commande"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Center(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Lottie.asset(
                "assets/lotties/107669-cooking.json",
                fit: BoxFit.cover,
              ),
              Column(
                children: [
                  Text(
                    "Etat de la commande : ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    getStatut("${widget.order!.status}"),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Recu de la commande : ",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "${widget.order!.keyOrder}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "TchepExpress vous remercie et votre commande est en cours de préparation",
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
          Get.offAllNamed("/home");
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
              "Retouner au menu",
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

  String getStatut(String statusReturned) {
    switch (statusReturned) {
      case "progress-shipment":
        return "Commande en cours de livraison";
      case "arrival-shipment":
        return "Commande arrivée";
      case "shipped":
        return "Commande à proximité";
      case "processing":
        return "En cours de préparation";
      case "completed":
        return "Terminé";

      default:
        return "";
    }
  }
}
