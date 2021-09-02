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

Widget _mintAPT(BuildContext context) {
  return new AlertDialog(
    backgroundColor: Colors.grey[900],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    title: Text('Confirm Swap', textAlign: TextAlign.left, style: confirmText),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //FROM
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [Text('From', style: confirmText)],
              ),
              Column(
                children: [Text('~\$1,300.00', style: confirmText)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [Text('ETH', style: confirmTextCoin)],
              ),
              Column(
                children: [Text('10.0702', style: confirmTextCoin)],
              )
            ],
          ),
        ),
        //DOWN ARROW
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [Icon(Icons.arrow_downward, size: 15)],
              )
            ],
          ),
        ),
        //TO
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [Text('To', style: confirmText)],
              ),
              Row(children: [
                Column(children: [Text('~\$1,290.00', style: confirmText)]),
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Column(children: [
                      Text('(0.079%)', style: confirmTextPercent)
                    ]))
              ])
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'AX',
                    style: confirmTextCoin,
                  )
                ],
              ),
              Column(
                children: [Text('9.1000', style: confirmTextCoin)],
              )
            ],
          ),
        ),
        //PRICE
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Price',
                    style: confirmText,
                  )
                ],
              ),
              Column(
                children: [
                  Text('1 AX = .00589 ETH', style: confirmTextOtherBold)
                ],
              )
            ],
          ),
        ),
        //OTHER INFO
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Liquidity Provider Fee',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('0.000824 ETH', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Price Impact',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('-0.03%', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Maximum sent',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('0.289529 ETH', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Slippage tolerance',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('0.05%', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        //CONFIRMATION BUTTON
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style: confirmSwap,
                  child: Text('Confirm Swap'))
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _redeemAX(BuildContext context) {
  return new AlertDialog(
    backgroundColor: Colors.grey[900],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    title: Text('Confirm Swap', textAlign: TextAlign.left, style: confirmText),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //FROM
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [Text('From', style: confirmText)],
              ),
              Column(
                children: [Text('~\$1,300.00', style: confirmText)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [Text('ETH', style: confirmTextCoin)],
              ),
              Column(
                children: [Text('10.0702', style: confirmTextCoin)],
              )
            ],
          ),
        ),
        //DOWN ARROW
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [Icon(Icons.arrow_downward, size: 15)],
              )
            ],
          ),
        ),
        //TO
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [Text('To', style: confirmText)],
              ),
              Row(children: [
                Column(children: [Text('~\$1,290.00', style: confirmText)]),
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Column(children: [
                      Text('(0.079%)', style: confirmTextPercent)
                    ]))
              ])
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'AX',
                    style: confirmTextCoin,
                  )
                ],
              ),
              Column(
                children: [Text('9.1000', style: confirmTextCoin)],
              )
            ],
          ),
        ),
        //PRICE
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Price',
                    style: confirmText,
                  )
                ],
              ),
              Column(
                children: [
                  Text('1 AX = .00589 ETH', style: confirmTextOtherBold)
                ],
              )
            ],
          ),
        ),
        //OTHER INFO
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Liquidity Provider Fee',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('0.000824 ETH', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Price Impact',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('-0.03%', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Maximum sent',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('0.289529 ETH', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Slippage tolerance',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('0.05%', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        //CONFIRMATION BUTTON
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style: confirmSwap,
                  child: Text('Confirm Swap'))
            ],
          ),
        ),
      ],
    ),
  );
}

