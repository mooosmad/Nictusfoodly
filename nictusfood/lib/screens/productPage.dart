// ignore_for_file: prefer_const_constructors, file_names, avoid_print, sized_box_for_whitespace

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/controller/cart_state.dart';
import 'package:nictusfood/models/cartmodel.dart';
import 'package:nictusfood/models/categorie.dart';
import 'package:nictusfood/models/product.dart';
import 'package:nictusfood/screens/cart.dart';
import 'package:nictusfood/screens/detailsPage.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/services/api_services.dart';
import 'package:nictusfood/services/config.dart';

class ProductPage extends StatefulWidget {
  final Category? category;
  final bool? isGrid;
  const ProductPage({Key? key, required this.category, required this.isGrid})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product>? products = [];
  List<Map<String, dynamic>>? idSuggestion = [];

  bool load = false;
  final controller = Get.put(MyCartController());
  var top = 0.0;

  getProductByCategorie() async {
    setState(() {
      load = true;
    });
    products =
        await APIService().getProductByCategorie(widget.category!.categoryId!);

    print("*******");
    print(widget.category!.categoryId);
    print("*******");
    if (widget.category!.categoryName == "Nos Tcheps") {
      idSuggestion = [
        {"boissons": 19},
        {"dessert": 31},
      ];
    }
    if (mounted) {
      setState(() {
        load = false;
      });
    }
  }

  @override
  void initState() {
    getProductByCategorie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Get.bottomSheet(
            CartPage(),
            enableDrag: true,
            isScrollControlled: true,
          );
        },
        child: Center(
          child: Obx(
            () {
              return controller.cart.isNotEmpty
                  ? Badge(
                      toAnimate: false,
                      badgeContent: Text(
                        controller.cart.length > 9
                            ? "9+"
                            : controller.cart.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Image.asset(
                        "assets/appassets/shopping-cart 1.png",
                        width: 30,
                      ),
                    )
                  : Image.asset(
                      "assets/appassets/shopping-cart 1.png",
                      width: 30,
                    );
            },
          ),
        ),
      ),
      body: load
          ? Loading()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: maincolor,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                  // automaticallyImplyLeading: false,
                  expandedHeight: 200,

                  flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                    top = constraints.biggest.height;
                    print(top); // if 80 c'est que c'est reduit
                    return FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        widget.category!.categoryName!.toUpperCase(),
                        style: TextStyle(
                          shadows: <Shadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              offset: Offset(2, 2),
                              blurRadius: 2.0,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      background: Image.asset(
                        'assets/appassets/image 2.png',
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                if (products!.isNotEmpty)
                  widget.isGrid!
                      ? SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              return myContainer(products![i]);
                            },
                            childCount: products!.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            childAspectRatio: 0.9,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              return myContainer(products![i]);
                            },
                            childCount: products!.length,
                          ),
                        ),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: 80),
                ),
              ],
            ),
    );
  }

  Widget myContainer(Product product) {
    return widget.isGrid!
        ? InkWell(
            onTap: () async {
              HapticFeedback.vibrate();
              var res = await Get.to(
                DetailPage(
                  product: product,
                  idSuggestions: idSuggestion!,
                ),
                transition: Transition.rightToLeft,
              );
              print(res);
            },
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            product.images![0].srcPath!,
                          ),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: Offset(0.5, 1),
                            blurRadius: 2.0,
                            spreadRadius: .5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  product.productName!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        product.price! + 'FCFA',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        HapticFeedback.vibrate();

                        print("object");
                        //create new CartModel
                        var cartItem = CartModel(
                          quantity: 1.obs,
                          price: product.price,
                          productDesc: product.productDesc,
                          productName: product.productName,
                          images: product.images,
                          productId: product.productId,
                          regularPrice: product.regularPrice,
                          status: product.status,
                        );

                        if (Config().isExistscart(controller.cart, cartItem)) {
                          print("EXISTE DEJA DANS MON PANIER");
                          var productToUpdate = controller.cart.firstWhere(
                              (element) =>
                                  element.productId == product.productId);
                          productToUpdate.quantity =
                              productToUpdate.quantity! + 1;
                        } else {
                          print("VIENT  D'ETRE AJOUTER DANS MON PANIER");
                          controller.cart.add(cartItem);
                          Get.snackbar("Panier",
                              "${product.productName} ajouté dans le panier",
                              duration: Duration(
                                milliseconds: 900,
                              ),
                              backgroundColor: Colors.white);
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
          )
        : Column(
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(
                          DetailPage(
                            product: product,
                            idSuggestions: idSuggestion!,
                          ),
                          transition: Transition.rightToLeft);
                    },
                    child: Container(
                      // color: Colors.red,
                      margin: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      child: Row(
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
                                    product.images![0].srcPath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 100,
                              padding:
                                  EdgeInsets.only(top: 5, right: 5, left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        product.productName!,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          product.price! + 'FCFA',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Expanded(
                                    child: Text(
                                      Config()
                                          .parserHTMLTAG(product.productDesc!),
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
                  ),
                  Positioned(
                    bottom: 2,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        print("object");
                        //create new CartModel
                        var cartItem = CartModel(
                          quantity: 1.obs,
                          price: product.price,
                          productDesc: product.productDesc,
                          productName: product.productName,
                          images: product.images,
                          productId: product.productId,
                          regularPrice: product.regularPrice,
                          status: product.status,
                        );

                        if (Config().isExistscart(controller.cart, cartItem)) {
                          print("EXISTE DEJA DANS MON PANIER");
                          var productToUpdate = controller.cart.firstWhere(
                              (element) =>
                                  element.productId == product.productId);
                          productToUpdate.quantity =
                              productToUpdate.quantity! + 1;
                        } else {
                          print("VIENT  D'ETRE AJOUTER DANS MON PANIER");
                          controller.cart.add(cartItem);
                          Get.snackbar(
                            "Panier",
                            "${product.productName} ajouté dans le panier",
                            duration: Duration(
                              milliseconds: 900,
                            ),
                            backgroundColor: Colors.white,
                          );
                        }
                      },
                      child: Container(
                        width: 30,
                        child: Image.asset(
                          "assets/appassets/shopping-cart 1.png",
                          cacheHeight: 25,
                          cacheWidth: 25,
                        ),
                        height: 30,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
            ],
          );
  }
}
