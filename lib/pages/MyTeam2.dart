import 'package:ax_dapp/service/AllAthletesList.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Portfolio.dart';
import 'package:ax_dapp/pages/PlayerPage.dart';

class MyTeam2 extends StatefulWidget {
  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam2> {

  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double userTextSize = 3;
    double smSize = 24;
    double midSize = 36;
    double lgTxSize = 52;

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
                          // width: (width/2) - 20,
                          width: width-50,
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
                                    fontSize: midSize,
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
                                        fontSize: smSize*.9,
                                        fontWeight: FontWeight.w600
                                      )
                                    ),
                                    Text(
                                      "+10%",
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: smSize*.7,
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
                          // width: (width/2) - 20,
                          width: width-50,
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
                                          fontSize: smSize,
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
                                          fontSize: smSize,
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
                                    Container(
                                      padding: EdgeInsets.only(bottom:5, right: 5),
                                      height: height*.4,
                                      width: width/2-60,
                                      child: AllAthletesList()
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
                  // Expanded(
                  //   flex: 1,
                  //   child: Container(
                  //     padding: EdgeInsets.only(right: 20),
                  //     height: (3*height/5 - 54) + height/11,
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey[900],
                  //       borderRadius: BorderRadius.all(Radius.circular(20))
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         Container(
                  //           child: Portfolio()
                  //         )
                  //         //       new Sparkline(data: data,
                  //         // lineWidth: 10.0,
                  //         // fillMode: FillMode.below,
                  //         // fillColor: Colors.amber[700],
                  //         // pointsMode: PointsMode.all,
                  //         // pointSize: 3.0,
                  //         // pointColor: Colors.black)
                  //       ],
                  //     )
                  //   )
                  // ),
                ],
              )
            ],
          )
        ]
      )
    );
  }

  Widget buildAthlete(String _name, double _price, double _width){
    return Card(
      color: Colors.grey[800],
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.sports_baseball_rounded,
              color: Colors.yellow[760],
            ),
            title: Text(_name),
            subtitle: Text("Buy: $_price"),
            trailing: true
                ? Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                  )
                : Icon(Icons.check_circle_outline),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PlayerPage()),
              );
            },
          )
        ],
      ),
    );
  }

  String getPrice(double _price) {
    return "\$" + _price.toStringAsFixed(2);
  }
}