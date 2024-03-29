// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/controller/cart_state.dart';
import 'package:nictusfood/controller/changestatelivraison.dart';
import 'package:nictusfood/models/cartmodel.dart';
import 'package:nictusfood/models/customer.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/screens/remercimentpage.dart';
import 'package:nictusfood/services/api_services.dart';
import 'package:shimmer/shimmer.dart';

class ValidationPage extends StatefulWidget {
  final List<CartModel>? items;
  final String? lieuxLivraison;
  final String? moyentPayement;
  final String? idUser;
  final String? moyenLivraion;
  const ValidationPage({
    Key? key,
    this.items,
    this.lieuxLivraison,
    this.moyentPayement,
    required this.idUser,
    this.moyenLivraion,
  }) : super(key: key);

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  final controller = Get.put(MyCartController());
  final controllerLivraison = Get.put(StateLivraison());
  TextEditingController controllerNumberIfIsEmpty = TextEditingController();
  final key = GlobalKey<FormState>();
  bool load = false;

  void getMoyenLivraison() {
    print(" j'ai pris ma livraison ${widget.moyenLivraion}");
  }

  @override
  void initState() {
    getMoyenLivraison();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Loading())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: maincolor,
              elevation: 0,
              title: Text(
                // "Je valide votre commande",
                "Validation",
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
            body: ListView(
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
                      Expanded(
                        child: widget.lieuxLivraison != "à emporter"
                            ? FittedBox(
                                child: Text(
                                  widget.lieuxLivraison!,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                widget.lieuxLivraison!,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            "Moyen de payement : ${widget.moyentPayement!}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2,
                  ),
                  child: Text(
                    item.productName!,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 5),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2,
                  ),
                  child: Text(
                    "${item.price} FCFA x ${item.quantity}",
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
          widget.moyenLivraion == "emporter"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "À emporter",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Text(
                        "0 FCFA",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
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
          widget.moyenLivraion == "emporter"
              ? Row(
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
                      "${controller.getPrice()} FCFA",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
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
                      "${controller.getPrice() + 1000} FCFA",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
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
          var box = await Hive.openBox<Customer>('boxCustomer');
          var customer = box.get("customer");

          if (customer!.phone!.trim().isEmpty) {
            Get.defaultDialog(
              title: "Entrer votre numéro svp",
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              content: Container(
                child: Form(
                  key: key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controllerNumberIfIsEmpty,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "champ vide";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.poppins(),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Ex : 0000000000",
                            hintStyle: GoogleFonts.poppins(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              confirm: GestureDetector(
                onTap: () {
                  if (key.currentState!.validate()) {
                    box.put(
                      "customer",
                      customer.changeNumber(controllerNumberIfIsEmpty.text),
                    );
                    FocusScope.of(context).unfocus();
                    Get.back();
                  } else {}
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
                      "Valider",
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
            // box.put("customer", customer);
          } else {
            setState(() {
              load = true;
            });
            if (kDebugMode) {
              print("UTILISATEUR PRESENT $customer");
            }
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
            final r = await APIService().createCommande(
              controllerLivraison.groupValue.value == "livrer" ? true : false,
              customer.nom!,
              widget.lieuxLivraison!,
              customer.ville!,
              customer.email!,
              customer.phone!,
              products,
              int.parse(widget.idUser!),
            );
            if (r![0] == true) {
              controller.cart.clear();
              Fluttertoast.showToast(msg: "Commande effectué");
              Get.offAll(
                RemercimentPage(
                  idUser: widget.idUser!,
                  order: r[1],
                ),
              );
            } else {
              setState(() {
                load = false;
              });
            }
          }
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
              "Je valide ma commande",
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
