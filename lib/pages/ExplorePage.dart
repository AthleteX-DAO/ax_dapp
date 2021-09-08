import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/service/AthleteApi.dart';
import 'package:ae_dapp/style/Style.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // name variable to store future list item name on tap
  late String name;
  late List war;
  late List time;

  // reset the name for the state when list item on tap
  @override
  void initState() {
    super.initState();
    name = 'Click an athlete';
    war = [0, 0, 0];
    time = [0, 0, 0];
  }

  double lgTxSize = 52;
  double headerTx = 30;

  //widget to get athlete data and build ListView
  Widget buildAthleteList(BuildContext context) => Scaffold(
      body: FutureBuilder<List<Athlete>>(
          future: AthleteApi.getAthletesLocally(context),
          builder: (context, snapshot) {
            final athletes = snapshot.data;

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return buildAthletes(athletes!);
            }
          }));
  //build ListView for athletes
  Widget buildAthletes(List<Athlete> athletes) => ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: athletes.length,
      itemBuilder: (context, index) {
        final athlete = athletes[index];
        return Card(
            color: Colors.grey[900],
            shadowColor: Colors.grey[900],
            child: ListTile(
                onTap: () => setState(() => name = athlete.name),
                title: Text(athlete.name)));
      });

  Widget buildGraph(List war, List time) {
    List<FlSpot> athleteData = [];

    for (int i = 0; i < war.length - 1; i++) {
      athleteData.add(FlSpot(time[i], war[i]));
    }

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
        ),
        backgroundColor: Colors.grey[800],
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 6,
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
            width: 500,
            height: 500,
            color: Colors.transparent,
            child: Align(
                alignment: Alignment.center,
                child: Center(
                  child: Text('COMING SOON', style: comingSoon),
                ))),
        // Container(
        //   width: MediaQuery.of(context).size.width * .5,
        //   height: MediaQuery.of(context).size.height * .675,
        //   padding: EdgeInsets.only(top: 20),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     color: Colors.grey[900],
        //   ),
        // child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: <Widget>[
        //       Column(
        //         children: <Widget>[
        //           // search for an athlete
        //           SizedBox(
        //             width: 250,
        //             height: 50,
        //             child: ConstrainedBox(
        //               constraints: BoxConstraints.tight(Size(250, 60)),
        //               child: TextFormField(
        //                 textAlign: TextAlign.center,
        //                 decoration: InputDecoration(
        //                     fillColor: Colors.grey[800],
        //                     filled: true,
        //                     focusedBorder: OutlineInputBorder(
        //                       borderRadius: BorderRadius.circular(20.0),
        //                       borderSide: BorderSide(
        //                         color: (Colors.grey[900])!,
        //                         width: 3.0,
        //                       ),
        //                     ),
        //                     enabledBorder: OutlineInputBorder(
        //                       borderRadius: BorderRadius.circular(20.0),
        //                       borderSide: BorderSide(
        //                         color: (Colors.grey[900])!,
        //                         width: 3.0,
        //                       ),
        //                     ),
        //                     border: UnderlineInputBorder(),
        //                     hintText: 'Search for an Athlete',
        //                     hintStyle: TextStyle(
        //                       fontSize: 15,
        //                     )),
        //               ),
        //             ),
        //           ),
        //           // generate athlete cards
        //           Container(
        //               height: MediaQuery.of(context).size.height * .45,
        //               width: MediaQuery.of(context).size.width / 2 - 350,
        //               child: Container(
        //                 decoration: BoxDecoration(
        //                   color: Colors.grey[900],
        //                   borderRadius:
        //                       BorderRadius.all(const Radius.circular(10.0)),
        //                 ),
        //                 child: FutureBuilder<dynamic>(
        //                     future: AthleteApi.getAthletesLocally(context),
        //                     builder: (context, snapshot) {
        //                       final athletes = snapshot.data;

        //                       switch (snapshot.connectionState) {
        //                         case ConnectionState.waiting:
        //                           return Center(
        //                             child: CircularProgressIndicator(),
        //                           );
        //                         default:
        //                           return buildAthletes(athletes!);
        //                       }
        //                     }),
        //               )),
        //         ],
        //       ),

        //       // Hidden graph and athlete INFO until DB secure
        //       Column(children: [
        //         Row(children: [
        //           Container(
        //               width: 600,
        //               height: 75,
        //               child: Row(
        //                 children: [
        //                   Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Padding(
        //                           padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        //                           child: Column(
        //                             crossAxisAlignment:
        //                                 CrossAxisAlignment.start,
        //                             children: [
        //                               Icon(Icons.sports_football,
        //                                   size: 40,
        //                                   color:
        //                                       Colors.white.withOpacity(0.6))
        //                             ],
        //                           ),
        //                         ),
        //                       ]),
        //                   Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Padding(
        //                           padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                           child: Column(
        //                             children: [
        //                               Text(name, style: athleteText)
        //                             ],
        //                           ),
        //                         ),
        //                       ]),
        //                   Column(
        //                       crossAxisAlignment: CrossAxisAlignment.end,
        //                       children: [
        //                         Padding(
        //                           padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                           child: Column(
        //                             children: [
        //                               Text("\$" + (war[0]).toStringAsFixed(4),
        //                                   style: athleteWAR)
        //                             ],
        //                           ),
        //                         ),
        //                       ]),
        //                   Column(
        //                       crossAxisAlignment: CrossAxisAlignment.end,
        //                       children: [
        //                         Padding(
        //                           padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                           child: Column(
        //                             children: [
        //                               Text('+0.79%', style: athletePercent)
        //                             ],
        //                           ),
        //                         ),
        //                       ])
        //                 ],
        //               )),
        //         ]),
        //         Padding(
        //           padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        //           child: Row(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: [
        //                 Container(
        //                     height: 250,
        //                     width: 600,
        //                     child: StreamBuilder(
        //                       builder: (context, snapshot) =>
        //                           buildGraph(war, time),
        //                       stream: Stream.periodic(Duration(seconds: 7)),
        //                     )),
        //               ]),
        //         ),
        //         Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               SizedBox(
        //                 height: 60,
        //                 width: 600,
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                   children: [
        //                     Column(children: [
        //                       SizedBox(
        //                         width: 125,
        //                         height: 50,
        //                         child: Padding(
        //                             padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                             child: ElevatedButton(
        //                               style: longButton,
        //                               onPressed: () {},
        //                               child: Text('LONG'),
        //                             )),
        //                       )
        //                     ]),
        //                     Column(children: [
        //                       SizedBox(
        //                         width: 125,
        //                         height: 50,
        //                         child: Padding(
        //                             padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                             child: ElevatedButton(
        //                               style: shortButton,
        //                               onPressed: () {},
        //                               child: Text('SHORT'),
        //                             )),
        //                       )
        //                     ]),
        //                     Column(children: [
        //                       SizedBox(
        //                         width: 125,
        //                         height: 50,
        //                         child: Padding(
        //                             padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                             child: ElevatedButton(
        //                               style: mintButton,
        //                               onPressed: () {},
        //                               child: Text('MINT'),
        //                             )),
        //                       )
        //                     ]),
        //                     Column(children: [
        //                       SizedBox(
        //                         width: 125,
        //                         height: 50,
        //                         child: Padding(
        //                             padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                             child: ElevatedButton(
        //                               style: redeemButton,
        //                               onPressed: () {},
        //                               child: Text('REDEEM'),
        //                             )),
        //                       )
        //                     ])
        //                   ],
        //                 ),
        //               )
        //             ]),
        //         Row(children: [Container(width: 600, height: 100)])
        //       ])
        //     ]),
        // ),
      ]),
    ]));
  }
}
