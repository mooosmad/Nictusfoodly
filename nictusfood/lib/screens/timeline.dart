import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/ordermodel.dart';
import 'package:nictusfood/screens/home.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class TimelineTacer extends StatefulWidget {
  final Order? order;
  final bool? showBtn;
  const TimelineTacer({Key? key, this.order, this.showBtn}) : super(key: key);

  @override
  State<TimelineTacer> createState() => _TimelineTacerState();
}

class _TimelineTacerState extends State<TimelineTacer> {
  String formattedDate = DateFormat('kk:mm').format(DateTime.now());
  int index = 0;
  getIndexStatus() {
    if (widget.order!.status == "processing") {
      setState(() {
        index += 0;
      });
    } else if (widget.order!.status == "progress-shipment") {
      setState(() {
        index += 1;
      });
    } else if (widget.order!.status == "shipped") {
      setState(() {
        index += 2;
      });
    } else if (widget.order!.status == "arrival-shipment") {
      setState(() {
        index += 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 6.0,
        title: const Text('Statut de la commande'),

        // centerTitle: false,
        elevation: 0,
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.cancel_outlined),
        //   )
        // ],
        leading: const SizedBox(height: 0),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.cancel_rounded),
              onPressed: () {
                Get.to(const Home());
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: [
              // SizedBox(
              //   height: 100,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "livré à",
              //         style: GoogleFonts.poppins(
              //           textStyle: const TextStyle(
              //             fontSize: 17,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),
              //       // heure de livraison
              //       // Text(formattedDate),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 80),
              Column(
                children: [
                  if (widget.order!.status == "processing") ...[
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color:
                            index == 0 ? Colors.orange : Colors.grey.shade200,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 0
                              ? Icons.emoji_emotions_outlined
                              : Icons.check,
                        ),
                        drawGap: true,
                      ),
                      isFirst: true,
                      afterLineStyle: LineStyle(
                          color: index > 0 ? Colors.green : Colors.grey),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                // border: Border(
                                //     top: BorderSide(color: Colors.pink, width: 5)),
                                color: Color.fromARGB(255, 222, 221, 221),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      "En cours de préparation",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Nous avons reçu votre commande',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color:
                            index == 1 ? Colors.orange : Colors.grey.shade200,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData:
                              index == 1 ? Icons.delivery_dining : Icons.check,
                        ),
                      ),
                      beforeLineStyle: LineStyle(
                          color: index > 0 ? Colors.green : Colors.grey),
                      afterLineStyle: LineStyle(
                          color: index > 1 ? Colors.green : Colors.grey),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 166, 252, 239),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'En cours de livraison',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Dans 20min vous receverez votre commande',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color:
                            index == 2 ? Colors.orange : Colors.grey.shade200,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 2
                              ? Icons.delivery_dining_outlined
                              : Icons.check,
                        ),
                      ),
                      isLast: false,
                      beforeLineStyle: LineStyle(
                        color: index > 1 ? Colors.green : Colors.grey,
                      ),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 247, 191, 108),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'Commande à proximité',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Dans quelques instant 😁!',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color:
                            index == 3 ? Colors.orange : Colors.grey.shade200,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 3
                              ? Icons.delivery_dining_outlined
                              : Icons.check,
                        ),
                      ),
                      isLast: true,
                      beforeLineStyle: LineStyle(
                        color: index > 1 ? Colors.green : Colors.grey,
                      ),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 252, 189, 210),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'Commande arrivée',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Votre livreur est arrivé ✅',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (widget.order!.status == "progress-shipment") ...[
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color: index == 0 ? Colors.orange : Colors.green,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 0
                              ? Icons.emoji_emotions_outlined
                              : Icons.check,
                        ),
                      ),
                      isFirst: true,
                      afterLineStyle: LineStyle(
                          color: index > 0 ? Colors.green : Colors.grey),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],

                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                // border: Border(
                                //     top: BorderSide(color: Colors.pink, width: 5)),
                                color: Color.fromARGB(255, 222, 221, 221),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      "En cours de préparation",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Nous avons reçu votre commande',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color:
                            index == 1 ? Colors.orange : Colors.grey.shade200,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData:
                              index == 1 ? Icons.delivery_dining : Icons.check,
                        ),
                      ),
                      beforeLineStyle: LineStyle(
                          color: index > 0 ? Colors.green : Colors.grey),
                      afterLineStyle: LineStyle(
                          color: index > 1 ? Colors.green : Colors.grey),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 166, 252, 239),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'En cours de livraison',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Dans 20min vous receverez votre commande',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color:
                            index == 2 ? Colors.orange : Colors.grey.shade200,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 2
                              ? Icons.delivery_dining_outlined
                              : Icons.check,
                        ),
                      ),
                      isLast: false,
                      beforeLineStyle: LineStyle(
                        color: index > 1 ? Colors.green : Colors.grey,
                      ),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 247, 191, 108),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'Commande à proximité',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Dans quelques instant 😁!',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color:
                            index == 3 ? Colors.orange : Colors.grey.shade200,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 3
                              ? Icons.delivery_dining_outlined
                              : Icons.check,
                        ),
                      ),
                      isLast: true,
                      beforeLineStyle: LineStyle(
                        color: index > 1 ? Colors.green : Colors.grey,
                      ),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 252, 189, 210),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'Commande arrivée',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Votre livreur est arrivé ✅',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (widget.order!.status == "shipped") ...[
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color: index == 0 ? Colors.orange : Colors.green,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 0
                              ? Icons.emoji_emotions_outlined
                              : Icons.check,
                        ),
                      ),
                      isFirst: true,
                      afterLineStyle: LineStyle(
                          color: index > 0 ? Colors.green : Colors.grey),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],

                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                // border: Border(
                                //     top: BorderSide(color: Colors.pink, width: 5)),
                                color: Color.fromARGB(255, 222, 221, 221),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      "En cours de préparation",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Nous avons reçu votre commande',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color: index == 1 ? Colors.orange : Colors.green,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData:
                              index == 1 ? Icons.delivery_dining : Icons.check,
                        ),
                      ),
                      beforeLineStyle: LineStyle(
                          color: index > 0 ? Colors.green : Colors.grey),
                      afterLineStyle: LineStyle(
                          color: index > 1 ? Colors.green : Colors.grey),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 166, 252, 239),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'En cours de livraison',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Dans 20min vous receverez votre commande',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color: index == 2 ? Colors.orange : Colors.green,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 2
                              ? Icons.delivery_dining_outlined
                              : Icons.check,
                        ),
                      ),
                      isLast: false,
                      beforeLineStyle: LineStyle(
                        color: index > 1 ? Colors.green : Colors.grey,
                      ),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 247, 191, 108),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'Commande à proximité',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Dans quelques instant 😁!',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color:
                            index == 3 ? Colors.orange : Colors.grey.shade200,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 3
                              ? Icons.delivery_dining_outlined
                              : Icons.check,
                        ),
                      ),
                      isLast: true,
                      beforeLineStyle: LineStyle(
                        color: index > 1 ? Colors.green : Colors.grey,
                      ),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 252, 189, 210),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'Commande arrivée',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Votre livreur est arrivé ✅',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (widget.order!.status == "arrival-shipment") ...[
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color: index == 0 ? Colors.orange : Colors.green,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 0
                              ? Icons.emoji_emotions_outlined
                              : Icons.check,
                        ),
                      ),
                      isFirst: true,
                      afterLineStyle: LineStyle(
                          color: index > 0 ? Colors.green : Colors.grey),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],

                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                // border: Border(
                                //     top: BorderSide(color: Colors.pink, width: 5)),
                                color: Color.fromARGB(255, 222, 221, 221),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      "En cours de préparation",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Nous avons reçu votre commande',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color: index == 1 ? Colors.orange : Colors.green,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData:
                              index == 1 ? Icons.delivery_dining : Icons.check,
                        ),
                      ),
                      beforeLineStyle: LineStyle(
                          color: index > 0 ? Colors.green : Colors.grey),
                      afterLineStyle: LineStyle(
                          color: index > 1 ? Colors.green : Colors.grey),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 166, 252, 239),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'En cours de livraison',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Dans 20min vous receverez votre commande',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color: index == 2 ? Colors.orange : Colors.green,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 2
                              ? Icons.delivery_dining_outlined
                              : Icons.check,
                        ),
                      ),
                      isLast: false,
                      beforeLineStyle: LineStyle(
                        color: index > 1 ? Colors.green : Colors.grey,
                      ),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 247, 191, 108),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'Commande à proximité',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Dans quelques instant 😁!',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TimelineTile(
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color:
                            index == 3 ? Colors.orange : Colors.grey.shade200,
                        height: 40,
                        width: 40,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: index == 3
                              ? Icons.delivery_dining_outlined
                              : Icons.check,
                        ),
                      ),
                      isLast: true,
                      beforeLineStyle: LineStyle(
                        color: index > 1 ? Colors.green : Colors.grey,
                      ),
                      alignment: TimelineAlign.start,
                      endChild: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              height: 90,
                              decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(blurRadius: 6, color: Colors.grey),
                                // ],
                                // border: Border(
                                //   top: BorderSide(color: Colors.pink, width: 5),
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 252, 189, 210),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 8.0),
                                    child: Text(
                                      'Commande arrivée',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Votre livreur est arrivé ✅',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (widget.order!.status == "completed") ...[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 80),
                          Lottie.asset(
                            'assets/lotties/validacion.json',
                            width: 200.0,
                            height: 200.0,
                          ),
                          const Text(
                            'Commande Livrée avec success',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    )
                  ],
                  const SizedBox(height: 40),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: maincolor,
                    ),
                    child: GestureDetector(
                      child: Center(
                        child: Text(
                          "Contactez nous",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: () => launchUrl(
                        Uri.parse("tel:+2250769418743"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // if (widget.showBtn!) myButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myButton() {
    return Center(
      child: InkWell(
        onTap: () async {
          Get.offAllNamed("/home");
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
              "Retouner au menu",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // setState(() {
    getIndexStatus();
    // });
  }
}
