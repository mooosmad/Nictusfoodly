import 'package:flutter/material.dart';
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
        title: const Text('Flutter Timeline Tile  Example'),
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
                  color: index == 0 ? Colors.pink : Colors.pink.shade200,
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
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      height: 80,
                      width: 280,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(blurRadius: 6, color: Colors.grey),
                        ],

                        //borderRadius: BorderRadius.all(Radius.circular(24)),
                        border: Border(
                            top: BorderSide(color: Colors.pink, width: 5)),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 8.0),
                            child: Text(
                              'Ordered Received',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'We\'ve received your order',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TimelineTile(
                axis: TimelineAxis.vertical,
                indicatorStyle: IndicatorStyle(
                  color: index == 1 ? Colors.pink : Colors.pink.shade200,
                  height: 40,
                  width: 40,
                  iconStyle: IconStyle(
                    color: Colors.white,
                    iconData: index == 1 ? Icons.fastfood_rounded : Icons.check,
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
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      height: 80,
                      width: 280,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(blurRadius: 6, color: Colors.grey),
                        ],
                        border: Border(
                            top: BorderSide(color: Colors.pink, width: 5)),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 8.0),
                            child: Text(
                              'Order in Process',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Your order is being prepared',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TimelineTile(
                axis: TimelineAxis.vertical,
                indicatorStyle: IndicatorStyle(
                  color: index == 2 ? Colors.pink : Colors.pink.shade200,
                  height: 40,
                  width: 40,
                  iconStyle: IconStyle(
                    color: Colors.white,
                    iconData: index == 2
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
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      height: 80,
                      width: 280,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(blurRadius: 6, color: Colors.grey),
                        ],
                        border: Border(
                            top: BorderSide(color: Colors.pink, width: 5)),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 8.0),
                            child: Text(
                              'Order in Delivery',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Your order is on its way to you!',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
}
