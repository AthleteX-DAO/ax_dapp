import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
print("TestPage running...");
    return Expanded(child:SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Title
          Container(
            color: Colors.green,
            height: 100,
            // width: MediaQuery.of(context).size.width*0.95,
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     // Back button
            //     Container(
            //       width: 70,
            //       child: TextButton(
            //         onPressed: () {
            //           setState(() {listView = 1;});
            //         },
            //         child: Icon(
            //           Icons.arrow_back,
            //           size: 50,
            //           color: Colors.white
            //         )
            //       )
            //     ),
            //     // APT Icon
            //     Container(
            //       width: 30,
            //     ),
            //     // Player Name
            //     Container(
            //       child: Text(
            //         athlete.name,
            //         style: textStyle(Colors.white, 28, false, false)
            //       )
            //     ),
            //     // '|' Symbol
            //     Container(
            //       width: 50,
            //       alignment: Alignment.center,
            //       child: Text(
            //         "|",
            //         style: textStyle(Colors.grey[600]!, 24, false, false)
            //       )
            //     ),
            //     Container(
            //       child: Text(
            //         "Seasonal APT",
            //         style: textStyle(Colors.grey[600]!, 24, false, false)
            //       )
            //     ),
            //   ]
            // )
          ),
          // Non-title (2 halves)
          Container(
            color: Colors.amber,
            height: 575,
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     // Graph-Side 
            //     Container(
            //       width: MediaQuery.of(context).size.width*.4,
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: <Widget>[
            //           Container(
            //             width: MediaQuery.of(context).size.width*.350,
            //             height: MediaQuery.of(context).size.height*.4,
            //             decoration: boxDecoration(Colors.transparent, 10, 1, Colors.grey[400]!),
            //             child: Stack(
            //               children: <Widget>[
            //                 // Graph
            //                 buildGraph(athlete.war, athlete.time, context),
            //                 // Price
            //                 Align(
            //                   alignment: Alignment(-.85, -.8),
            //                   child: Container(
            //                     height: 45,
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: <Widget>[
            //                         Text(
            //                           "Book Value Chart",
            //                           style: textStyle(Colors.white, 9, false, false)
            //                         ),
            //                         Container(
            //                           width: 130,
            //                           height: 25,
            //                           child: Row(
            //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                             children: <Widget>[
            //                               Text(
            //                                 athlete.war[athlete.war.length-1].toStringAsFixed(4)+" AX",
            //                                 style: textStyle(Colors.white, 20, true, false)
            //                               ),
            //                               Container(
            //                                 alignment: Alignment.topLeft,
            //                                 child: Text(
            //                                   "+4%",
            //                                   style: textStyle(Colors.green, 12, false, false)
            //                                 )
            //                               )
            //                             ],
            //                           )
            //                         )
            //                       ],
            //                     )
            //                   )
            //                 ),
            //               ],
            //             )
            //           ),
            //           Container(
            //             width: MediaQuery.of(context).size.width*.35,
            //             height: 150,
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.spaceAround,
            //               children: <Widget>[
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                   children: <Widget>[
            //                     Container(
            //                       width: 175,
            //                       height: 50,
            //                       decoration: boxDecoration(Colors.amber[400]!, 100, 0, Colors.amber[400]!),
            //                       child: TextButton(
            //                         onPressed: () => showDialog(context: context, builder: (BuildContext context) => buyDialog(context, athlete)),
            //                         child: Text(
            //                           "Buy",
            //                           style: textStyle(Colors.black, 20, false, false)
            //                         )
            //                       )
            //                     ),
            //                     Container(
            //                       width: 175,
            //                       height: 50,
            //                       decoration: boxDecoration(Colors.white, 100, 0, Colors.white),
            //                       child: TextButton(
            //                         onPressed: () => showDialog(context: context, builder: (BuildContext context) => sellDialog(context, athlete)),
            //                         child: Text(
            //                           "Sell",
            //                           style: textStyle(Colors.black, 20, false, false)
            //                         )
            //                       )
            //                     )
            //                   ]
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                   children: <Widget>[
            //                     Container(
            //                       width: 175,
            //                       height: 50,
            //                       decoration: boxDecoration(Colors.transparent, 100, 2, Colors.white),
            //                       child: TextButton(
            //                         onPressed: () => showDialog(context: context, builder: (BuildContext context) => mintDialog(context, athlete)),
            //                         child: Text(
            //                           "Mint",
            //                           style: textStyle(Colors.white, 20, false, false)
            //                         )
            //                       )
            //                     ),
            //                     Container(
            //                       width: 175,
            //                       height: 50,
            //                       decoration: boxDecoration(Colors.transparent, 100, 2, Colors.white),
            //                       child: TextButton(
            //                         onPressed: () => showDialog(context: context, builder: (BuildContext context) => redeemDialog(context, athlete)),
            //                         child: Text(
            //                           "Redeem",
            //                           style: textStyle(Colors.white, 20, false, false)
            //                         )
            //                       )
            //                     )
            //                   ]
            //                 ),
            //               ]
            //             )
            //           )
            //         ]
            //       )
            //     ),
            //     // Stats-Side
            //     Container(
            //       width: MediaQuery.of(context).size.width*.4,
            //       alignment: Alignment.topCenter,
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: <Widget>[
            //           // Price Overview section
            //           Container(
            //             height: 150,
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: <Widget>[
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: <Widget>[
            //                     Container(
            //                       width: MediaQuery.of(context).size.width*0.175,
            //                       child: Text(
            //                         "Price Overview",
            //                         style: textStyle(Colors.white, 24, false, false)
            //                       )
            //                     ),
            //                     Container(
            //                       width: MediaQuery.of(context).size.width*0.1,
            //                       alignment: Alignment.bottomLeft,
            //                       child: Text(
            //                         "Current",
            //                         style: textStyle(Colors.grey[400]!, 14, false, false)
            //                       )
            //                     ),
            //                     Container(
            //                       alignment: Alignment.bottomRight,
            //                       width: MediaQuery.of(context).size.width*0.075,
            //                       child: Text(
            //                         "All-Time High",
            //                         style: textStyle(Colors.grey[400]!, 14, false, false)
            //                       )
            //                     )
            //                   ]
            //                 ),
            //                 Divider(
            //                   thickness: 1,
            //                   color: Colors.grey[400]
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: <Widget>[
            //                     Container(
            //                       width: MediaQuery.of(context).size.width*0.175,
            //                       child: Text(
            //                         "Market Price",
            //                         style: textStyle(Colors.grey[400]!, 20, false, false)
            //                       )
            //                     ),
            //                     Container(
            //                       width: MediaQuery.of(context).size.width*0.1,
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         children: <Widget>[
            //                           Text(
            //                             "4.18 AX ",
            //                             style: textStyle(Colors.white, 20, false, false)
            //                           ),
            //                           Container(
            //                             //alignment: Alignment.topLeft,
            //                             child: Text(
            //                               "-2%",
            //                               style: textStyle(Colors.red, 12, false, false)
            //                             )
            //                           ),
            //                         ]
            //                       )
            //                     ),
            //                     Container(
            //                       alignment: Alignment.centerRight,
            //                       width: MediaQuery.of(context).size.width*0.075,
            //                       child: Text(
            //                         "4.20",
            //                         style: textStyle(Colors.grey[400]!, 20, false, false)
            //                       )
            //                     )
            //                   ]
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: <Widget>[
            //                     Container(
            //                       width: MediaQuery.of(context).size.width*0.175,
            //                       child: Text(
            //                         "Book Value",
            //                         style: textStyle(Colors.grey[400]!, 20, false, false)
            //                       )
            //                     ),
            //                     Container(
            //                       width: MediaQuery.of(context).size.width*0.1,
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         children: <Widget>[
            //                           Text(
            //                             "4.24 AX ",
            //                             style: textStyle(Colors.white, 20, false, false)
            //                           ),
            //                           Container(
            //                             //alignment: Alignment.topLeft,
            //                             child: Text(
            //                               "+4%",
            //                               style: textStyle(Colors.green, 12, false, false)
            //                             )
            //                           ),
            //                         ]
            //                       )
            //                     ),
            //                     Container(
            //                       alignment: Alignment.centerRight,
            //                       width: MediaQuery.of(context).size.width*0.075,
            //                       child: Text(
            //                         "4.24",
            //                         style: textStyle(Colors.grey[400]!, 20, false, false)
            //                       )
            //                     )
            //                   ]
            //                 ),
            //               ]
            //             )
            //           ),
            //           // Detail Section
            //           Container(
            //             height: 250,
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: <Widget>[
            //                 Container(
            //                   alignment: Alignment.centerLeft,
            //                   child: Text(
            //                     "Details",
            //                     style: textStyle(Colors.white, 24, false, false)
            //                   )
            //                 ),
            //                 Divider(
            //                   thickness: 1,
            //                   color: Colors.grey[400]
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: <Widget>[
            //                     Text(
            //                       "Sport / League",
            //                       style: textStyle(Colors.grey[400]!, 20, false, false)
            //                     ),
            //                     Text(
            //                       "American Football / NFL",
            //                       style: textStyle(Colors.grey[400]!, 20, false, false)
            //                     )
            //                   ]
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: <Widget>[
            //                     Text(
            //                       "Team",
            //                       style: textStyle(Colors.grey[400]!, 20, false, false)
            //                     ),
            //                     Text(
            //                       "Tampa Bay Buckaneers",
            //                       style: textStyle(Colors.grey[400]!, 20, false, false)
            //                     )
            //                   ]
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: <Widget>[
            //                     Text(
            //                       "Position",
            //                       style: textStyle(Colors.grey[400]!, 20, false, false)
            //                     ),
            //                     Text(
            //                       "Quarterback",
            //                       style: textStyle(Colors.grey[400]!, 20, false, false)
            //                     )
            //                   ]
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: <Widget>[
            //                     Text(
            //                       "Season Start",
            //                       style: textStyle(Colors.grey[400]!, 20, false, false)
            //                     ),
            //                     Text(
            //                       "Sep 1, 2021",
            //                       style: textStyle(Colors.grey[400]!, 20, false, false)
            //                     )
            //                   ]
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: <Widget>[
            //                     Text(
            //                       "Season End",
            //                       style: textStyle(Colors.grey[400]!, 20, false, false)
            //                     ),
            //                     Text(
            //                       "Jan 10, 2022",
            //                       style: textStyle(Colors.grey[400]!, 20, false, false)
            //                     )
            //                   ]
            //                 ),
            //               ]
            //             )
            //           ),
            //           // Stats section
            //           Container(
            //             height: 150,
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: <Widget>[
            //                 Container(
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     children: <Widget>[
            //                       Container(
            //                         child: Text(
            //                           "Key Statistics",
            //                           style: textStyle(Colors.white, 24, false, false)
            //                         ),
            //                       ),
            //                       Container(
            //                         width: 260,
            //                         child: Row(
            //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                           children: <Widget>[
            //                             Container(
            //                               alignment: Alignment.bottomLeft,
            //                               child: Text(
            //                                 "TD",
            //                                 style: textStyle(Colors.grey[400]!, 14, false, false)
            //                               ),
            //                             ),
            //                             Container(
            //                               alignment: Alignment.bottomLeft,
            //                               child: Text(
            //                                 "Cmp",
            //                                 style: textStyle(Colors.grey[400]!, 14, false, false)
            //                               ),
            //                             ),
            //                             Container(
            //                               alignment: Alignment.bottomLeft,
            //                               child: Text(
            //                                 "Cmp %",
            //                                 style: textStyle(Colors.grey[400]!, 14, false, false)
            //                               ),
            //                             ),
            //                             Container(
            //                               alignment: Alignment.bottomLeft,
            //                               child: Text(
            //                                 "YDS",
            //                                 style: textStyle(Colors.grey[400]!, 14, false, false)
            //                               ),
            //                             ),
            //                           ]
            //                         )
            //                       ),
            //                     ]
            //                   )
            //                 ),
            //                 Divider(
            //                   thickness: 1,
            //                   color: Colors.grey[400]
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: <Widget>[
            //                     Container(
            //                       child: Text(
            //                         "Current Stats",
            //                         style: textStyle(Colors.grey[400]!, 16, false, false)
            //                       ),
            //                     ),
            //                     Container(
            //                       width: 260,
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                         children: <Widget>[
            //                           Container(
            //                             alignment: Alignment.bottomLeft,
            //                             child: Text(
            //                               "12",
            //                               style: textStyle(Colors.grey[400]!, 16, false, false)
            //                             ),
            //                           ),
            //                           Container(
            //                             alignment: Alignment.bottomLeft,
            //                             child: Text(
            //                               "24",
            //                               style: textStyle(Colors.grey[400]!, 16, false, false)
            //                             ),
            //                           ),
            //                           Container(
            //                             alignment: Alignment.bottomLeft,
            //                             child: Text(
            //                               "80%",
            //                               style: textStyle(Colors.grey[400]!, 16, false, false)
            //                             ),
            //                           ),
            //                           Container(
            //                             alignment: Alignment.bottomLeft,
            //                             child: Text(
            //                               "2,000",
            //                               style: textStyle(Colors.grey[400]!, 16, false, false)
            //                             ),
            //                           ),
            //                         ]
            //                       )
            //                     )
            //                   ]
            //                 ),
            //                 Container(
            //                   alignment: Alignment.centerLeft,
            //                   child: Text(
            //                     "View All Stats",
            //                     style: textStyle(Colors.amber[400]!, 16, false, true)
            //                   )
            //                 )
            //               ]
            //             )
            //           ),
            //         ]
            //       )
            //     )
            //   ]
            // ),
          )
        ]
      )
    ));
  }
}