class _ExplorePageState extends State<ExplorePage> {
  double lgTxSize = 52;
  double headerTx = 30;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        tooltipPosition: TooltipPosition.auto,
        enable: true,
        color: Colors.lightBlue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        decoration: new BoxDecoration(
          color: const Color(0xff7c94b6),
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(.9), BlendMode.darken),
            image: AssetImage("assets/images/background.jpeg"),
          ),
        ),
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
          padding: EdgeInsets.only(bottom: 10),
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
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text("Athlete Tokens",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ))),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tight(Size(250, 60)),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              fillColor: Colors.grey[800],
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: (Colors.grey[900])!,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: (Colors.grey[900])!,
                                  width: 3.0,
                                ),
                              ),
                              border: UnderlineInputBorder(),
                              hintText: 'Search for an Athlete',
                              hintStyle: TextStyle(
                                fontSize: 15,
                              )),
                        ),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * .45,
                        width: MediaQuery.of(context).size.width / 2 - 350,
                        child: AllAthletesList())
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // athlete header and name
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: SizedBox(
                              width: 600,
                              height: 60,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(children: [
                                      Container(
                                          color: Colors.grey[900],
                                          child: Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 5, 50, 0),
                                              child: Text(
                                                'Chase Anderson',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontFamily: 'OpenSans',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))),
                                    ]),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                              color: Colors.grey[900],
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 3, 0, 0),
                                                child: Text(
                                                  '\$3.8908',
                                                  style: TextStyle(
                                                      fontSize: 40,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              )),
                                        ]),
                                    Column(children: [
                                      Container(
                                          color: Colors.grey[900],
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 10, 0, 0),
                                              child: Text(
                                                '+1.02%',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.green,
                                                    fontFamily: 'OpenSans',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))),
                                    ])
                                  ])),
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: SizedBox(
                              width: 600, height: 75, child: Row(children: [])),
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
                                  maximum: 65,
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
                                        SalesData('1/1 12AM', 35),
                                        SalesData('1/1 1AM', 28),
                                        SalesData('1/1 2AM', 34),
                                        SalesData('1/1 3AM', 32),
                                        SalesData('1/1 4AM', 40),
                                        SalesData('1/1 5AM', 35),
                                        SalesData('1/1 6AM', 28),
                                        SalesData('1/1 7AM', 30),
                                        SalesData('1/1 8AM', 32),
                                        SalesData('1/1 9AM', 40),
                                        SalesData('1/1 10AM', 35),
                                        SalesData('1/1 11AM', 28),
                                        SalesData('1/1 12PM', 34),
                                        SalesData('1/1 1PM', 29),
                                        SalesData('1/1 2PM', 35),
                                        SalesData('1/1 3PM', 39),
                                        SalesData('1/1 4PM', 42),
                                        SalesData('1/1 5PM', 41),
                                        SalesData('1/1 6PM', 46),
                                        SalesData('1/1 7PM', 44),
                                        SalesData('1/1 8PM', 42),
                                        SalesData('1/1 9PM', 47),
                                        SalesData('1/1 10PM', 48),
                                        SalesData('1/1 11PM', 45),
                                        SalesData('1/2 12AM', 44),
                                        SalesData('1/2 1AM', 42),
                                        SalesData('1/2 2AM', 46),
                                        SalesData('1/2 3AM', 47),
                                        SalesData('1/2 4AM', 45),
                                        SalesData('1/2 5AM', 44),
                                        SalesData('1/2 6AM', 48),
                                        SalesData('1/2 7AM', 49),
                                        SalesData('1/2 8AM', 51),
                                        SalesData('1/2 9AM', 55),
                                        SalesData('1/2 10AM', 60),
                                        SalesData('1/2 11AM', 58),
                                        SalesData('1/2 12PM', 48),
                                        SalesData('1/2 1PM', 50),
                                        SalesData('1/2 2PM', 54),
                                        SalesData('1/2 3PM', 55),
                                        SalesData('1/2 4PM', 57),
                                        SalesData('1/2 5PM', 60),
                                        SalesData('1/2 6PM', 58),
                                        SalesData('1/2 7PM', 59),
                                        SalesData('1/2 8PM', 61),
                                        SalesData('1/2 9PM', 64),
                                        SalesData('1/2 10PM', 58),
                                        SalesData('1/2 11PM', 59)
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
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        _mintAPT(context),
                                              );
                                            },
                                          )),
                                      Container(
                                          color: Colors.grey[900],
                                          child: ElevatedButton(
                                            style: redeemButton,
                                            child: Text('REDEEM'),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        _redeemAX(context),
                                              );
                                            },
                                          ))
                                    ]))
                          ]),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: SizedBox(
                                      width: 300,
                                      height: 75,
                                      child: ConstrainedBox(
                                        constraints:
                                            BoxConstraints.tight(Size(250, 60)),
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                              fillColor: Colors.grey[800],
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: BorderSide(
                                                  color: (Colors.amber[600])!,
                                                  width: 3.0,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: BorderSide(
                                                  color: (Colors.grey[900])!,
                                                  width: 3.0,
                                                ),
                                              ),
                                              border: UnderlineInputBorder(),
                                              hintText:
                                                  'Enter the amount of APT to long/short',
                                              hintStyle: TextStyle(
                                                fontSize: 15,
                                              )),
                                        ),
                                      ),
                                    )),
                              ]),
                              Column(
                                children: [
                                  SizedBox(
                                      width: 300,
                                      height: 40,
                                      child: Text(
                                        '**Mint: Supply AX and receive APT-LSP (Athlete Performance Token Long/Short Pair)**',
                                        style: mintAndRedeemText,
                                        textAlign: TextAlign.center,
                                      )),
                                  SizedBox(
                                      width: 300,
                                      height: 40,
                                      child: Text(
                                          '**Redeem: Supply APT-LSP (Athlete Performace Token Long/Short Pair and receive AX**',
                                          style: mintAndRedeemText,
                                          textAlign: TextAlign.center))
                                ],
                              )
                            ])),
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
