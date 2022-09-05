// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nictusfood/Components/background.dart';
import 'package:nictusfood/auth/registrer.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/screens/loading.dart';
import 'package:nictusfood/services/api_services.dart';

class LoginScreen extends StatefulWidget {
  final bool? isdrawer;
  const LoginScreen({Key? key, required this.isdrawer}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool load = false;
  final formGlobalKey = GlobalKey<FormState>();
  bool obscureMP = true;
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "CONNEXION",
                          style: Theme.of(context).textTheme.headline1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          controller: email,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                          ),
                          keyboardType: TextInputType.emailAddress,
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
                          controller: password,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                          ),
                          validator: ((value) {
                            if (value!.length < 6) {
                              return "Mot de passe trop court";
                            } else if (value.isEmpty) {
                              return "Champ vide";
                            }
                            return null;
                          }),
                          decoration: InputDecoration(
                            focusColor: Colors.black,
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
                          obscureText: obscureMP ? true : false,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: const Text(
                          "Mot de passe oublié?",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: OutlinedButton(
                          onPressed: () async {
                            if (formGlobalKey.currentState!.validate()) {
                              setState(() {
                                load = true;
                              });
                              final res = await APIService().loginCustomer(
                                  email.text.trim(), password.text);
                              if (res!) {
                                setState(() {});
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
                            } else {}
                          },
                          style: OutlinedButton.styleFrom(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(80.0),
                            // ),
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
                              ]),
                            ),
                            padding: const EdgeInsets.all(0),
                            child: const Text(
                              "Se Connecter",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: TextButton(
                          onPressed: () async {
                            if (await _googleSignIn.isSignedIn()) {
                              await _googleSignIn.signOut();
                            } else {
                              var user = await _googleSignIn.signIn();

                              if (user != null) {
                                setState(() {
                                  load = true;
                                });
                                bool? res = await APIService().socialLogin(
                                  user.email,
                                  user.photoUrl!,
                                );
                                if (res!) {
                                  if (widget.isdrawer!) {
                                    Get.back();
                                    Get.back();
                                  } else {
                                    Get.back();
                                  }
                                }
                              }
                            }
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              textStyle: TextStyle(
                                color: Colors.black,
                              ),
                              padding: const EdgeInsets.all(0),
                              elevation: 1),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            width: size.width * 1.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(0),
                            child: const Text(
                              "continuer avec google",
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
                              RegisterScreen(
                                isdrawer: true,
                              ),
                              transition: Transition.downToUp,
                            );
                          },
                          child: Text(
                            "Je n'ai pas de compte? Inscrivez-vous",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: maincolor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
