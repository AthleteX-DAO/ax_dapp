import 'package:ae_dapp/service/AllAthletesList.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/pages/PlayerPage.dart';

class MyTeam extends StatefulWidget {
  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {

  double lgTxSz = 52;
  double midTxSz = 36;
  double smTxSz = 24;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/background.jpeg"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Column(
            children: <Widget>[
              // Top Right 'X'
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
              // 'MY TEAM' Text
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "MY TEAM",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: lgTxSz,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  )
                )
              ),
              // Account Info
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: MediaQuery.of(context).size.width-40,
                // Top Text Row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // 'User Name' Text
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          "User Name",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: midTxSz,
                            fontWeight: FontWeight.w600
                          )
                        )
                      )
                    ),
                    // Account Profits ($1000)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "\$1,000",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: smTxSz*.9,
                              fontWeight: FontWeight.w600
                            )
                          ),
                          Text(
                            "+10%",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: smTxSz*.7,
                              color: Colors.green[700]
                            )
                          ),
                        ],
                      )
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(20, 20, 20, 1), // Dark Grey
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
              ),
              // Bottom Half Container
              Container(
                width: MediaQuery.of(context).size.width-40,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical:10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            "My Athletes",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: smTxSz,
                              fontWeight:FontWeight.w600,
                            )
                          ),
                          Text(
                            "Transactions",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: smTxSz,
                              fontWeight:FontWeight.w600,
                            )
                          ),
                        ],
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom:5, right: 5),
                          height: MediaQuery.of(context).size.height*.47,
                          width: MediaQuery.of(context).size.width/2-60,
                          child: AllAthletesList()
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/2-60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "6/30/21: A1 Long +50",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: smTxSz,
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
                                    fontSize: smTxSz,
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
                                    fontSize: smTxSz,
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
                                    fontSize: smTxSz,
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
                                    fontSize: smTxSz,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ),
                            ],
                          )
                        ),
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}