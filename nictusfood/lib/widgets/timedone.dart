import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Lot extends StatefulWidget {
  const Lot({Key? key}) : super(key: key);

  @override
  State<Lot> createState() => _Lotstate();
}

class _Lotstate extends State<Lot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/lotties/91597-validacion.json',
              width: 200.0,
              height: 200.0,
            ),
            const Text(
              'Commande Livrée avec success',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
