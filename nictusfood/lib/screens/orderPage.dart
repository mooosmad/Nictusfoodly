// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, file_names

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/models/ordermodel.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/screens/seeCommade.dart';
import 'package:nictusfood/screens/timeline.dart';
import 'package:nictusfood/services/api_services.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderPage extends StatefulWidget {
  final String? idUser;
  const OrderPage({Key? key, this.idUser}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Order>? orders = [];
  bool load = true;

  getOrder() async {
    orders = await APIService().getOrder(int.parse(widget.idUser!));
    if (mounted) {
      setState(() {
        load = false;
      });
    }
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getOrder();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? Container(color: Colors.white, child: Loading())
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              title: Text(
                "Mes commandes",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: Container(
              child: orders != null
                  ? orders!.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Aucune commande veuillez commander des produits",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: orders!.length,
                          itemBuilder: (context, i) {
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                      // SeeCommande(
                                      //   order: orders![i],
                                      //   showBtn: false,
                                      // ),
                                      TimelineTacer(
                                        order: orders![i],
                                        showBtn: false,
                                      ),
                                      transition: Transition.cupertino,
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    height: 170,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          offset: Offset(0.5, 1),
                                          blurRadius: 2.0,
                                          spreadRadius: .5,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Reçu de la commande : "),
                                        Text(
                                          orders![i].keyOrder!,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text("Montant Total: "),
                                        Text(
                                          '${orders![i].priceTotal!} FCFA',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  right: 20,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: orders![i].status == "completed"
                                            ? Colors.green.withOpacity(0.6)
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(
                                      // orders![i].status!,
                                      getStatut(orders![i].status!),
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: IconButton(
                                      onPressed: () => launchUrl(
                                          Uri.parse("tel:+2250769418743")),
                                      icon: Icon(Icons.call),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                  : RefreshIndicator(
                      child: ListView(
                        children: [
                          SizedBox(
                            height:
                                (MediaQuery.of(context).size.height / 2) - 100,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Veuillez verifier votre connexion internet puis reessayer",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onRefresh: () async {
                        getOrder();
                      }),
            ),
          );
  }
}
