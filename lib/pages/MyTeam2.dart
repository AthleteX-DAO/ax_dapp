import 'package:flutter/material.dart';

class MyTeam2 extends StatefulWidget {
  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam2> {

  Widget build(BuildContext context) {

    double userTextSize = 30;
    double midSize = 20;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/background.jpeg"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Row(
                        children: <Widget>[
                          /// TODO: Player Photo
                          
                          Text(
                            "User Name",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: userTextSize,
                              fontWeight: FontWeight.w600
                            )
                          ),
                          Column(
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
                                  fontSize: midSize,
                                  color: Colors.green[700]
                                )
                              ),
                            ],
                          )
                        ],
                      )
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: [
                              Text(
                                "My Athletes",
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: midSize,
                                  fontWeight: FontWeight.w600
                                )
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Transactions",
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: userTextSize,
                                  fontWeight: FontWeight.w600
                                )
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),

                )
              ],
            )
          )
        ]
      )
    );
  }
}