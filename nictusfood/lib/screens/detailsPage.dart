// ignore_for_file: file_names, prefer_const_constructors, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/controller/cart_state.dart';
import 'package:nictusfood/models/cartmodel.dart';
import 'package:nictusfood/models/product.dart';
import 'package:nictusfood/screens/cart.dart';
import 'package:nictusfood/services/api_services.dart';
import 'package:nictusfood/services/config.dart';
import 'package:shimmer/shimmer.dart';

class DetailPage extends StatefulWidget {
  final Product? product;
  const DetailPage({Key? key, this.product}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final controller = Get.put(MyCartController());
  bool loadshimer = true;
  int nbr = 1;

  List<Product> suggestions = [];
  List<String> categorieName = [];

  getSuggestion() async {
    for (var element in widget.product!.produitSuggere!) {
      suggestions.add(await element);
    }

    print(suggestions.length);
    for (var element in suggestions) {
      categorieName.add(element.categorieName!);
    }
    categorieName = categorieName.toSet().toList();
    if (mounted) {
      setState(() {
        loadshimer = false;
      });
    }
  }

  @override
  void initState() {
    getSuggestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.8,
            child: Center(
              child: CarouselSlider(
                  items: List.generate(widget.product!.images!.length, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            widget.product!.images![index].srcPath!,
                          ),
                        ),
                      ),
                    );
                  }),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height / 2,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    initialPage: 0,
                    // enableInfiniteScroll: true,
                    // reverse: false,
                    // autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    // onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  )),
            ),
          ),
          Positioned(
            top: 23,
            left: 10,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_rounded),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.9,
            snapSizes: [.7, .8, .9],
            snap: true,
            builder: ((context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(1, 1),
                      blurRadius: 2.0,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade300,
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Center(
                            child: Text(
                              widget.product!.productName!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              Config()
                                  .parserHTMLTAG(widget.product!.productDesc!),
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              Config().parserHTMLTAG(
                                  widget.product!.price! + " FCFA"),
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (nbr > 1) {
                                    setState(() {
                                      nbr--;
                                    });
                                  }
                                },
                                child: Container(
                                  width: 25,
                                  height: 25,
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
                              Text(
                                nbr.toString(),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (nbr < 10) {
                                    setState(() {
                                      nbr++;
                                    });
                                  } else {
                                    Get.snackbar("Maximum atteint",
                                        "Impossible d'ajouter plus de 10",
                                        duration: Duration(
                                          milliseconds: 900,
                                        ),
                                        backgroundColor: Colors.white);
                                  }
                                },
                                child: Container(
                                  width: 25,
                                  height: 25,
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
                          SizedBox(height: 20),
                          if (loadshimer)
                            SizedBox(
                              height: 200,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: ListView.builder(
                                  itemBuilder: (_, __) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: loadShimer(),
                                  ),
                                  itemCount: 4,
                                ),
                              ),
                            ),
                          if (!loadshimer)
                            for (var element in categorieName)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 9, horizontal: 5),
                                // margin: EdgeInsets.symmetric(vertical: 9, horizontal: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      element,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    for (var produit in suggestions)
                                      if (produit.categorieName == element)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  text: produit.productName!,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: "  + " +
                                                          produit.price! +
                                                          " FCFA",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          fontSize: 14,
                                                          color: maincolor,
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                HapticFeedback.vibrate();

                                                print("object");
                                                //create new CartModel
                                                var cartItem = CartModel(
                                                  quantity: 1.obs,
                                                  price: produit.price,
                                                  productDesc:
                                                      produit.productDesc,
                                                  productName:
                                                      produit.productName,
                                                  images: produit.images,
                                                  productId: produit.productId,
                                                  regularPrice:
                                                      produit.regularPrice,
                                                  status: produit.status,
                                                );

                                                if (Config().isExistscart(
                                                    controller.cart,
                                                    cartItem)) {
                                                  print(
                                                      "EXISTE DEJA DANS MON PANIER");
                                                  var productToUpdate = controller
                                                      .cart
                                                      .firstWhere((element) =>
                                                          element.productId ==
                                                          produit.productId);
                                                  productToUpdate.quantity =
                                                      productToUpdate
                                                              .quantity! +
                                                          1;
                                                } else {
                                                  print(
                                                      "VIENT  D'ETRE AJOUTER DANS MON PANIER");
                                                  controller.cart.add(cartItem);
                                                  Get.snackbar("Panier",
                                                      "${produit.productName} ajouté dans le panier",
                                                      duration: Duration(
                                                        milliseconds: 900,
                                                      ),
                                                      backgroundColor:
                                                          Colors.white);
                                                }
                                              },
                                              child: SizedBox(
                                                width: 30,
                                                child: Image.asset(
                                                  "assets/appassets/shopping-cart 1.png",
                                                  cacheHeight: 25,
                                                  cacheWidth: 25,
                                                ),
                                                height: 30,
                                              ),
                                            ),
                                          ],
                                        )
                                  ],
                                ),
                              ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(maincolor),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                var cartItem = CartModel(
                                  quantity: nbr.obs,
                                  price: widget.product!.price,
                                  productDesc: widget.product!.productDesc,
                                  productName: widget.product!.productName,
                                  images: widget.product!.images,
                                  productId: widget.product!.productId,
                                  regularPrice: widget.product!.regularPrice,
                                  status: widget.product!.status,
                                );
                                var res = "exist";
                                if (Config()
                                    .isExistscart(controller.cart, cartItem)) {
                                  print("EXISTE DEJA DANS MON PANIER");
                                  setState(() {
                                    res = "exist";
                                  });
                                  var productToUpdate = controller.cart
                                      .firstWhere((element) =>
                                          element.productId ==
                                          widget.product!.productId);
                                  productToUpdate.quantity = nbr.obs;
                                  Get.snackbar(
                                    "Panier",
                                    "${widget.product!.productName} vient d'être modifié dans le panier",
                                    duration: Duration(
                                      milliseconds: 900,
                                    ),
                                    instantInit: false,
                                    backgroundColor: Colors.white,
                                  );
                                } else {
                                  print(
                                      "VIENT  D'ETRE AJOUTER DANS MON PANIER");
                                  res = "notexist";
                                  controller.cart.add(cartItem);
                                  Get.snackbar(
                                    "Panier",
                                    "${widget.product!.productName} ajouté dans le panier",
                                    duration: Duration(
                                      milliseconds: 900,
                                    ),
                                    backgroundColor: Colors.white,
                                    instantInit: false,
                                  );
                                }
                                // print(res);
                                Get.bottomSheet(
                                  CartPage(),
                                  enableDrag: true,
                                  isScrollControlled: true,
                                );
                              },
                              child: Text(
                                "J'achète",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          )
        ],
      ),
      // Expanded(
      //   child: Container(
      //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      //     width: double.infinity,
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.grey.withOpacity(0.5),
      //           offset: Offset(1, 1),
      //           blurRadius: 2.0,
      //           spreadRadius: 1,
      //         ),
      //       ],
      //     ),
      //     child: ListView(
      //       children: [
      //         Center(
      //           child: Text(
      //             widget.product!.productName!,
      //             textAlign: TextAlign.center,
      //             style: GoogleFonts.poppins(
      //               textStyle: TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: 30,
      //               ),
      //             ),
      //           ),
      //         ),
      //         SizedBox(
      //           height: 20,
      //         ),
      //         Center(
      //           child: Text(
      //             Config().parserHTMLTAG(widget.product!.productDesc!),
      //             style: GoogleFonts.poppins(
      //               textStyle: TextStyle(),
      //             ),
      //           ),
      //         ),
      //         Center(
      //           child: Text(
      //             Config().parserHTMLTAG(widget.product!.price! + " FCFA"),
      //             style: GoogleFonts.poppins(
      //               textStyle: TextStyle(
      //                   fontSize: 25, fontWeight: FontWeight.bold),
      //             ),
      //           ),
      //         ),
      //         SizedBox(
      //           height: 20,
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             GestureDetector(
      //               onTap: () {
      //                 if (nbr > 1) {
      //                   setState(() {
      //                     nbr--;
      //                   });
      //                 }
      //               },
      //               child: Container(
      //                 width: 25,
      //                 height: 25,
      //                 margin: EdgeInsets.symmetric(horizontal: 5),
      //                 decoration: BoxDecoration(
      //                   shape: BoxShape.circle,
      //                   color: Colors.grey.withOpacity(0.3),
      //                 ),
      //                 child: Center(
      //                   child: Icon(
      //                     Icons.remove,
      //                     size: 20,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             Text(
      //               nbr.toString(),
      //               style: GoogleFonts.poppins(
      //                 textStyle: TextStyle(
      //                     fontSize: 20, fontWeight: FontWeight.bold),
      //               ),
      //             ),
      //             GestureDetector(
      //               onTap: () {
      //                 if (nbr < 10) {
      //                   setState(() {
      //                     nbr++;
      //                   });
      //                 } else {
      //                   Get.snackbar("Maximum atteint",
      //                       "Impossible d'ajouter plus de 10",
      //                       duration: Duration(
      //                         milliseconds: 900,
      //                       ),
      //                       backgroundColor: Colors.white);
      //                 }
      //               },
      //               child: Container(
      //                 width: 25,
      //                 height: 25,
      //                 margin: EdgeInsets.symmetric(horizontal: 5),
      //                 decoration: BoxDecoration(
      //                   shape: BoxShape.circle,
      //                   color: maincolor,
      //                 ),
      //                 child: Center(
      //                   child: Icon(
      //                     Icons.add,
      //                     size: 20,
      //                     color: Colors.white,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //         SizedBox(height: 20),
      //         if (loadshimer)
      //           SizedBox(
      //             height: 200,
      //             child: Shimmer.fromColors(
      //               baseColor: Colors.grey.shade300,
      //               highlightColor: Colors.grey.shade100,
      //               enabled: true,
      //               child: ListView.builder(
      //                 itemBuilder: (_, __) => Padding(
      //                   padding: const EdgeInsets.only(bottom: 8.0),
      //                   child: loadShimer(),
      //                 ),
      //                 itemCount: 4,
      //               ),
      //             ),
      //           ),
      //         if (!loadshimer)
      //           for (var element in categorieName)
      //             Container(
      //               width: double.infinity,
      //               padding:
      //                   EdgeInsets.symmetric(vertical: 9, horizontal: 5),
      //               // margin: EdgeInsets.symmetric(vertical: 9, horizontal: 5),
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     element,
      //                     style: GoogleFonts.poppins(
      //                       textStyle: TextStyle(
      //                           fontSize: 16, fontWeight: FontWeight.bold),
      //                     ),
      //                   ),
      //                   for (var produit in suggestions)
      //                     if (produit.categorieName == element)
      //                       Row(
      //                         mainAxisAlignment:
      //                             MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           RichText(
      //                             text: TextSpan(
      //                                 text: produit.productName!,
      //                                 style: GoogleFonts.poppins(
      //                                   textStyle: TextStyle(
      //                                     fontSize: 14,
      //                                     color: Colors.black,
      //                                   ),
      //                                 ),
      //                                 children: [
      //                                   TextSpan(
      //                                     text: "  + " +
      //                                         produit.price! +
      //                                         " FCFA",
      //                                     style: GoogleFonts.poppins(
      //                                       textStyle: TextStyle(
      //                                         fontSize: 14,
      //                                         color: maincolor,
      //                                       ),
      //                                     ),
      //                                   )
      //                                 ]),
      //                           ),
      //                           InkWell(
      //                             onTap: () {
      //                               HapticFeedback.vibrate();

      //                               print("object");
      //                               //create new CartModel
      //                               var cartItem = CartModel(
      //                                 quantity: 1.obs,
      //                                 price: produit.price,
      //                                 productDesc: produit.productDesc,
      //                                 productName: produit.productName,
      //                                 images: produit.images,
      //                                 productId: produit.productId,
      //                                 regularPrice: produit.regularPrice,
      //                                 status: produit.status,
      //                               );

      //                               if (Config().isExistscart(
      //                                   controller.cart, cartItem)) {
      //                                 print("EXISTE DEJA DANS MON PANIER");
      //                                 var productToUpdate = controller.cart
      //                                     .firstWhere((element) =>
      //                                         element.productId ==
      //                                         produit.productId);
      //                                 productToUpdate.quantity =
      //                                     productToUpdate.quantity! + 1;
      //                               } else {
      //                                 print(
      //                                     "VIENT  D'ETRE AJOUTER DANS MON PANIER");
      //                                 controller.cart.add(cartItem);
      //                                 Get.snackbar("Panier",
      //                                     "${produit.productName} ajouté dans le panier",
      //                                     duration: Duration(
      //                                       milliseconds: 900,
      //                                     ),
      //                                     backgroundColor: Colors.white);
      //                               }
      //                             },
      //                             child: SizedBox(
      //                               width: 30,
      //                               child: Image.asset(
      //                                 "assets/appassets/shopping-cart 1.png",
      //                                 cacheHeight: 25,
      //                                 cacheWidth: 25,
      //                               ),
      //                               height: 30,
      //                             ),
      //                           ),
      //                         ],
      //                       )
      //                 ],
      //               ),
      //             ),
      //         SizedBox(height: 20),
      //         Center(
      //           child: ElevatedButton(
      //             style: ButtonStyle(
      //               backgroundColor: MaterialStateProperty.all(maincolor),
      //               padding: MaterialStateProperty.all(
      //                 EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      //               ),
      //               shape: MaterialStateProperty.all(
      //                 RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(10),
      //                 ),
      //               ),
      //             ),
      //             onPressed: () {
      //               var cartItem = CartModel(
      //                 quantity: nbr.obs,
      //                 price: widget.product!.price,
      //                 productDesc: widget.product!.productDesc,
      //                 productName: widget.product!.productName,
      //                 images: widget.product!.images,
      //                 productId: widget.product!.productId,
      //                 regularPrice: widget.product!.regularPrice,
      //                 status: widget.product!.status,
      //               );
      //               var res = "exist";
      //               if (Config().isExistscart(controller.cart, cartItem)) {
      //                 print("EXISTE DEJA DANS MON PANIER");
      //                 setState(() {
      //                   res = "exist";
      //                 });
      //                 var productToUpdate = controller.cart.firstWhere(
      //                     (element) =>
      //                         element.productId ==
      //                         widget.product!.productId);
      //                 productToUpdate.quantity = nbr.obs;
      //                 Get.snackbar(
      //                   "Panier",
      //                   "${widget.product!.productName} vient d'être modifié dans le panier",
      //                   duration: Duration(
      //                     milliseconds: 900,
      //                   ),
      //                   instantInit: false,
      //                   backgroundColor: Colors.white,
      //                 );
      //               } else {
      //                 print("VIENT  D'ETRE AJOUTER DANS MON PANIER");
      //                 res = "notexist";
      //                 controller.cart.add(cartItem);
      //                 Get.snackbar(
      //                   "Panier",
      //                   "${widget.product!.productName} ajouté dans le panier",
      //                   duration: Duration(
      //                     milliseconds: 900,
      //                   ),
      //                   backgroundColor: Colors.white,
      //                   instantInit: false,
      //                 );
      //               }
      //               // print(res);
      //               Get.back();
      //             },
      //             child: Text(
      //               "J'achète",
      //               style: GoogleFonts.poppins(
      //                 textStyle: TextStyle(
      //                     fontSize: 20, fontWeight: FontWeight.bold),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget loadShimer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            width: 100,
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                width: 200,
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: 30,
                height: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
