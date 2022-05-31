// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, file_names

import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/models/ordermodel.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/services/api_services.dart';

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

  @override
  void initState() {
    getOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? Container(child: Loading(), color: Colors.white)
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
                                Container(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Recu de la commande : "),
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
                                        orders![i].priceTotal! + ' FCFA',
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
                                Positioned(
                                  bottom: 20,
                                  right: 20,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: orders![i].status == "completed"
                                            ? Colors.green.withOpacity(0.6)
                                            : Colors.yellow.withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(
                                      orders![i].status!,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
