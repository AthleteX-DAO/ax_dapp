import 'package:ae_dapp/pages/AthletePage.dart';
import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/service/AthleteApi.dart';
import 'package:flutter/material.dart';

class DesktopScout extends StatefulWidget {
  const DesktopScout({Key? key}) : super(key: key);

  @override
  _DesktopScoutState createState() => _DesktopScoutState();
}

class _DesktopScoutState extends State<DesktopScout> {
  int athletePage = 0;
  int sportState = 0;
  List<Athlete> nflList = [];
  Athlete curAthlete = Athlete(name: "", team: "", position: "", passingYards: [], passingTouchDowns: [], reception: [], receiveYards: [], receiveTouch: [], rushingYards: [], war: [], time: []);
  
  
  @override
  Widget build(BuildContext context) {
    double sportFilterTxSz = 18;
    if (athletePage == 1)
      return AthletePage(athlete: curAthlete);

    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height*0.9,
        width: MediaQuery.of(context).size.width*0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // APT Title & Sport Filter
            Container(
              width: MediaQuery.of(context).size.width*0.4,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "APT List",
                    style: textStyle(Colors.white, 18, false, false)
                  ),
                  Text(
                    "|",
                    style: textStyle(Colors.white, 18, false, false)
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        if (sportState != 0) setState(() {sportState = 0;});
                      },
                      child: Text(
                        "ALL",
                        style: textSwapState(
                          sportState == 0,
                          textStyle(Colors.white, sportFilterTxSz, false, false),
                          textStyle(Colors.amber[400]!, sportFilterTxSz, false, true)
                        )
                      ),
                    )
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {if (sportState != 1) setState(() {sportState = 1;});},
                      child: Text(
                        "NFL",
                        style: textSwapState(
                          sportState == 1,
                          textStyle(Colors.white, sportFilterTxSz, false, false),
                          textStyle(Colors.amber[400]!, sportFilterTxSz, false, true)
                        )
                      ),
                    )
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {if (sportState != 2) setState(() {sportState = 2;});},
                      child: Text(
                        "NBA",
                        style: textSwapState(
                          sportState == 2,
                          textStyle(Colors.white, sportFilterTxSz, false, false),
                          textStyle(Colors.amber[400]!, sportFilterTxSz, false, true)
                        )
                      ),
                    )
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {if (sportState != 3) setState(() {sportState = 3;});},
                      child: Text(
                        "MMA",
                        style: textSwapState(
                          sportState == 3,
                          textStyle(Colors.white, sportFilterTxSz, false, false),
                          textStyle(Colors.amber[400]!, sportFilterTxSz, false, true)
                        )
                      ), 
                    )
                  ),        
                ]
              ),
            ),
            // List Headers
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 66
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.15,
                  child: Text(
                    "Athlete",
                    style: textStyle(Colors.grey[400]!, 12, false, false)
                  )
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.15,
                  child: Text(
                    "Team",
                    style: textStyle(Colors.grey[400]!, 12, false, false)
                  )
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.1,
                  child: Text(
                    "Market Price / Change",
                    style: textStyle(Colors.grey[400]!, 12, false, false)
                  )
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.1,
                  child: Text(
                    "Book Value / Change",
                    style: textStyle(Colors.grey[400]!, 12, false, false)
                  )
                ),
              ]
            ),
            // ListView of Athletes
            buildListview(nflList)
          ]
        )
      )
    );
  }

  Widget buildListview(List<Athlete> allAthletes) {
    if (allAthletes.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height*0.6,
        child: FutureBuilder<dynamic>(
          future: AthleteApi.getAthletesLocally(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                // return circle indicator for progress
                return Center(
                  child:
                      CircularProgressIndicator(),
                );
              default:
                allAthletes = snapshot.data;
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: allAthletes.length,
                  itemBuilder: (context, index) {
                    final athlete = allAthletes[index];
                    return createListCards(athlete);
                  }
                );
            }
          }
        )
      );
    }
    // if athleteList is not empty
    else {
      return Container();
    }
  }

  // Athlete Cards
  Widget createListCards(Athlete athlete) {
    return Container(
      height: 70,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            curAthlete = athlete;
            athletePage = 1;
          });
			  },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Icon
                Container(
                  width: 50,
                  child: Icon(
                    Icons.sports_football,
                    color: Colors.grey[700]
                  )
                ),
                // Athlete Name
                Container(
                  width: MediaQuery.of(context).size.width*0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                      athlete.name,
                        style: textStyle(Colors.white, 18, false, false)
                      ),
                      Text(
                        athlete.position,
                        style: textStyle(Colors.grey[700]!, 10, false, false)
                      )
                    ]
                  )
                ),
                // Team
                Container(
                  width: MediaQuery.of(context).size.width*0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        athlete.team,
                        style: textStyle(Colors.white, 18, false, false)
                      ),
                      Text(
                        athlete.team,
                        style: textStyle(Colors.grey[700]!, 10, false, false)
                      )
                    ]
                  )
                ),
                // Market Price
                Container(
                  width: MediaQuery.of(context).size.width*0.1,
                  child: Row(
                  children: <Widget>[
                    Text(
                      "\$"+athlete.war[athlete.war.length-1].toStringAsFixed(4),
                      style: textStyle(Colors.white, 16, false, false)
                    ),
                    Text(
                    "+%4",
                    style: textStyle(Colors.green, 12, false, false)
                    )
                  ]
                  )
                ),
                // Book Price
                Container(
                  width: MediaQuery.of(context).size.width*0.1,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "\$"+athlete.war[athlete.war.length-1].toStringAsFixed(4),
                        style: textStyle(Colors.white, 16, false, false)
                      ),
                      Text(
                        "-%2",
                        style: textStyle(Colors.red, 12, false, false)
                      )
                    ]
                  )
                ),
              ]
            ),
            Row(
              children: <Widget>[
                // Buy
            Container(
              width: 100,
              height: 30,
                  decoration: boxDecoration(Colors.amber[400]!, 100, 0, Colors.amber[400]!),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Buy",
                      style: textStyle(Colors.black, 16, false, false)
                    )
                  )
                ),
                Container(
                  width: 25
                ),
                // Mint
                Container(
                  width: 100,
                  height: 30,
                  decoration: boxDecoration(Colors.transparent, 100, 2, Colors.white),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Mint",
                      style: textStyle(Colors.white, 16, false, false)
                    )
                  )
                )
              ]
            )
          ]
        )
      )
    );
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold)
      if (isUline)
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline
        );
      else
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
        );
    else
      if (isUline)
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline
        );
      else
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
        );
  }

  TextStyle textSwapState(bool condition, TextStyle fls, TextStyle tru) {
    if (condition)
      return tru;
    return fls;
  }

  BoxDecoration boxDecoration(Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
      color: col,
      borderRadius: BorderRadius.circular(rad),
      border: Border.all(
        color: borCol,
        width: borWid
      )
    );
  }

}