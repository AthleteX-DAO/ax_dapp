import 'package:flutter/material.dart';
import 'package:ae_dapp/Athlete.dart';
import 'dart:convert';

class AthletesList extends StatefulWidget {
  @override
  _AthletesListState createState() => _AthletesListState();
}

class _AthletesListState extends State<AthletesList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _loadData() async {
    fetchAthletes();
  }

//   Widget _buildAthletes() {
//                       return ListView.builder(
//                     itemCount: snapshot.data.length,
//                     padding: EdgeInsets.all(8),
//                     itemBuilder: (context, index) {

//                       );
//                     },
//                   );
//   }

//   Widget _buildRow(Athlete a) {
// return Card(
//         color: Colors.blueAccent,
//         child: Column(
//           children: <Widget>[
//             ListTile(
//               leading: Icon(
//                 Icons.sports_baseball_rounded,
//                 color: Colors.yellow[760],
//               ),
//               title: Text(a.name),
//               subtitle: Text(
//                   a.playerID.toString()),
//               trailing: Icon(
//                 Icons.check_circle,
//                 color: Colors.greenAccent,
//               ),
//             )
//           ],
//         ),
//       );
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: _loadData,
          child: Center(
            child: FutureBuilder<List<Athlete>>(
              future: fetchAthletes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    padding: EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.blueAccent,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.sports_baseball_rounded,
                                color: Colors.yellow[760],
                              ),
                              title: Text(snapshot.data[index].name),
                              subtitle: Text(
                                  snapshot.data[index].playerID.toString()),
                              trailing: Icon(
                                Icons.check_circle,
                                color: Colors.greenAccent,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Snapshot has an error! ${snapshot.error}");
                }

                return CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                );
              },
            ),
          )),
    );
  }
}
