// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nictusfood/auth/registrer.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/controller/cart_state.dart';
import 'package:nictusfood/controller/changestatelivraison.dart';
import 'package:nictusfood/models/cartmodel.dart';
import 'package:nictusfood/services/api_services.dart';
import 'package:nictusfood/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key);

  final controller = Get.put(MyCartController());
  RxString value = "".obs;
  var groupValue = "emporter".obs;
  final controllerLivraison = Get.put(StateLivraison());

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Text(
                "Mon Panier",
                style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Obx(() {
                return controller.cart.isEmpty
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Lottie.asset(
                                "assets/lotties/629-empty-box.json",
                                repeat: false,
                                width: 200,
                                height: 200,
                              ),
                            ),
                            Text(
                              "Oups Panier vide veuillez ajouter des produits svp!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 2),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    itemCount: controller.cart.length + 1,
                                    itemBuilder: (context, i) {
                                      return i == controller.cart.length
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Divider(
                                                  thickness: 3,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Obx(() {
                                                      return Radio(
                                                          value: "emporter",
                                                          groupValue:
                                                              controllerLivraison
                                                                  .groupValue
                                                                  .value,
                                                          onChanged: (val) {
                                                            controllerLivraison
                                                                .changeValue(
                                                                    val);
                                                          });
                                                    }),
                                                    Text(
                                                      "à emporter",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Obx(() {
                                                      return Radio(
                                                          value: "livrer",
                                                          groupValue:
                                                              controllerLivraison
                                                                  .groupValue
                                                                  .value,
                                                          onChanged: (val) {
                                                            controllerLivraison
                                                                .changeValue(
                                                                    val!);
                                                          });
                                                    }),
                                                    Text(
                                                      "à Livrer",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Moyen de payement",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                payementDrop(),
                                                SizedBox(height: 10),
                                                myButton(),
                                                SizedBox(height: 10),
                                                Container(
                                                  color: Color(0xFFF4F4F4),
                                                ),
                                              ],
                                            )
                                          : myContainer(
                                              controller.cart[i],
                                            );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
              })
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              width: 30,
              height: 30,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: maincolor),
              child: Center(
                child: Icon(Icons.clear, color: Colors.white),
              ),
            ),
          ),
        ),
        Positioned(
          top: -12,
          left: (MediaQuery.of(context).size.width / 2) - 25,
          child: Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }

  Widget myButton() {
    return Center(
      child: InkWell(
        onTap: () async {
          HapticFeedback.vibrate();

          final prefs = await SharedPreferences.getInstance();
          var idUser = prefs.getString("idUser") ?? "-1";
          if (idUser != "-1") {
            var customer = await APIService().getUser(
              int.parse(idUser),
            );
            print("OKKKKKKKKKKKK $customer");
            APIService().createCommande(
              customer!.nom!,
              customer.adresse!,
              customer.ville!,
              customer.email!,
              customer.phone!,
              [
                {"product_id": 164, "quantity": 2},
                {"product_id": 170, "quantity": 1}
              ],
            );
            print("hihi");
          } else {
            Get.to(
              RegisterScreen(isdrawer: false),
            );
          }
          print(idUser);
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

  Widget payementDrop() {
    return DropdownButtonFormField<String>(
      value: "espece",
      items: [
        DropdownMenuItem(
          child: Text(
            "Espèce",
          ),
          value: "espece",
        ),
      ],
      hint: Text("Espèce"),
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.grey[200],
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
          ),
        ),
        hintStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      focusColor: Colors.red,
      onChanged: (choice) {
        value = choice!.obs;
        print(value);
      },
    );
  }

  Widget myContainer(CartModel cartItem) {
    return Dismissible(
      key: Key(cartItem.productId.toString()),
      onDismissed: (d) {
        print(d);
        controller.remove(cartItem);
        Get.snackbar("Suppression",
            "${cartItem.productName} à bien été supprimer dans le panier",
            duration: Duration(
              milliseconds: 900,
            ),
            backgroundColor: Colors.white);
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                // color: Colors.red,
                margin: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 99,
                          height: 99,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: Offset(0.5, .5),
                                blurRadius: 2.0,
                                spreadRadius: .5,
                              ),
                            ],
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  cartItem.images![0].srcPath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (cartItem.quantity! > 1) {
                                  // cartItem.quantity = cartItem.quantity! - 1;
                                  controller.decrement(cartItem);
                                }
                                print("object");
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.remove,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            Obx(() {
                              return controller.cart.isEmpty
                                  ? Text("")
                                  : Text(
                                      cartItem.quantity.toString(),
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                            }),
                            GestureDetector(
                              onTap: () {
                                if (cartItem.quantity! < 10) {
                                  controller.increment(cartItem);
                                }
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: maincolor,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        // color: Colors.red,
                        height: 100,
                        padding: EdgeInsets.only(top: 5, right: 5, left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cartItem.productName!,
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  cartItem.price! + 'FCFA',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: Text(
                                Config().parserHTMLTAG(cartItem.productDesc!),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
