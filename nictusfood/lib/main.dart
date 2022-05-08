// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nictusfood/screens/home.dart';
import 'package:nictusfood/themes/nictustheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Nictustheme.light();
    return GetMaterialApp(
      theme: theme,
      home: Home(),
      title: "Nictus",
      debugShowCheckedModeBanner: false,
    );
  }
}
