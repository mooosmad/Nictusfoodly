// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/controller/cart_state.dart';
import 'package:nictusfood/models/cartmodel.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/services/api_services.dart';
import 'package:shimmer/shimmer.dart';

class ValidationPage extends StatefulWidget {
  final List<CartModel>? items;
  final String? lieuxLivraison;
  final String? moyentPayement;
  final String? idUser;
  const ValidationPage(
      {Key? key,
      this.items,
      this.lieuxLivraison,
      this.moyentPayement,
      required this.idUser})
      : super(key: key);

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  final controller = Get.put(MyCartController());
  bool load = false;
  @override
  Widget build(BuildContext context) {
    return load
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: maincolor,
              elevation: 0,
              title: Text(
                "Valider votre commande",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            body: Container(
              child: ListView(
                children: [
                  myrecap(),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: maincolor,
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.lieuxLivraison!,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.monetization_on_sharp,
                          color: maincolor,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Moyen de payement : " + widget.moyentPayement!,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.grey,
                      child: Text(
                        "Veuillez Bien lire avant de valider votre commande",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  myButton(),
                ],
              ),
            ),
          );
  }

  Widget myrecap() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Recap.",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          for (var item in widget.items!)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    item.productName!,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    item.price.toString() +
                        " FCFA" +
                        " x " +
                        item.quantity.toString(),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2,
                  ),
                ),
              ],
            ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Livraison",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  "1000 FCFA",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                (controller.getPrice() + 1000).toString() + " FCFA",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget myButton() {
    return Center(
      child: InkWell(
        onTap: () async {
          setState(() {
            load = true;
          });
          var customer = await APIService().getUser(
            int.parse(widget.idUser!),
          );
          print("UTILISATEUR PRESENT$customer");
          List<Map<String, dynamic>> products = controller.cart
              .map((element) {
                return {
                  "product_id": element.productId,
                  "quantity": element.quantity!.value,
                };
              })
              .toList()
              .cast<Map<String, dynamic>>();

          // test api create commande ok
          var r = await APIService().createCommande(
            customer!.nom!,
            widget.lieuxLivraison!,
            customer.ville!,
            customer.email!,
            customer.phone!,
            products,
            int.parse(widget.idUser!),
          );
          if (r!) {
            controller.cart.clear();
            Fluttertoast.showToast(msg: "Commande effectué");
            Get.offAllNamed("/home");
          }
          setState(() {
            load = false;
          });
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
              "Valider ma commande",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
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
