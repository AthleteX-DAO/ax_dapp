import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/style/Style.dart';

import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  double lgTxSize = 52;
  double headerTx = 30;

  List<Athlete> _AllAthletesList = <Athlete>[]; //All athletes
  final _boughtAthletes = <Athlete>{};
  Future<dynamic>? _loadData;

  Widget _buildRow(Athlete a) {
    final alreadyBought = _boughtAthletes.contains(a);

    return Card(
      color: Colors.grey[900],
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
            child: ListTile(
              title: Text(a.name ?? "",
                  textAlign: TextAlign.left, style: athleteListText),
              trailing: Text("\$3.1893", style: TextStyle(fontSize: 20)),
              onTap: () {},
            ),
          )
        ],
      ),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.all(const Radius.circular(10.0)),
      ),
      child: FutureBuilder<dynamic>(
        future: _loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
                onRefresh: () {
                  return _loadData = fetchAthletes();
                },
                child: Center(
                  child: _buildAthletes(snapshot),
                ));
          } else if (snapshot.hasError) {
            return Text(
              "Something went wrong! make sure you're connected to the internet",
            );
          }
          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey[500],
              ),
              height: 50,
              width: 50,
            ),
          );
        },
      ),
    );
  }
*/

  Widget _buildAthletes(AsyncSnapshot<dynamic> snapshot) {
    _AllAthletesList.addAll(snapshot.data!);

    return ListView.builder(
      itemCount: 20,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        if (index.isOdd) return Divider(); /*2*/
        final i = index ~/ 2; // i is every even item in this iteration
        return _buildRow(_AllAthletesList[i]);
      },
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
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text("Athlete Tokens",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ))),
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
                            future: _loadData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return RefreshIndicator(
                                    onRefresh: () {
                                      return _loadData = fetchAthletes();
                                    },
                                    child: Center(
                                      child: _buildAthletes(snapshot),
                                    ));
                              } else if (snapshot.hasError) {
                                return Text(
                                  "Something went wrong! make sure you're connected to the internet",
                                );
                              }
                              return Center(
                                child: SizedBox(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.grey[500],
                                  ),
                                  height: 50,
                                  width: 50,
                                ),
                              );
                            },
                          ),
                        )),
                  ],
                ),

                // Add athlete half
              ],
            )),
      ]),
    ]));
  }
}

/*
Explore Page
My Team
Generate Key
*/

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
