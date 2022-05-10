// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/constant/colors.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/appassets/Plan de travail 2 copie 13-8 1.png",
            width: 80,
            height: 120,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 11, left: 5),
              padding: EdgeInsets.only(left: 5, right: 5, top: 15),
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: TextFormField(
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(),
                  ),
                  decoration: InputDecoration(
                    hintText: "Avez vous faim?",
                    hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Get.to(LoginScreen());
            },
            child: Container(
              child: Icon(
                Icons.person,
                color: maincolor,
              ),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
