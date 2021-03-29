import 'package:flutter/material.dart';
import 'package:ae_dapp/Athlete.dart';
import 'dart:convert';

class AthletesList extends StatefulWidget {
  @override
  _AthletesListState createState() => _AthletesListState();
}

class _AthletesListState extends State<AthletesList> {
  Future<Athlete> futureAthlete;
  List _allAthletes = [];

  Future<void> _loadData() async {
    futureAthlete = getBaseballAthletes();
    setState(() {
      _allAthletes = futureAthlete as List;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
    futureAthlete = getBaseballAthletes();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: FutureBuilder<Athlete>(
        future: futureAthlete,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(children: [
                      <Widget>[
                        ListTile(
                          leading: CircleAvatar(backgroundColor: ,),
                        )
                      ]
                    ],),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
