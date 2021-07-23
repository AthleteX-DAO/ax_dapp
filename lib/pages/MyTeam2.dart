import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Portfolio.dart';
import 'package:ae_dapp/pages/PlayerPage.dart';
import 'package:ae_dapp/pages/NavigationBar.dart';

class MyTeam2 extends StatefulWidget {
  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam2> {

  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double userTextSize = width*.03;
    double smSize = width*.012;
    double midSize = width*.015;
    double lgTxSize = width*.052;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/background.jpeg"),
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Image(
                    width: 80,
                    height: 80,
                    image: AssetImage("assets/images/x.png"),
                  ),
                )
              ),
              Text(
                "MY TEAM",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: lgTxSize,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                )
              ),
              Container(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: (width/2) - 20,
                          height: height/11,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(20, 20, 20, 1), // Dark Grey
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              /// TODO: Player Photo
                              Container(
                                // padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "User Name",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: userTextSize,
                                    fontWeight: FontWeight.w600
                                  )
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: (width/5)),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "\$1,000",
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: midSize,
                                        fontWeight: FontWeight.w600
                                      )
                                    ),
                                    Text(
                                      "+10%",
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: midSize*.9,
                                        color: Colors.green[700]
                                      )
                                    ),
                                  ]
                                )
                              ),
                            ],
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: (width/2) - 20,
                          height: 3*(height/5) - 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.grey[900],
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "My Athletes",
                                        style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: midSize,
                                          fontWeight:FontWeight.w600,
                                        )
                                      )
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Transactions",
                                        style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: midSize,
                                          fontWeight:FontWeight.w600,
                                        )
                                      )
                                    ),
                                  ],
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        buildAthlete("Athlete 1", 10.792, width)
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            "6/30/21: A1 Long +50",
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontSize: smSize,
                                              color: Colors.grey[350]
                                            ),
                                          )
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            "6/24/21: A2 Long +50",
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontSize: smSize,
                                              color: Colors.grey[350]
                                            ),
                                          )
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            "6/20/21: A3 Short -50",
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontSize: smSize,
                                              color: Colors.grey[350]
                                            ),
                                          )
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            "6/10/21: A4 Long +100",
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontSize: smSize,
                                              color: Colors.grey[350]
                                            ),
                                          )
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            "View All Tx History",
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontSize: smSize,
                                              fontWeight: FontWeight.w600
                                            ),
                                          )
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ),
                            ],
                          )
                        )
                      ],
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(right: 20),
                      height: (3*height/5 - 54) + height/11,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: Portfolio()
                          )
                          //       new Sparkline(data: data,
                          // lineWidth: 10.0,
                          // fillMode: FillMode.below,
                          // fillColor: Colors.amber[700],
                          // pointsMode: PointsMode.all,
                          // pointSize: 3.0,
                          // pointColor: Colors.black)
                        ],
                      )
                    )
                  ),
                ],
              )
            ],
          )
        ]
      )
    );
  }

  Widget buildAthlete(String _name, double _price, double _width){
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: (_width/4) - 40,
        child: ElevatedButton(
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Icon(
                  Icons.groups_sharp,
                  color: Colors.grey[800],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  _name,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: _width*.015,
                  )
                )
              ),
              Container(
                padding: EdgeInsets.only(left: _width/6-200, bottom: 8),
                // alignment: Alignment.topLeft,
                child: Text(
                  getPrice(_price),
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: _width*.01,
                  )
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => PlayerPage()),
            );
          },
          style: ButtonStyle(
            // foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
          )
        ),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
      )
    );
  }

  String getPrice(double _price) {
    return "\$" + _price.toStringAsFixed(2);
  }
}