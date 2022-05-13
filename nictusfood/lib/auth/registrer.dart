// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:nictusfood/Components/background.dart';
import 'package:nictusfood/auth/login.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/customermodel.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/services/api_services.dart';
import "package:geocoding/geocoding.dart" as geo;
import 'package:nictusfood/services/config.dart';

class RegisterScreen extends StatefulWidget {
  final bool? isdrawer;
  const RegisterScreen({Key? key, required this.isdrawer}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with WidgetsBindingObserver {
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController nomComplet = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController numero = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController ville = TextEditingController();

  TextEditingController password = TextEditingController();
  TextEditingController retapepassword = TextEditingController();
  bool load = false;
  bool isApiCallProcess = false;

  // for maps
  MapboxMapController? controller;
  Location location = Location();
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;
  LocationData? myLocation;
  String quartier = "";
  String myStreet = "";

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

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    checkPermission();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        setState(() {
          controller!;
        });
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: load
          ? Loading()
          : SingleChildScrollView(
              child: Background(
                child: Form(
                  key: formGlobalKey,
                  child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "INSCRIPTION",
                          style: Theme.of(context).textTheme.headline1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          controller: nomComplet,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Champ vide";
                            }
                            return null;
                          },
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFfd9204),
                              ),
                            ),
                            hintText: 'Nom Complet',
                            hintStyle: Theme.of(context).textTheme.headline3,
                            prefixIcon: const Icon(Icons.person,
                                color: Color(0xFF37474F)),
                          ),
                          cursorColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                          ),
                          controller: email,
                          validator: (entry) {
                            if (!EmailValidator.validate(entry!)) {
                              return "email non valide";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFfd9204),
                              ),
                            ),
                            hintText: 'Email',
                            hintStyle: Theme.of(context).textTheme.headline3,
                            prefixIcon: const Icon(Icons.mail,
                                color: Color(0xFF37474F)),
                          ),
                          cursorColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          controller: numero,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Champ vide";
                            }
                            return null;
                          },
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFfd9204),
                              ),
                            ),
                            hintText: 'Numero de telephone',
                            hintStyle: Theme.of(context).textTheme.headline3,
                            prefixIcon: const Icon(Icons.phone,
                                color: Color(0xFF37474F)),
                          ),
                          cursorColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Get.bottomSheet(
                            myMaps(),
                            enableDrag: false,
                            isScrollControlled: true,
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            enabled: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ vide";
                              }
                              return null;
                            },
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                            ),
                            controller: adresse,
                            decoration: InputDecoration(
                              fillColor: Colors.grey[200],
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFfd9204),
                                ),
                              ),
                              hintText: 'Adresse',
                              hintStyle: Theme.of(context).textTheme.headline3,
                              prefixIcon: const Icon(Icons.location_on_rounded,
                                  color: Color(0xFF37474F)),
                            ),
                            cursorColor: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                          ),
                          obscureText: true,
                          controller: password,
                          validator: ((value) {
                            if (value!.length < 6) {
                              return "Mot de passe trop court";
                            } else if (value.isEmpty) {
                              return "Champ vide";
                            }
                            return null;
                          }),
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFfd9204),
                              ),
                            ),
                            hintText: 'Mot de passe',
                            hintStyle: Theme.of(context).textTheme.headline3,
                            prefixIcon: const Icon(Icons.lock,
                                color: Color(0xFF37474F)),
                          ),
                          cursorColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                          ),
                          obscureText: true,
                          controller: retapepassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Champ vide";
                            } else if (value != password.text) {
                              return "mot de passe different";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFfd9204),
                              ),
                            ),
                            hintText: 'Confirmer le mot de passe',
                            hintStyle: Theme.of(context).textTheme.headline3,
                            prefixIcon: const Icon(Icons.lock,
                                color: Color(0xFF37474F)),
                          ),
                          cursorColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: RaisedButton(
                          onPressed: () {
                            if (formGlobalKey.currentState!.validate()) {
                              String firstname = nomComplet.text.split(" ")[0];
                              String lastname = nomComplet.text;
                              // on doit trouver c'est quoi le nom et le prenom dans nomcoplet
                              CustomerModel model = CustomerModel(
                                email.text,
                                firstname,
                                lastname,
                                password.text,
                                adresse.text,
                                ville.text,
                                numero.text,
                              );
                              setState(() {
                                load = true;
                              });

                              print(model.toJson());

                              setState(() {
                                isApiCallProcess = true;
                              });
                              APIService().createCustomer(model).then((ret) {
                                setState(() {
                                  isApiCallProcess = false;
                                });
                                // if ret[0] is true reussi
                                if (ret![0]) {
                                  Fluttertoast.showToast(
                                      msg: "Inscription effectué avec succès");
                                  if (widget.isdrawer!) {
                                    Get.back();
                                    Get.back();
                                  } else {
                                    Get.back();
                                  }
                                } else {
                                  setState(() {
                                    load = false;
                                  });
                                }
                              });
                            } else {
                              print("noo");
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            width: size.width * 1.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 136, 34),
                                  Color.fromARGB(255, 255, 177, 41)
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(0),
                            child: const Text(
                              "S'inscrire",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            Get.off(
                              LoginScreen(
                                isdrawer: false,
                              ),
                              transition: Transition.downToUp,
                            );
                          },
                          child: Text(
                            "J'ai déjà un compte? Connectez-vous",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: maincolor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget myMaps() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  "votre adresse",
                  style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 310,
                  width: double.infinity,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  child: myLocation != null
                      ? Stack(
                          children: [
                            MapboxMap(
                              onMapCreated: (MapboxMapController c) async {
                                controller = c;
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                              accessToken:
                                  "sk.eyJ1IjoicGlvdXBpb3VkZXYiLCJhIjoiY2wzM2llYzhvMHVsbjNjcDlpeWx3azl2byJ9.SGXRi8GH5w_Oser89rhLnA",
                              styleString:
                                  "mapbox://styles/pioupioudev/cl33ha6ch001l14qctquv6799",
                              initialCameraPosition: CameraPosition(
                                zoom: 14,
                                target: LatLng(myLocation!.latitude!,
                                    myLocation!.longitude!),
                              ),
                              myLocationEnabled: true,
                              trackCameraPosition: true,
                            ),
                            Center(
                              child: Container(
                                height: 60,
                                width: 45,
                                child: Image.asset(
                                  "assets/appassets/marker.png",
                                  frameBuilder: (context, child, frame,
                                      wasSynchronouslyLoaded) {
                                    return Transform.translate(
                                      offset: const Offset(0, -17),
                                      child: child,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () async {
                  LatLng newpos = controller!.cameraPosition!.target;
                  var street = await Config()
                      .getNameOfStreet(newpos.latitude, newpos.longitude);
                  ville.text = await Config()
                      .getNameOfQuartier(newpos.latitude, newpos.longitude);
                  adresse.text = street;

                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: maincolor,
                  ),
                  child: Center(
                    child: Text(
                      "Valider",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              // Get.back();
            },
            child: Container(
              width: 30,
              height: 30,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: maincolor),
              child: Center(
                child: Icon(Icons.clear, color: Colors.white),
              ),
            ),
          ),
        ),
        Positioned(
          top: -12,
          left: (MediaQuery.of(context).size.width / 2) - 25,
          child: Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }
}
