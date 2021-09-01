import 'package:ae_dapp/service/AllAthletesList.dart';
import 'package:ae_dapp/service/AthleteProfile.dart';
import 'package:ae_dapp/style/Style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

late TooltipBehavior _tooltipBehavior;

class _ExplorePageState extends State<ExplorePage> {
  double lgTxSize = 52;
  double headerTx = 30;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        tooltipPosition: TooltipPosition.pointer,
        enable: true,
        borderColor: Colors.red,
        borderWidth: 0,
        color: Colors.lightBlue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Image(
        image: AssetImage("assets/images/background.jpeg"),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
      Column(children: <Widget>[
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image(
                width: 80,
                height: 80,
                image: AssetImage("assets/images/x.png"),
              ),
            )),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text("EXPLORE",
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: lgTxSize,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              )),
        ),
        Container(
            width: MediaQuery.of(context).size.width - 250,
            height: MediaQuery.of(context).size.height * .675,
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[900],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("Athlete Tokens",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ))),
                    Container(
                        padding: EdgeInsets.only(bottom: 0),
                        height: MediaQuery.of(context).size.height * .55,
                        width: MediaQuery.of(context).size.width / 2 - 350,
                        child: AllAthletesList())
                  ],
                ),
                Column(
                  children: <Widget>[
                    // athlete header and name
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                          child: SizedBox(
                              width: 600,
                              height: 50,
                              child: Row(children: [
                                Column(children: [
                                  Container(
                                      color: Colors.grey[900],
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 3, 0, 0),
                                        child: Icon(
                                          Icons.sports_baseball_rounded,
                                          size: 40,
                                          color: Colors.yellow[760],
                                        ),
                                      )),
                                ]),
                                Column(children: [
                                  Container(
                                      color: Colors.grey[900],
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(
                                            'Chase Anderson',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 32,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.w400),
                                          ))),
                                ]),
                                Column(children: [
                                  Container(
                                      color: Colors.grey[900],
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 10, 0, 0),
                                          child: Text(
                                            '+1.02%',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.w400),
                                          ))),
                                ])
                              ])),
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: SizedBox(
                              width: 600,
                              height: 75,
                              child: Row(children: [
                                Column(children: [
                                  Container(
                                      color: Colors.grey[900],
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 3, 0, 0),
                                        child: Text(
                                          '\$3.8908',
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )),
                                ]),
                              ])),
                        )),

                    // insert athlete graph here
                    Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                            width: 600,
                            height: 250,
                            child: SfCartesianChart(
                                tooltipBehavior: _tooltipBehavior,
                                enableAxisAnimation: true,
                                primaryXAxis: CategoryAxis(
                                  majorGridLines: MajorGridLines(width: 0),
                                  //Hide the axis line of x-axis
                                  axisLine:
                                      AxisLine(width: 1, color: Colors.white),
                                  majorTickLines: MajorTickLines(
                                      width: 0, color: Colors.transparent),
                                ),
                                primaryYAxis: NumericAxis(
                                  minimum: 25,
                                  maximum: 40,
                                  isVisible: false,
                                  desiredIntervals: 5,
                                  decimalPlaces: 2,
                                  axisLine:
                                      AxisLine(width: 1, color: Colors.white),
                                  majorGridLines: MajorGridLines(width: 0),
                                  //Hide the axis line of x-axis
                                  majorTickLines: MajorTickLines(
                                      width: 0, color: Colors.transparent),
                                ),
                                plotAreaBorderColor: Colors.grey[900],
                                plotAreaBorderWidth: 0.2,
                                series: <LineSeries<SalesData, String>>[
                                  LineSeries<SalesData, String>(
                                      // Bind data source
                                      dataSource: <SalesData>[
                                        SalesData('Jan', 35),
                                        SalesData('Feb', 28),
                                        SalesData('Mar', 34),
                                        SalesData('Apr', 32),
                                        SalesData('May', 40),
                                        SalesData('Jun', 35),
                                        SalesData('Jul', 28),
                                        SalesData('Aug', 34),
                                        SalesData('Sep', 32),
                                        SalesData('Oct', 40),
                                        SalesData('Nov', 35),
                                        SalesData('Dec', 28)
                                      ],
                                      xValueMapper: (SalesData sales, _) =>
                                          sales.year,
                                      yValueMapper: (SalesData sales, _) =>
                                          sales.sales)
                                ]))),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 600,
                                height: 75,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          color: Colors.grey[900],
                                          child: ElevatedButton(
                                            style: longButton,
                                            child: Text('LONG'),
                                            onPressed: () {},
                                          )),
                                      Container(
                                          color: Colors.grey[900],
                                          child: ElevatedButton(
                                            style: shortButton,
                                            child: Text('SHORT'),
                                            onPressed: () {},
                                          )),
                                      Container(
                                          color: Colors.grey[900],
                                          child: ElevatedButton(
                                            style: mintButton,
                                            child: Text('MINT'),
                                            onPressed: () {},
                                          )),
                                      Container(
                                          color: Colors.grey[900],
                                          child: ElevatedButton(
                                            style: redeemButton,
                                            child: Text('REDEEM'),
                                            onPressed: () {},
                                          ))
                                    ]))
                          ]),
                    ),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         // SizedBox(
                    //         //   width: 300,
                    //         //   height: 75,
                    //         //   child: Container(),
                    //         // ),
                    //         SizedBox(
                    //             width: 600,
                    //             height: 75,
                    //             child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceAround,
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.center,
                    //                 children: [
                    //                   Container(
                    //                       color: Colors.grey[900],
                    //                       child: ElevatedButton(
                    //                         style: mintButton,
                    //                         child: Text('MINT'),
                    //                         onPressed: () {},
                    //                       )),
                    //                   Container(
                    //                       color: Colors.grey[900],
                    //                       child: ElevatedButton(
                    //                         style: redeemButton,
                    //                         child: Text('REDEEM'),
                    //                         onPressed: () {},
                    //                       ))
                    //                 ]))
                    //       ]),
                    // ),
                  ],
                ),
              ],
            )),
      ]),
    ]));
  }
}

/*
Explore Page
My Team
Generate Key
*/

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
