import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Athlete {
  final String name;
  final List time;
  final List war;

  // const Athlete({required this.name, required this.time, required this.war});
  Athlete({required this.name, required this.time, required this.war});

  static Athlete fromJson(json) =>
      Athlete(name: json['name'], time: json['time'], war: json['war']);

  Widget createAthletePage(BuildContext context) {
    return Column(
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
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                                  padding: EdgeInsets.fromLTRB(15, 5, 50, 0),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w400),
                                  ))),
                        ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  color: Colors.grey[900],
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                                    child: Text(
                                      war[0],
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )),
                            ]),
                        Column(children: [
                          Container(
                              color: Colors.grey[900],
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
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
              child: SizedBox(width: 600, height: 75, child: Row(children: [])),
            )),
        // insert athlete graph here
        Align(
            child: SizedBox(
          width: 600,
          height: 200,
        )),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (BuildContext context) =>
                                  //       _mintAPT(context),
                                  // );
                                },
                              )),
                          Container(
                              color: Colors.grey[900],
                              child: ElevatedButton(
                                style: redeemButton,
                                child: Text('REDEEM'),
                                onPressed: () {
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (BuildContext context) =>
                                  //       _redeemAX(context),
                                  // );
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
                            constraints: BoxConstraints.tight(Size(250, 60)),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey[800],
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: (Colors.amber[600])!,
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
                            // style: mintAndRedeemText,
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                          width: 300,
                          height: 40,
                          child: Text(
                              '**Redeem: Supply APT-LSP (Athlete Performace Token Long/Short Pair and receive AX**',
                              // style: mintAndRedeemText,
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
    );
  }

  final ButtonStyle longButton = ElevatedButton.styleFrom(
      textStyle: TextStyle(
          fontSize: 12, fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
      primary: Colors.green,
      onPrimary: Colors.white,
      fixedSize: Size(100, 50));
  final ButtonStyle shortButton = ElevatedButton.styleFrom(
      textStyle: TextStyle(
          fontSize: 12, fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
      primary: Colors.red,
      onPrimary: Colors.white,
      fixedSize: Size(100, 50));
  final ButtonStyle mintButton = ElevatedButton.styleFrom(
      textStyle: TextStyle(
          fontSize: 12, fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
      primary: Colors.red,
      onPrimary: Colors.white,
      fixedSize: Size(100, 50));
  final ButtonStyle redeemButton = ElevatedButton.styleFrom(
      textStyle: TextStyle(
          fontSize: 12, fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
      primary: Colors.red,
      onPrimary: Colors.white,
      fixedSize: Size(100, 50));
}
