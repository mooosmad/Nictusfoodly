// ignore_for_file: file_names, prefer_const_constructors, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/controller/cart_state.dart';
import 'package:nictusfood/models/cartmodel.dart';
import 'package:nictusfood/models/product.dart';
import 'package:nictusfood/services/config.dart';

class DetailPage extends StatefulWidget {
  final Product? product;
  const DetailPage({Key? key, this.product}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final controller = Get.put(MyCartController());
  int nbr = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.8,
                child: Center(
                  child: CarouselSlider(
                      items: List.generate(widget.product!.images!.length,
                          (index) {
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
                        height: 400,
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
              )
            ],
          ),
          Expanded(
            child: Container(
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
              child: ListView(
                children: [
                  Center(
                    child: Text(
                      widget.product!.productName!,
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
                      Config().parserHTMLTAG(widget.product!.productDesc!),
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(),
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
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                  Center(
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

                        if (Config().isExistscart(controller.cart, cartItem)) {
                          print("EXISTE DEJA DANS MON PANIER");
                          var productToUpdate = controller.cart.firstWhere(
                              (element) =>
                                  element.productId ==
                                  widget.product!.productId);
                          productToUpdate.quantity = nbr.obs;
                          Get.snackbar("Panier",
                              "${widget.product!.productName} vient d'être modifié dans le panier",
                              duration: Duration(
                                milliseconds: 900,
                              ),
                              backgroundColor: Colors.white);
                        } else {
                          print("VIENT  D'ETRE AJOUTER DANS MON PANIER");
                          controller.cart.add(cartItem);
                          Get.snackbar(
                            "Panier",
                            "${widget.product!.productName} ajouté dans le panier",
                            duration: Duration(
                              milliseconds: 900,
                            ),
                            backgroundColor: Colors.white,
                          );
                        }
                        // Get.back();
                      },
                      child: Text(
                        "J'ajoute au panier",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
