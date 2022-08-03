import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/constant/colors.dart';
import 'package:nictusfood/models/ordermodel.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineTacer extends StatefulWidget {
  final Order? order;
  final bool? showBtn;
  const TimelineTacer({Key? key, this.order, this.showBtn}) : super(key: key);

  @override
  State<TimelineTacer> createState() => _TimelineTacerState();
}

class _TimelineTacerState extends State<TimelineTacer> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Statut de la commande'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: [
              TimelineTile(
                axis: TimelineAxis.vertical,
                indicatorStyle: IndicatorStyle(
                  color: index == 0 ? Colors.orange : Colors.green.shade200,
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
                afterLineStyle:
                    LineStyle(color: index > 0 ? Colors.green : Colors.grey),
                alignment: TimelineAlign.start,
                endChild: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 30),
                        height: 90,
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(blurRadius: 6, color: Colors.grey),
                          ],

                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          // border: Border(
                          //     top: BorderSide(color: Colors.pink, width: 5)),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0, top: 8.0),
                              child: Text(
                                "En cours de préparation",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                  color: index == 1 ? Colors.orange : Colors.green.shade200,
                  height: 40,
                  width: 40,
                  iconStyle: IconStyle(
                    color: Colors.white,
                    iconData: index == 1 ? Icons.delivery_dining : Icons.check,
                  ),
                ),
                beforeLineStyle:
                    LineStyle(color: index > 0 ? Colors.green : Colors.grey),
                afterLineStyle:
                    LineStyle(color: index > 1 ? Colors.green : Colors.grey),
                alignment: TimelineAlign.start,
                endChild: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 30),
                        height: 90,
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(blurRadius: 6, color: Colors.grey),
                          ],
                          // border: Border(
                          //   top: BorderSide(color: Colors.pink, width: 5),
                          // ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0, top: 8.0),
                              child: Text(
                                'En cours de livraison',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                  color: index == 2 ? Colors.orange : Colors.green.shade200,
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
                        margin: const EdgeInsets.only(top: 10, bottom: 30),
                        height: 90,
                        
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(blurRadius: 6, color: Colors.grey),
                          ],
                          // border: Border(
                          //   top: BorderSide(color: Colors.pink, width: 5),
                          // ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0, top: 8.0),
                              child: Text(
                                'Commande à proximité',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                  color: index == 3 ? Colors.orange : Colors.green.shade200,
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
                        margin: const EdgeInsets.only(top: 10, bottom: 30),
                        height: 90,
                       
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(blurRadius: 6, color: Colors.grey),
                          ],
                          // border: Border(
                          //   top: BorderSide(color: Colors.pink, width: 5),
                          // ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0, top: 8.0),
                              child: Text(
                                'Commande arrivée',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 20),
              if (widget.showBtn!) myButton(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //increase
          setState(() {
            index += 1;
          });
        },
        child: Icon(index < 3 ? Icons.navigate_next : Icons.done),
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
}
