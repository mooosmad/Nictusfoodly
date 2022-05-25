// ignore_for_file: prefer_const_constructors

import 'package:email_auth/email_auth.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/customermodel.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/services/api_services.dart';
import 'package:pinput/pinput.dart';

class ConfirmEmailPage extends StatefulWidget {
  final CustomerModel? model;
  const ConfirmEmailPage({Key? key, required this.model}) : super(key: key);

  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  EmailAuth emailAuth = EmailAuth(sessionName: "nictusfood");
  bool load = false;
  bool isApiCallProcess = false;
  bool valideEmail(String receveuremail, String userOTP) {
    var res = emailAuth.validateOtp(
      recipientMail: receveuremail,
      userOtp: userOTP,
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: maincolor,
              elevation: 0,
              title: Text(
                "Verifier votre email",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Verification",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "Entrer le code envoyé à l'email",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.model!.email!,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.w500),
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 20),
                    Pinput(
                      focusedPinTheme: defaultPinTheme.copyDecorationWith(
                        border:
                            Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      length: 6,
                      onCompleted: (b) {
                        if (valideEmail(widget.model!.email!, b)) {
                          setState(() {
                            load = true;
                          });

                          if (kDebugMode) {
                            print(widget.model!.toJson());
                          }

                          setState(() {
                            isApiCallProcess = true;
                          });
                          APIService()
                              .createCustomer(widget.model!)
                              .then((ret) {
                            setState(() {
                              isApiCallProcess = false;
                            });
                            // if ret[0] is true reussi
                            if (ret![0]) {
                              Fluttertoast.showToast(
                                  msg: "Inscription effectué avec succès");
                              Get.offAllNamed("/home");
                            } else {
                              Get.offAllNamed("/home");
                            }
                          });
                        } else {
                          if (kDebugMode) {
                            print("CODE OTP NOT VALIDE");
                          }
                          Get.defaultDialog(
                            title: "Invalide",
                            titleStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                            contentPadding: EdgeInsets.all(10),
                            content: Text(
                              "Le code entré n'est pas valide. Veuillez verifier votre email.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            cancel: TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Compris"),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Vous n'avez pas recu de code?",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontWeight: FontWeight.w300),
                        fontSize: 15,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Renvoyer",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w300),
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
