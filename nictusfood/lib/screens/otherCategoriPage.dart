// ignore_for_file: file_names, prefer_const_constructors

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/categorie.dart';
import 'package:nictusfood/screens/productPage.dart';
import 'package:nictusfood/widgets/myappbar.dart';

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
  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.of(context).size.width - runSpacing * (columns - 1)) /
        columns;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: maincolor,
      body: Stack(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
            padding: EdgeInsets.only(top: 10, left: 5),
            child: SingleChildScrollView(
              child: Wrap(
                runSpacing: runSpacing,
                spacing: spacing,
                alignment: WrapAlignment.center,
                children: List.generate(widget.categories!.length, (index) {
                  return Stack(
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
                  );
                }),
              ),
            ),
          ),
          MyAppBar(),
        ],
      ),
    );
  }
}
