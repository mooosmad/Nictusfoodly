// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print

import 'dart:async';
import 'package:email_auth/email_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:map_picker/map_picker.dart';
import 'package:nictusfood/Components/background.dart';
import 'package:nictusfood/auth/confirmemail.dart';
import 'package:nictusfood/auth/login.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nictusfood/models/customermodel.dart';
import 'package:nictusfood/screens/loading.dart';
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
  bool obscureMP = true;
  bool obscureRMP = true;

  // for maps
  GoogleMapController? controller;
  CameraPosition? cameraPosition;
  MapPickerController mapPickerController = MapPickerController();
  Location location = Location();
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;
  LocationData? myLocation;
  String quartier = "";
  String myStreet = "";
  EmailAuth emailAuth = EmailAuth(sessionName: "nictusfood");

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
    cameraPosition = CameraPosition(
      zoom: 14,
      target: LatLng(myLocation!.latitude!, myLocation!.longitude!),
    );

    quartier = await Config()
        .getNameOfQuartier(myLocation!.latitude!, myLocation!.longitude!);
    myStreet = await Config()
        .getNameOfStreet(myLocation!.latitude!, myLocation!.longitude!);

    if (mounted) {
      setState(() {});
    }
  }

  Future<bool> sendOtp(String receveur) async {
    setState(() {
      load = true;
    });
    bool result = await emailAuth.sendOtp(
      recipientMail: receveur,
      otpLength: 4,
    );
    print("$result est le resultat de sendOTP");
    return result;
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance?.addObserver(this);
    checkPermission();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        setState(() {
          controller;
        });
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
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
                          obscureText: obscureMP ? true : false,
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
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color(0xFF37474F),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureMP = !obscureMP;
                                });
                              },
                              child: Icon(
                                obscureMP
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off_sharp,
                              ),
                            ),
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
                          obscureText: obscureRMP ? true : false,
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
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color(0xFF37474F),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureRMP = !obscureRMP;
                                });
                              },
                              child: Icon(
                                obscureRMP
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off_sharp,
                              ),
                            ),
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
                          onPressed: () async {
                            if (formGlobalKey.currentState!.validate()) {
                              String firstname = nomComplet.text.split(" ")[0];
                              String lastname = nomComplet.text;
                              // // on doit trouver c'est quoi le nom et le prenom dans nomcoplet
                              CustomerModel model = CustomerModel(
                                email.text,
                                firstname,
                                lastname,
                                password.text,
                                adresse.text,
                                ville.text,
                                numero.text,
                              );
                              if (await sendOtp(email.text)) {
                                Get.to(ConfirmEmailPage(model: model));
                              }
                            } else {
                              print("noo valide");
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
                child: SizedBox(
                  height: 310,
                  width: double.infinity,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  child: myLocation != null
                      ? Stack(
                          children: [
                            MapPicker(
                              mapPickerController: mapPickerController,
                              iconWidget: Image.asset(
                                "assets/appassets/marker.png",
                                width: 45,
                                height: 50,
                                frameBuilder: (context, child, frame,
                                    wasSynchronouslyLoaded) {
                                  return Transform.translate(
                                    offset: const Offset(0, 1),
                                    child: child,
                                  );
                                },
                              ),
                              child: GoogleMap(
                                minMaxZoomPreference:
                                    MinMaxZoomPreference(15, 20),
                                zoomControlsEnabled: false,
                                myLocationEnabled: true,
                                onCameraMoveStarted: () {
                                  mapPickerController.mapMoving!();
                                },
                                onCameraIdle: () {
                                  mapPickerController.mapFinishedMoving!();
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(myLocation!.latitude!,
                                      myLocation!.longitude!),
                                ),
                                onMapCreated:
                                    (GoogleMapController ccontroller) {
                                  controller = ccontroller;
                                },
                                onCameraMove: (newcameraPosition) {
                                  cameraPosition = newcameraPosition;
                                },
                              ),
                            ),
                            // MapboxMap(
                            //   onMapCreated: (MapboxMapController c) async {
                            //     controller = c;
                            //     if (mounted) {
                            //       setState(() {});
                            //     }
                            //   },
                            //   accessToken:
                            //       "sk.eyJ1IjoicGlvdXBpb3VkZXYiLCJhIjoiY2wzM2llYzhvMHVsbjNjcDlpeWx3azl2byJ9.SGXRi8GH5w_Oser89rhLnA",
                            //   styleString:
                            //       "mapbox://styles/pioupioudev/cl33ha6ch001l14qctquv6799",
                            //   initialCameraPosition: CameraPosition(
                            //     zoom: 14,
                            //     target: LatLng(myLocation!.latitude!,
                            //         myLocation!.longitude!),
                            //   ),
                            //   myLocationEnabled: true,
                            //   trackCameraPosition: true,
                            // ),
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
                  LatLng newpos = cameraPosition!.target;
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
