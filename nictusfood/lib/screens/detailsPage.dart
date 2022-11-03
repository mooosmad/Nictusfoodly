// ignore_for_file: file_names, prefer_const_constructors, avoid_print

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
import 'package:nictusfood/services/config.dart';
import 'package:shimmer/shimmer.dart';

class DetailPage extends StatefulWidget {
  final Product? product;
  const DetailPage({Key? key, this.product}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class CategorieName {
  final String? name;
  bool? isShow = false;

  CategorieName({this.name, this.isShow});
}

class _DetailPageState extends State<DetailPage> {
  final controller = Get.put(MyCartController());

  bool loadshimer = true;
  int nbr = 1;
  int suggestionsCount = 0;
  int suggestionNombre = 0;
  int suggestionPrice = 0;
  List<Product> suggestions = [];
  List<CategorieName> categorieName = [];

  getSuggestion() async {
    for (var element in widget.product!.produitSuggere!) {
      suggestions.add(await element);
    }

    print(suggestions.length);
    for (var element in suggestions) {
      categorieName.add(CategorieName(name: element.categorieName!));
    }
    categorieName = categorieName.toSet().toList();
    getLengthOnItemInSuggestion();

    if (mounted) {
      setState(() {
        loadshimer = false;
      });
    }
  }

  void suppressionInTheCart(CartModel cartItem) {
    controller.remove(cartItem);

    Get.snackbar("Suppression",
        "${cartItem.productName} à bien été supprimer dans le panier",
        duration: Duration(
          milliseconds: 900,
        ),
        instantInit: false,
        backgroundColor: Colors.white);
  }

  void addIntTheCart(CartModel cartItem) {
    controller.cart.add(cartItem);
    Get.snackbar("Panier", "${cartItem.productName} ajouté dans le panier",
        duration: Duration(
          milliseconds: 900,
        ),
        backgroundColor: Colors.white);
  }

  void getLengthOnItemInSuggestion() {
    int nbr = 0;
    int prix = 0;
    for (var produit in suggestions) {
      CartModel cartItem = CartModel(
        quantity: 1.obs,
        price: produit.price,
        productDesc: produit.productDesc,
        productName: produit.productName,
        images: produit.images,
        productId: produit.productId,
        regularPrice: produit.regularPrice,
        status: produit.status,
      );
      if (Config().isExistscart(controller.cart, cartItem)) {
        nbr++;
        prix += int.parse(cartItem.price!);
      }
    }
    setState(() {
      suggestionNombre = nbr;
      suggestionPrice = prix;
    });
    print("***********************");
    print(suggestionPrice);

    // return {"nombreSuggestions": nbr, "prixSuggestion": prix};
  }

  @override
  void initState() {
    getSuggestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
        height: 100,
        child: Center(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(maincolor),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
              // ignore: unused_local_variable
              var res = "exist";
              if (Config().isExistscart(controller.cart, cartItem)) {
                print("EXISTE DEJA DANS MON PANIER");
                setState(() {
                  res = "exist";
                });
                var productToUpdate = controller.cart.firstWhere((element) =>
                    element.productId == widget.product!.productId);
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
                print("VIENT  D'ETRE AJOUTER DANS MON PANIER");
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
              "Je commande ${nbr.obs + suggestionNombre} à ${int.parse(widget.product!.regularPrice!) * nbr.obs.toInt() + suggestionPrice}",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.6,
            child: Center(
              child: CarouselSlider(
                  items: List.generate(widget.product!.images!.length, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.product!.images![index].srcPath!,
                          ),
                          fit: BoxFit.cover,
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
            snapSizes: const [.7, .8, .9],
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
                        physics: BouncingScrollPhysics(),
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
                                  "${widget.product!.price!} FCFA"),
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
                           categorieName.isNotEmpty ? Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "Suggestion à ajouter au panier",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ) : Container(),
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
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (element.isShow == true) {
                                              element.isShow = false;
                                            } else {
                                              element.isShow = true;
                                            }
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              element.name!,
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              child: Icon(
                                                element.isShow == true
                                                    ? Icons.arrow_downward
                                                    : Icons.arrow_forward_ios,
                                                size: 12,
                                              ),
                                            )
                                          ],
                                        )),
                                    for (var produit in suggestions)
                                      if (produit.categorieName == element.name)
                                        AnimatedContainer(
                                          height:
                                              element.isShow == true ? null : 0,
                                          duration: Duration(milliseconds: 300),
                                          child: Row(
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
                                                        text:
                                                            "  + ${produit.price!} FCFA",
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
                                              element.isShow == true
                                                  ? Builder(builder: (context) {
                                                      var cartItem = CartModel(
                                                        quantity: 1.obs,
                                                        price: produit.price,
                                                        productDesc:
                                                            produit.productDesc,
                                                        productName:
                                                            produit.productName,
                                                        images: produit.images,
                                                        productId:
                                                            produit.productId,
                                                        regularPrice: produit
                                                            .regularPrice,
                                                        status: produit.status,
                                                      );
                                                      return Obx(() {
                                                        return InkWell(
                                                          onTap: () {
                                                            if (Config()
                                                                .isExistscart(
                                                                    controller
                                                                        .cart,
                                                                    cartItem)) {
                                                              suppressionInTheCart(
                                                                  cartItem);
                                                            } else {
                                                              addIntTheCart(
                                                                  cartItem);
                                                            }

                                                            getLengthOnItemInSuggestion();
                                                          },
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Config().isExistscart(
                                                                      controller
                                                                          .cart,
                                                                      cartItem)
                                                                  ? Colors.green
                                                                  : maincolor,
                                                            ),
                                                            child: Center(
                                                                child: Icon(
                                                              Config().isExistscart(
                                                                      controller
                                                                          .cart,
                                                                      cartItem)
                                                                  ? Icons.check
                                                                  : Icons.add,
                                                              size: 15,
                                                            )),
                                                          ),
                                                        );
                                                      });
                                                    })
                                                  : Container(),
                                            ],
                                          ),
                                        )
                                  ],
                                ),
                              ),
                          SizedBox(height: 20),
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
    return Column(
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
    );
  }
}
