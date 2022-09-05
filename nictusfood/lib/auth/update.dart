// ignore_for_file: deprecated_member_use, prefer_const_constructors, avoid_unnecessary_containers, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_picker/map_picker.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/customer.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/services/api_services.dart';
import 'package:nictusfood/services/config.dart';

class UpdapteScreen extends StatefulWidget {
  final Customer? customer;
  final String? idUser;

  const UpdapteScreen({Key? key, required this.customer, required this.idUser})
      : super(key: key);

  @override
  State<UpdapteScreen> createState() => _UpdapteScreenState();
}

class _UpdapteScreenState extends State<UpdapteScreen> {
  TextEditingController nomComplet = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController numero = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  CameraPosition? cameraPosition;
  GoogleMapController? controller;
  MapPickerController mapPickerController = MapPickerController();
  LocationData? myLocation;
  TextEditingController ville = TextEditingController();
  Location location = Location();

  bool load = false;
  getOldValue() {
    // + " " + widget.customer!.prenom!
    nomComplet.text = widget.customer!.nom!;
    adresse.text = widget.customer!.adresse!;
    numero.text = widget.customer!.phone!;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      myLocation = await location.getLocation();

      cameraPosition = CameraPosition(
        zoom: 14,
        target: LatLng(myLocation!.latitude!, myLocation!.longitude!),
      );
      if (mounted) {
        setState(() {});
      }
    });
    getOldValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: load
          ? null
          : AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Profil",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
      body: load
          ? Loading()
          : Form(
              key: formGlobalKey,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      width: 128.0,
                      height: 128.0,
                      margin: const EdgeInsets.only(
                        top: 24.0,
                        bottom: 20.0,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: widget.idUser != null
                          ? Container(
                              child: Image.network(
                                widget.customer!.urlPic!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Champ vide";
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                      controller: nomComplet,
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
                        prefixIcon:
                            const Icon(Icons.person, color: Color(0xFF37474F)),
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Champ vide";
                        }
                        return null;
                      },
                      controller: numero,
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
                        hintText: 'Numero de telephone',
                        hintStyle: Theme.of(context).textTheme.headline3,
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Color(0xFF37474F),
                        ),
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
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ vide";
                          }
                          return null;
                        },
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
                  SizedBox(height: 25),
                  Container(
                    alignment: Alignment.centerRight,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    child: OutlinedButton(
                      onPressed: () async {
                        if (formGlobalKey.currentState!.validate()) {
                          setState(() {
                            load = true;
                          });
                          var data = {
                            "first_name": nomComplet.text,
                            "billing": {
                              "first_name": nomComplet.text,
                              "address_1": adresse.text,
                              "phone": numero.text,
                            },
                            "shipping": {
                              "first_name": nomComplet.text,
                              "address_1": adresse.text,
                            }
                          };
                          final res = await APIService()
                              .updateUser(data, int.parse(widget.idUser!));
                          if (res) {
                            Get.back();
                          } else {
                            setState(() {
                              load = false;
                            });
                          }
                        } else {
                          print("not valide");
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(255, 255, 136, 34),
                              Color.fromARGB(255, 255, 177, 41)
                            ])),
                        padding: const EdgeInsets.all(0),
                        child: const Text(
                          "Enregistrer",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
