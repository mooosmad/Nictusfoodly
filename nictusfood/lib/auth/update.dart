// ignore_for_file: deprecated_member_use, prefer_const_constructors, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/models/customer.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/services/api_services.dart';

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

  bool load = false;
  getOldValue() {
    // + " " + widget.customer!.prenom!
    nomComplet.text = widget.customer!.nom!;
    adresse.text = widget.customer!.adresse!;
    numero.text = widget.customer!.phone!;
  }

  @override
  void initState() {
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
                              child: CachedNetworkImage(
                                imageUrl: widget.customer!.urlPic!,
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
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
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
                  SizedBox(height: 25),
                  Container(
                    alignment: Alignment.centerRight,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    child: RaisedButton(
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
}
