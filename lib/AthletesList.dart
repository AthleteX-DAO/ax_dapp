import 'package:flutter/material.dart';
import 'package:ae_dapp/Athlete.dart';
import 'dart:convert';

class AthletesList extends StatefulWidget {
  @override
  _AthletesListState createState() => _AthletesListState();
}

class _AthletesListState extends State<AthletesList> {
  final _athletesList = <Athlete>[];
  final _boughtAthletes = <Athlete>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _loadData() async {
    fetchAthletes();
  }

  Widget _buildAthletes(AsyncSnapshot<List<Athlete>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        if (index.isOdd) return Divider(); /*2*/

        final i = index ~/ 2; /*3*/
        if (i >= _athletesList.length) {
          _athletesList.addAll(snapshot.data.take(7));
        }

        return _buildRow(_athletesList[i]);
      },
    );
  }

  Widget _buildRow(Athlete a) {
    final alreadyBought = _boughtAthletes.contains(a);

    return Card(
      color: Colors.blueAccent,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.sports_baseball_rounded,
              color: Colors.yellow[760],
            ),
            title: Text(a.name),
            subtitle: Text("Buy: " + a.fantasyPoints.toString() + "ae tokens"),
            trailing: alreadyBought
                ? Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                  )
                : Icon(Icons.check_circle_outline),
            onTap: () {
              setState(() {
                if (alreadyBought) {
                  _boughtAthletes.remove(a);
                } else {
                  _boughtAthletes.add(a);
                }
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy an Athlete"),
        actions: [
          IconButton(icon: Icon(Icons.account_balance_rounded), onPressed: () {})
        ],
      ),
      body: RefreshIndicator(
          onRefresh: _loadData,
          child: Center(
            child: FutureBuilder<List<Athlete>>(
              future: fetchAthletes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildAthletes(snapshot);
                } else if (snapshot.hasError) {
                  return Text(
                      "Something went wrong! make sure you're connected to the internet");
                }

                return CircularProgressIndicator(
                  backgroundColor: Colors.yellowAccent,
                );
              },
            ),
          )),
    );
  }
}
