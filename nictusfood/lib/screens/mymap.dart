// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/services/config.dart';
import 'package:shimmer/shimmer.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  MapboxMapController? controller;
  PermissionStatus? permissionGranted;
  LocationData? myLocation;
  Location location = Location();
  bool? serviceEnabled;
  String lieuLivraison = "";
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

    setState(() {});
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "Adresse de livraison",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
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
                          target: LatLng(
                            myLocation!.latitude!,
                            myLocation!.longitude!,
                          ),
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
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: Colors.grey,
              child: Text(
                "Veuillez Glissez le marker sur le point où vous souhaitez être livré",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Mettez le marker sur le point bleu pour choisir votre position",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              lieuLivraison = await Config().getNameOfQuartier(
                    controller!.cameraPosition!.target.latitude,
                    controller!.cameraPosition!.target.longitude,
                  ) +
                  " " +
                  await Config().getNameOfStreet(
                    controller!.cameraPosition!.target.latitude,
                    controller!.cameraPosition!.target.longitude,
                  );
              Get.back(result: lieuLivraison);
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
                  "Choisir",
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
    );
  }
}
