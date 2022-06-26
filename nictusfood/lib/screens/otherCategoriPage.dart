// ignore_for_file: file_names, prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:badges/badges.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/controller/cart_state.dart';
import 'package:nictusfood/models/categorie.dart';
import 'package:nictusfood/screens/cart.dart';
import 'package:nictusfood/screens/productPage.dart';

class OtherCategoriePage extends StatefulWidget {
  final List<Category>? categories;
  const OtherCategoriePage({Key? key, required this.categories})
      : super(key: key);

  @override
  State<OtherCategoriePage> createState() => _OtherCategoriePageState();
}

class _OtherCategoriePageState extends State<OtherCategoriePage> {
  final double runSpacing = 15;
  final double spacing = 5;
  final columns = 2;
  final controller = Get.put(MyCartController());

  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.of(context).size.width - runSpacing * (columns - 1)) /
        columns;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: maincolor,
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
          child: Obx(() {
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
          }),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Avez vous faim?",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: maincolor,
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
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 120),
            padding: EdgeInsets.only(left: 5),
            child: SingleChildScrollView(
              child: Wrap(
                runSpacing: runSpacing,
                spacing: spacing,
                alignment: WrapAlignment.center,
                children: List.generate(widget.categories!.length, (index) {
                  return ElasticIn(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              ProductPage(
                                  category: widget.categories![index],
                                  isGrid: true),
                            );
                          },
                          child: Container(
                            width: w,
                            height: w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    widget.categories![index].image!),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                  offset: Offset(4, 8), // Shadow position
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment(0, 0.79),
                            child: Text(
                              widget.categories![index].categoryName!,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          // MyAppBar(),
        ],
      ),
    );
  }
}
