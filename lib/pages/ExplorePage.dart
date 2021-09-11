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
  late List<Athlete> athleteList;
  late ValueNotifier<List<Athlete>> displayedAthletes;

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
/*
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
*/
  //build ListView for athletes
/*
  Widget buildAthletes() => ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: displayedAthletes.value.length,
      itemBuilder: (context, index) {
        final athlete = displayedAthletes.value[index];
print("BuildAthletes: "+displayedAthletes.value[index].name+', '+athlete.name);
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
      });
*/
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
        athleteList = snapshot.data;

        // switch (snapshot.connectionState) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // return circle indicator for progress
            return Center(
              child: CircularProgressIndicator(),
            );
            break;

          default:
            displayedAthletes = ValueNotifier<List<Athlete>>(athleteList);
            return Scaffold(
              body: getBasePage(
                Container(
                width: MediaQuery.of(context).size.width * .75,
                height: MediaQuery.of(context).size.height * .684,
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
                        // search for an athlete
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tight(Size(250, 60)),
                            child: TextFormField(
                              onChanged: (textVal){
                                textVal=textVal.toLowerCase();
                                List<Athlete> tempList = athleteList.where(
                                  (_athlete) {
                                    var at = _athlete.name.toLowerCase();
        print("Updating "+_athlete.name);if(at.contains(textVal)) print(' true');
                                    return at.contains(textVal);
                                  }
                                ).toList();
                                
                                displayedAthletes = ValueNotifier<List<Athlete>>(tempList);

        for(int i=0;i<displayedAthletes.value.length;i++)print(displayedAthletes.value[i].name);
                                  
        //                         setState((){
        //                           displayedAthletes=athleteList.where((_athlete)
        //                           {
        // print(textVal + ' ' + _athlete.name.contains(textVal).toString());
        //                             var at = _athlete.name.toLowerCase();
        //                             return at.contains(textVal);
        //                           }).toList();
        // for (int i = 0; i < displayedAthletes.length; i++) print(displayedAthletes[i].name+' ');
        //                         });
                              },
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
                        
                        // generate athlete cards
                        Container(
                            height: MediaQuery.of(context).size.height * .45,
                            width: MediaQuery.of(context).size.width / 2 - 350,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius:
                                    BorderRadius.all(const Radius.circular(10.0)),
                              ),
                              // child: buildAthletes()
                              child: ValueListenableBuilder(
                                valueListenable: displayedAthletes,
                                builder: (BuildContext context, List<Athlete> _value, Widget? w) {
                                  return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: _value.length,
                                    itemBuilder: (context, index) {
                                      final athlete = _value[index];
print("BuildAthletes: "+_value[index].name+', '+athlete.name);
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
                                    });
                                },
                              )
                            )),
                      ],
                    ),

                    // Hidden graph and athlete INFO until DB secure
                    Column(children: [
                      Row(children: [
                        Container(
                            width: 600,
                            height: 75,
                            child: Row(
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.sports_football,
                                                size: 40,
                                                color:
                                                    Colors.white.withOpacity(0.6))
                                          ],
                                        ),
                                      ),
                                    ]),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Column(
                                          children: [
                                            Text(name, style: athleteText)
                                          ],
                                        ),
                                      ),
                                    ]),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Column(
                                          children: [
                                            Text("\$" + (war[0]).toStringAsFixed(4),
                                                style: athleteWAR)
                                          ],
                                        ),
                                      ),
                                    ]),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Column(
                                          children: [
                                            Text('+0.79%', style: athletePercent)
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
                                    stream: Stream.periodic(Duration(seconds: 7)),
                                  )),
                            ]),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 600,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(children: [
                                    SizedBox(
                                      width: 125,
                                      height: 50,
                                      child: Padding(
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: ElevatedButton(
                                            style: longButton,
                                            onPressed: () {},
                                            child: Text('LONG'),
                                          )),
                                    )
                                  ]),
                                  Column(children: [
                                    SizedBox(
                                      width: 125,
                                      height: 50,
                                      child: Padding(
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: ElevatedButton(
                                            style: shortButton,
                                            onPressed: () {},
                                            child: Text('SHORT'),
                                          )),
                                    )
                                  ]),
                                  Column(children: [
                                    SizedBox(
                                      width: 125,
                                      height: 50,
                                      child: Padding(
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: ElevatedButton(
                                            style: mintButton,
                                            onPressed: () {},
                                            child: Text('MINT'),
                                          )),
                                    )
                                  ]),
                                  Column(children: [
                                    SizedBox(
                                      width: 125,
                                      height: 50,
                                      child: Padding(
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: ElevatedButton(
                                            style: redeemButton,
                                            onPressed: () {},
                                            child: Text('REDEEM'),
                                          )),
                                    )
                                  ])
                                ],
                              ),
                            )
                          ]),
                      Row(children: [Container(width: 600, height: 100)])
                    ])
                  ]),
                )
              )
            );
        }
      }
    );
  }

  Widget compilePage(BuildContext context) {
    return Scaffold(
      body: getBasePage(
        Container(
        width: MediaQuery.of(context).size.width * .75,
        height: MediaQuery.of(context).size.height * .684,
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
                // search for an athlete
                SizedBox(
                  width: 250,
                  height: 50,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(Size(250, 60)),
                    child: TextFormField(
                      onChanged: (textVal){
                        textVal=textVal.toLowerCase();
                        List<Athlete> tempList = athleteList.where(
                          (_athlete) {
                            var at = _athlete.name.toLowerCase();
print("Updating "+_athlete.name);if(at.contains(textVal)) print(' true');
                            return at.contains(textVal);
                          }
                        ).toList();
                        
                        displayedAthletes = ValueNotifier<List<Athlete>>(tempList);

for(int i=0;i<displayedAthletes.value.length;i++)print(displayedAthletes.value[i].name);
                          
//                         setState((){
//                           displayedAthletes=athleteList.where((_athlete)
//                           {
// print(textVal + ' ' + _athlete.name.contains(textVal).toString());
//                             var at = _athlete.name.toLowerCase();
//                             return at.contains(textVal);
//                           }).toList();
// for (int i = 0; i < displayedAthletes.length; i++) print(displayedAthletes[i].name+' ');
//                         });
                      },
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
                
                // generate athlete cards
                Container(
                    height: MediaQuery.of(context).size.height * .45,
                    width: MediaQuery.of(context).size.width / 2 - 350,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius:
                            BorderRadius.all(const Radius.circular(10.0)),
                      ),
                      // child: buildAthletes()
                      child: ValueListenableBuilder(
                        valueListenable: displayedAthletes,
                        builder: (BuildContext context, List<Athlete> _value, Widget? w) {
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: _value.length,
                            itemBuilder: (context, index) {
                              final athlete = _value[index];
print("BuildAthletes: "+_value[index].name+', '+athlete.name);
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
                            });
                        },
                      )
                    )),
              ],
            ),

            // Hidden graph and athlete INFO until DB secure
            Column(children: [
              Row(children: [
                Container(
                    width: 600,
                    height: 75,
                    child: Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.sports_football,
                                        size: 40,
                                        color:
                                            Colors.white.withOpacity(0.6))
                                  ],
                                ),
                              ),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  children: [
                                    Text(name, style: athleteText)
                                  ],
                                ),
                              ),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  children: [
                                    Text("\$" + (war[0]).toStringAsFixed(4),
                                        style: athleteWAR)
                                  ],
                                ),
                              ),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  children: [
                                    Text('+0.79%', style: athletePercent)
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
                            stream: Stream.periodic(Duration(seconds: 7)),
                          )),
                    ]),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 600,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(children: [
                            SizedBox(
                              width: 125,
                              height: 50,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: ElevatedButton(
                                    style: longButton,
                                    onPressed: () {},
                                    child: Text('LONG'),
                                  )),
                            )
                          ]),
                          Column(children: [
                            SizedBox(
                              width: 125,
                              height: 50,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: ElevatedButton(
                                    style: shortButton,
                                    onPressed: () {},
                                    child: Text('SHORT'),
                                  )),
                            )
                          ]),
                          Column(children: [
                            SizedBox(
                              width: 125,
                              height: 50,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: ElevatedButton(
                                    style: mintButton,
                                    onPressed: () {},
                                    child: Text('MINT'),
                                  )),
                            )
                          ]),
                          Column(children: [
                            SizedBox(
                              width: 125,
                              height: 50,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: ElevatedButton(
                                    style: redeemButton,
                                    onPressed: () {},
                                    child: Text('REDEEM'),
                                  )),
                            )
                          ])
                        ],
                      ),
                    )
                  ]),
              Row(children: [Container(width: 600, height: 100)])
            ])
          ]),
        )
      )
    );
  }





  Widget getBasePage(Widget _children) {
    return Stack(
      children: <Widget>[
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
        ),
      ]
    );
  }
}
