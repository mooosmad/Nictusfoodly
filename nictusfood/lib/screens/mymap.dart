// ignore_for_file: prefer_const_constructors

import 'dart:async';

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_picker/map_picker.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/services/config.dart';
import 'package:shimmer/shimmer.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  GoogleMapController? controller;
  MapPickerController mapPickerController = MapPickerController();
  CameraPosition? cameraPosition;
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
    cameraPosition = CameraPosition(
      zoom: 14,
      target: LatLng(myLocation!.latitude!, myLocation!.longitude!),
    );

    setState(() {});
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
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
                      MapPicker(
                        mapPickerController: mapPickerController,
                        iconWidget: Image.asset(
                          "assets/appassets/marker.png",
                          width: 45,
                          height: 50,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            return Transform.translate(
                              offset: const Offset(0, 1),
                              child: child,
                            );
                          },
                        ),
                        child: GoogleMap(
                          minMaxZoomPreference: MinMaxZoomPreference(15, 20),
                          zoomControlsEnabled: false,
                          myLocationEnabled: true,
                          onCameraMoveStarted: () {
                            mapPickerController.mapMoving!();
                          },
                          onCameraIdle: () {
                            mapPickerController.mapFinishedMoving!();
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                myLocation!.latitude!, myLocation!.longitude!),
                          ),
                          onMapCreated: (GoogleMapController ccontroller) {
                            controller = ccontroller;
                          },
                          onCameraMove: (newcameraPosition) {
                            cameraPosition = newcameraPosition;
                          },
                        ),
                      ),
                      // Center(
                      //   child: Container(
                      //     height: 60,
                      //     width: 45,
                      //     child: Image.asset(
                      //       "assets/appassets/marker.png",
                      //       frameBuilder: (context, child, frame,
                      //           wasSynchronouslyLoaded) {
                      //         return Transform.translate(
                      //           offset: const Offset(0, -17),
                      //           child: child,
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // ),
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
              print(cameraPosition!.target);
              lieuLivraison = await Config().getNameOfQuartier(
                    cameraPosition!.target.latitude,
                    cameraPosition!.target.longitude,
                  ) +
                  " " +
                  await Config().getNameOfStreet(
                    cameraPosition!.target.latitude,
                    cameraPosition!.target.longitude,
                  );
              print(lieuLivraison);
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
