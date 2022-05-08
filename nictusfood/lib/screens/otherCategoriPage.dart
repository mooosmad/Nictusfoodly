// ignore_for_file: file_names

import "package:flutter/material.dart";
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/categorie.dart';

class OtherCategoriePage extends StatefulWidget {
  final List<Category>? categories;
  const OtherCategoriePage({Key? key, this.categories}) : super(key: key);

  @override
  State<OtherCategoriePage> createState() => _OtherCategoriePageState();
}

class _OtherCategoriePageState extends State<OtherCategoriePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: maincolor,
      body: Stack(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
          ),
          // MyAppBar(

          // ),
        ],
      ),
    );
  }
}
