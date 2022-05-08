// ignore_for_file: prefer_const_constructors, file_names

import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/categorie.dart';
import 'package:nictusfood/models/product.dart';
import 'package:nictusfood/screens/cart.dart';
import 'package:nictusfood/screens/detailsPage.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/services/api_services.dart';
import 'package:nictusfood/services/config.dart';

class ProductPage extends StatefulWidget {
  final Category? category;
  const ProductPage({Key? key, required this.category}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product>? products = [];
  bool load = false;
  getProductByCategorie() async {
    setState(() {
      load = true;
    });
    products =
        await APIService().getProductByCategorie(widget.category!.categoryId!);
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
          child: Image.asset(
            "assets/appassets/shopping-cart 1.png",
            width: 30,
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
                  automaticallyImplyLeading: false,
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
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
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                if (products!.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        return myContainer(products![i]);
                      },
                      childCount: products!.length,
                    ),
                  )
              ],
            ),
    );
  }

  Widget myContainer(Product product) {
    return GestureDetector(
      onTap: () {
        Get.to(
            DetailPage(
              product: product,
            ),
            transition: Transition.rightToLeft);
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
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
                    padding: EdgeInsets.only(top: 5, right: 5, left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.productName!,
                              style: GoogleFonts.poppins(
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                product.price! + 'FCFA',
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: Text(
                            Config().parserHTMLTAG(product.productDesc!),
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   width: 70,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [

                //
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
