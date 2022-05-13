// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:nictusfood/auth/login.dart';
import 'package:nictusfood/auth/registrer.dart';
import 'package:nictusfood/auth/update.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/controller/cart_state.dart';
import 'package:nictusfood/models/categorie.dart';
import 'package:nictusfood/models/customer.dart';
import 'package:nictusfood/screens/cart.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/screens/otherCategoriPage.dart';
import 'package:nictusfood/screens/productPage.dart';
import 'package:nictusfood/services/api_services.dart';
import 'package:nictusfood/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? idUser;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _advancedDrawerController = AdvancedDrawerController();
  StreamController<Customer?> streamController = StreamController();
  final controller = Get.put(MyCartController());

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

    quartier = await Config()
        .getNameOfQuartier(myLocation!.latitude!, myLocation!.longitude!);
    myStreet = await Config()
        .getNameOfStreet(myLocation!.latitude!, myLocation!.longitude!);

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
    idUser = prefs.getString("idUser") ?? "-1";
    if (idUser != "-1") {
      customer = await APIService().getUser(
        int.parse(idUser!),
      );
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<Customer?> returnCustomer() async {
    final prefs = await SharedPreferences.getInstance();
    idUser = prefs.getString("idUser") ?? "-1";
    if (idUser != "-1") {
      customer = await APIService().getUser(
        int.parse(idUser!),
      );
      return customer;
    } else {
      return Customer(id: -1);
    }
  }

  @override
  void dispose() {
    _advancedDrawerController.dispose();
    super.dispose();
  }

  updateSink() async {
    streamController.sink.add(await returnCustomer());
  }

  @override
  void initState() {
    getCategory();
    Timer.periodic(Duration(seconds: 1), (timer) {
      updateSink();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_advancedDrawerController.value == AdvancedDrawerValue.visible()) {
          _advancedDrawerController.hideDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: AdvancedDrawer(
        drawer: StreamBuilder<Customer?>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                if (snapshot.hasData) {
                  final res = snapshot.data;

                  return res!.id != -1
                      ? SafeArea(
                          child: Container(
                            child: ListTileTheme(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 128.0,
                                    height: 128.0,
                                    margin: const EdgeInsets.only(
                                      top: 24.0,
                                      bottom: 64.0,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      shape: BoxShape.circle,
                                    ),
                                    child: idUser != null
                                        ? Container(
                                            child: CachedNetworkImage(
                                              imageUrl: customer!.urlPic!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Get.to(
                                          UpdapteScreen(
                                            customer: customer,
                                            idUser: idUser,
                                          ),
                                          transition: Transition.downToUp);
                                    },
                                    leading: Icon(Icons.account_circle_rounded),
                                    title: Text('Profile'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      APIService().getOrder(int.parse(idUser!));
                                    },
                                    leading: Icon(Icons.apps_sharp),
                                    title: Text('Mes commandes'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Get.defaultDialog(
                                        title: "Deconnexion",
                                        titleStyle: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                        contentPadding: EdgeInsets.all(10),
                                        content: Text(
                                          "Voulez-vous vraiment vous deconnectez? vous predrez votre panier.",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        confirm: TextButton(
                                          onPressed: () async {
                                            _advancedDrawerController
                                                .hideDrawer();
                                            await APIService().logout();

                                            setState(() {
                                              load = true;
                                            });
                                            Future.delayed(
                                                Duration(seconds: 1));
                                            setState(() {
                                              load = false;
                                            });

                                            Get.back();
                                          },
                                          child: Text(
                                            "Oui",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        cancel: TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text("Non"),
                                        ),
                                      );
                                    },
                                    leading: Icon(Icons.settings),
                                    title: Text('Deconnexion'),
                                  ),
                                  Spacer(),
                                  DefaultTextStyle(
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white54,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                      ),
                                      child: Text(
                                          'Terms of Service | Privacy Policy'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SafeArea(
                          child: Container(
                            child: ListTileTheme(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 128.0,
                                    height: 128.0,
                                    margin: const EdgeInsets.only(
                                      top: 24.0,
                                      bottom: 64.0,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      shape: BoxShape.circle,
                                    ),
                                    child: idUser != null
                                        ? Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Text(
                                                "Veuillez Vous Conntecter",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Get.to(
                                        LoginScreen(
                                          isdrawer: true,
                                        ),
                                        transition: Transition.downToUp,
                                      );
                                    },
                                    leading: Icon(Icons.home),
                                    title: Text('Connexion'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Get.to(
                                        RegisterScreen(
                                          isdrawer: true,
                                        ),
                                        transition: Transition.downToUp,
                                      );
                                    },
                                    leading: Icon(Icons.account_circle_rounded),
                                    title: Text('Inscription'),
                                  ),
                                  Spacer(),
                                  DefaultTextStyle(
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white54,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                      ),
                                      child: Text(
                                          'Terms of Service | Privacy Policy'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                } else {
                  return Center(child: Text("No data"));
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
            }),
        backdropColor: Colors.blueGrey.shade400,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: true,
        disabledGestures: true,
        child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: false,
          backgroundColor: maincolor,
          floatingActionButton: load!
              ? null
              : FloatingActionButton(
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
                    myAppBar(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget myAppBar() {
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
          // Expanded(
          //   child: Container(
          //     margin: EdgeInsets.only(right: 11, left: 5),
          //     padding: EdgeInsets.only(left: 5, right: 5, top: 15),
          //     height: 35,
          //     decoration: BoxDecoration(
          //         color: Colors.white, borderRadius: BorderRadius.circular(15)),
          //     child: Center(
          //       child: TextFormField(
          //         style: GoogleFonts.poppins(
          //           textStyle: TextStyle(),
          //         ),
          //         decoration: InputDecoration(
          //           hintText: "Avez vous faim?",
          //           hintStyle: GoogleFonts.poppins(
          //             textStyle: TextStyle(),
          //           ),
          //           border: InputBorder.none,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              _advancedDrawerController.showDrawer();
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

  Widget myCard(bool iscenter, Map<String, List<Category>> categories) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (categories.keys.toList()[0] == "La carte") {
              Get.to(
                OtherCategoriePage(
                  categories: categories["La carte"],
                ),
                transition: Transition.downToUp,
              );
            } else {
              Get.to(
                () {
                  return ProductPage(
                    category: categories.values.toList()[0][0],
                    isGrid: false,
                  );
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
