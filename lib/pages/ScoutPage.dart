import 'package:ae_dapp/pages/DexPage.dart';
import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/service/AthleteApi.dart';
import 'package:ae_dapp/style/Style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScoutPage extends StatefulWidget {
  const ScoutPage({Key? key}) : super(key: key);

  @override
  _ScoutPageState createState() => _ScoutPageState();
}

class _ScoutPageState extends State<ScoutPage> {
  // name variable to store future list item name on tap
  late String name;
  late List war;
  late List time;
  late List<Athlete> athleteList;
  late List<Athlete> nflList;
  late List<Athlete> otherList;
  Widget filler = Text("Filler Text");
  double filterText = 20;
  bool firstRun = true;

  get displayedAthletes => null;

  // reset the name for the state when list item on tap
  @override
  void initState() {
    super.initState();
    name = 'Click an athlete';
    war = [0, 0, 0];
    time = [0, 0, 0];

    athleteList = [];
    otherList = [];
  }

  double lgTxSize = 52;
  double headerTx = 30;

  Widget buildGraph(List war, List time) {
    List<FlSpot> athleteData = [];

    for (int i = 0; i < war.length - 1; i++) {
      athleteData.add(FlSpot(time[i].toDouble(), war[i].toDouble()));
    }

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
        ),
        backgroundColor: Colors.grey[800],
        minX: 0,
        maxX: 5,
        minY: 0,
        maxY: 1,
        gridData: FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
        lineBarsData: [
          LineChartBarData(
            colors: [(Colors.amber[600])!],
            spots: athleteData,
            isCurved: false,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: AthleteApi.getAthletesLocally(context),
        builder: (context, snapshot) {
          nflList = snapshot.data;
          if (firstRun) athleteList = nflList;
          // switch (snapshot.connectionState) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              // return circle indicator for progress
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return Scaffold(
                  body: getBasePage(Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.grey[600]!,
                    width: 6,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          // search for an athlete
//                             SizedBox(
//                               width: 250,
//                               height: 50,
//                               child: ConstrainedBox(
//                                 constraints: BoxConstraints.tight(Size(250, 60)),
//                                 child: TextFormField(
//                                   onChanged: (textVal){
//                                     textVal=textVal.toLowerCase();
//                                     List<Athlete> tempList = nflList.where(
//                                       (_athlete) {
//                                         var at = _athlete.name.toLowerCase();
// print("Updating "+_athlete.name);if(at.contains(textVal)) print(' true');
//                                         return at.contains(textVal);
//                                       }
//                                     ).toList();

//                                     displayedAthletes.setList(tempList);

//             //                         setState((){
//             //                           displayedAthletes=nflList.where((_athlete)
//             //                           {
//             // print(textVal + ' ' + _athlete.name.contains(textVal).toString());
//             //                             var at = _athlete.name.toLowerCase();
//             //                             return at.contains(textVal);
//             //                           }).toList();
//             // for (int i = 0; i < displayedAthletes.length; i++) print(displayedAthletes[i].name+' ');
//             //                         });
//                                   },
//                                   textAlign: TextAlign.center,
//                                   decoration: InputDecoration(
//                                       fillColor: Colors.grey[800],
//                                       filled: true,
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(20.0),
//                                         borderSide: BorderSide(
//                                           color: (Colors.grey[900])!,
//                                           width: 3.0,
//                                         ),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(20.0),
//                                         borderSide: BorderSide(
//                                           color: (Colors.grey[900])!,
//                                           width: 3.0,
//                                         ),
//                                       ),
//                                       border: UnderlineInputBorder(),
//                                       hintText: 'Search for an Athlete',
//                                       hintStyle: TextStyle(
//                                         fontSize: 15,
//                                       )),
//                                 ),
//                               ),
//                             ),

                          // generate athlete cards
                          Column(children: <Widget>[
                            // Sport Filter
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * .06,
                                width: MediaQuery.of(context).size.width * .3,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                .03),
                                    child: Row(
                                      children: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                athleteList = nflList;
                                                firstRun = false;
                                              });
                                            },
                                            child: Text(
                                              "NFL",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'OpenSans',
                                                fontSize: filterText,
                                              ),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                athleteList = [];
                                                firstRun = false;
                                              });
                                            },
                                            child: Text(
                                              "NBA",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'OpenSans',
                                                fontSize: filterText,
                                              ),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                athleteList = [];
                                                firstRun = false;
                                              });
                                            },
                                            child: Text(
                                              "MMA",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'OpenSans',
                                                fontSize: filterText,
                                              ),
                                            )),
                                      ],
                                    ))),
                            // Athlete ListView
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                height:
                                    MediaQuery.of(context).size.height * .62,
                                width: MediaQuery.of(context).size.width * .3,
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(10.0)),
                                    ),
                                    // child: buildAthletes()
                                    child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: athleteList.length,
                                        itemBuilder: (context, index) {
                                          final athlete = athleteList[index];
                                          return Card(
                                              color: Colors.grey[900],
                                              shadowColor: Colors.grey[900],
                                              child: ListTile(
                                                  onTap: () => setState(() => {
                                                        name = athlete.name,
                                                        war = athlete.war,
                                                        time = athlete.time
                                                      }),
                                                  title: Text(athlete.name)));
                                        })))
                          ])
                        ],
                      ),

                      // Hidden graph and athlete INFO until DB secure
                      Column(children: [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Row(children: [
                          Container(
                              width: 600,
                              height: 75,
                              child: Row(
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.sports_football,
                                                  size: 40,
                                                  color: Colors.white
                                                      .withOpacity(0.6))
                                            ],
                                          ),
                                        ),
                                      ]),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Column(
                                            children: [
                                              Text(name, style: athleteText)
                                            ],
                                          ),
                                        ),
                                      ]),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Column(
                                            children: [
                                              Text(
                                                  "\$" +
                                                      (war[0])
                                                          .toStringAsFixed(4),
                                                  style: athleteWAR)
                                            ],
                                          ),
                                        ),
                                      ]),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Column(
                                            children: [
                                              Text('+0.79%',
                                                  style: athletePercent)
                                            ],
                                          ),
                                        ),
                                      ])
                                ],
                              )),
                        ]),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    height: 250,
                                    width: 600,
                                    child: StreamBuilder(
                                      builder: (context, snapshot) =>
                                          buildGraph(war, time),
                                      stream:
                                          Stream.periodic(Duration(seconds: 7)),
                                    )),
                              ]),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        // Quad buttons (short, long, mint, redeem)
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              // Long / Mint
                              Row(children: <Widget>[
                                // Long button
                                Container(
                                  width: 160,
                                  height: 42,
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: ElevatedButton(
                                        style: longButton,
                                        onPressed: () {
                                          // DexPage();
                                        },
                                        child: Text('LONG'),
                                      )),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                // Mint button
                                Container(
                                  width: 160,
                                  height: 42,
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: ElevatedButton(
                                        style: mintButton,
                                        // Mint Popup
                                        onPressed: () => mintDialog(context),
                                        child: Text('MINT'),
                                      )),
                                ),
                              ]),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                              // Short / Redeem
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    // Short Button
                                    Container(
                                      width: 160,
                                      height: 42,
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: ElevatedButton(
                                            style: shortButton,
                                            onPressed: () {
                                              // DexPage();
                                            },
                                            child: Text('SHORT'),
                                          )),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    // Redeem button
                                    Container(
                                      width: 160,
                                      height: 42,
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: ElevatedButton(
                                            style: redeemButton,
                                            onPressed: () {},
                                            child: Text('REDEEM'),
                                          )),
                                    ),
                                  ]),
                            ])
                      ])
                    ]),
              )));
          }
        });
  }

  Widget getBasePage(Widget _children) {
    return Stack(children: <Widget>[
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
              )),
          // Container(
          //     width: 500,
          //     height: 500,
          //     color: Colors.transparent,
          //     child: Align(
          //         alignment: Alignment.center,
          //         child: Center(
          //           child: Text('COMING SOON', style: comingSoon),
          //         ))),
          _children
        ],
      )
    ]);
  }

  void mintDialog(BuildContext context) {
    if (name != 'Click an athlete') {
      Dialog fancyDialog = Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.grey[600]!,
              width: 6,
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width * 0.3,
          child: Stack(children: <Widget>[
            // Container(
            //   width: double.infinity,
            //   height: 300,
            //   decoration: BoxDecoration(
            //     color: Colors.grey[100],
            //     borderRadius: BorderRadius.circular(12.0),
            //   ),
            // ),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .75,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * 0.03),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "MINT",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      name + " ATPs",
                      style: TextStyle(
                          color: Colors.amber[600],
                          fontSize: 32,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                        height: 62,
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.all(const Radius.circular(10.0)),
                          border: Border.all(
                            color: Colors.grey[700]!,
                            width: 2,
                          ),
                        ),
                        child: Center(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Input AX Amount',
                                    border: InputBorder.none,
                                  ),
                                )))),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.035),
                    Text(
                      'You will receive:',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      '20 Long ' + name + ' APTs',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 26,
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      '20 Short ' + name + ' APTs',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 26,
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.04),
                    Container(
                        height: 62,
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.amber[600],
                          borderRadius:
                              BorderRadius.all(const Radius.circular(10.0)),
                        ),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              mintConfirmDialog(context);
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
                            )))
                  ],
                )),
            Align(
              // These values are based on trial & error method
              alignment: Alignment(0.92, -0.95),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 35,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ]),
        ),
      );

      showDialog(
          context: context, builder: (BuildContext context) => fancyDialog);
    }
  }

  void mintConfirmDialog(BuildContext context) {
    if (name != 'Click an athlete') {
      Dialog fancyDialog = Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.grey[600]!,
              width: 6,
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.45,
          width: MediaQuery.of(context).size.width * 0.3,
          child: Stack(children: <Widget>[
            // Container(
            //   width: double.infinity,
            //   height: 300,
            //   decoration: BoxDecoration(
            //     color: Colors.grey[100],
            //     borderRadius: BorderRadius.circular(12.0),
            //   ),
            // ),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.45,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * 0.06),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Mint Approved!",
                        style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      'You will receive:',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      '20 Long ' + name + ' APTs',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 26,
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      '20 Short ' + name + ' APTs',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 26,
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.04),
                    Container(
                        height: 62,
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.amber[600],
                          borderRadius:
                              BorderRadius.all(const Radius.circular(10.0)),
                        ),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Back to Scout',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
                            )))
                  ],
                )),
            Align(
              // These values are based on trial & error method
              alignment: Alignment(0.92, -0.95),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 35,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ]),
        ),
      );

      showDialog(
          context: context, builder: (BuildContext context) => fancyDialog);
    }
  }
}
