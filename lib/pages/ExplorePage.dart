import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/service/AthleteApi.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // name variable to store future list item name on tap
  late String name;

  // reset the name for the state when list item on tap
  @override
  void initState() {
    super.initState();
    name = 'Click an athlete';
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
            width: MediaQuery.of(context).size.width - 250,
            height: MediaQuery.of(context).size.height * .675,
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
                    // header
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text("Athlete Tokens",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ))),
                    // search for an athlete
                    SizedBox(
                      width: 250,
                      height: 50,
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
                          child: FutureBuilder<dynamic>(
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
                              }),
                        )),
                  ],
                ),
                Column(
                  children: [Text(name)],
                )
              ],
            )),
      ]),
    ]));
  }
}
