// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_function_literals_in_foreach_calls

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/categorie.dart';
import 'package:nictusfood/models/customer.dart';
import 'package:nictusfood/screens/cart.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/screens/otherCategoriPage.dart';
import 'package:nictusfood/screens/productPage.dart';
import 'package:nictusfood/services/api_services.dart';
import 'package:nictusfood/widgets/myappbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:geocoding/geocoding.dart" as geo;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Customer? customer;
  List<Category> category = [];
  List<Map<String, List<Category>>> maincategory = [];
  Location location = Location();
  bool? serviceEnabled;
  bool? load = true;
  PermissionStatus? permissionGranted;
  LocationData? myLocation;
  String quartier = "";
  String myStreet = "";
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  checkPermission() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled!) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled!) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    myLocation = await location.getLocation();
    print(myLocation);

    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        myLocation!.latitude!, myLocation!.longitude!);

    quartier = placemarks[0].locality! + "," + placemarks[0].subLocality!;
    myStreet = placemarks[0].street!;

    setState(() {});
  }

  getCategory() async {
    category = await APIService().getCategorie();
    List<Category> othercategory = [];
    category.forEach((element) {
      if (element.categoryName == "Nos Tcheps" ||
          element.categoryName == "Boutique" ||
          element.categoryName == "Menu du jour" ||
          element.categoryName == "Promos") {
        maincategory.add({
          element.categoryName!: [element]
        });
      } else {
        othercategory.add(element);
      }
    });
    maincategory.add({"La carte": othercategory});
    load = false;

    if (mounted) {
      setState(() {});
    }
  }

  getCustomer() async {
    final prefs = await SharedPreferences.getInstance();
    String? idUser = prefs.getString("idUser") ?? "-1";
    if (idUser != "-1") {
      customer = await APIService().getUser(
        int.parse(idUser),
      );
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
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
          child: Image.asset(
            "assets/appassets/shopping-cart 1.png",
            width: 30,
          ),
        ),
      ),
      body: load!
          ? Loading()
          : Stack(
              children: [
                Container(
                  child: Center(
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          myCard(false, maincategory.last),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                myCard(false, maincategory[3]),
                                myCard(true, maincategory[2]),
                                myCard(false, maincategory[0]),
                              ],
                            ),
                          ),
                          myCard(false, maincategory[1]),
                        ],
                      ),
                    ),
                  ),
                ),
                MyAppBar()
              ],
            ),
    );
  }

  Widget myCard(bool iscenter, Map<String, List<Category>> categories) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (categories.keys.toList()[0] == "La carte") {
              Get.to(OtherCategoriePage());
            } else {
              Get.to(
                () {
                  return ProductPage(
                      category: categories.values.toList()[0][0]);
                },
                transition: Transition.downToUp,
              );
            }
          },
          child: Container(
            width: iscenter ? 140 : 120,
            height: iscenter ? 140 : 120,
            margin: EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Colors.white,
              image: categories.keys.toList()[0] == "La carte"
                  ? DecorationImage(
                      image: AssetImage("assets/appassets/menu 1.png"))
                  : DecorationImage(
                      image: NetworkImage(
                        categories.values.toList()[0][0].image!,
                      ),
                    ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment(0, 0.79),
            child: Text(
              categories.keys.toList()[0],
              style: GoogleFonts.poppins(
                textStyle: TextStyle(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
