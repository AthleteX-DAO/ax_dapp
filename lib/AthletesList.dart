import 'package:flutter/material.dart';
import 'package:ae_dapp/Athlete.dart';
import 'dart:convert';

class AthletesList extends StatefulWidget {
  @override
  _AthletesListState createState() => _AthletesListState();
}

class _AthletesListState extends State<AthletesList> {
  final _athletesList = <Athlete>[]; //All athletes
  final TextEditingController _filter = new TextEditingController(); // 
  Widget _appBarTitle = new Text( 'Buy an Athlete' );
  String _searchQuery = "";
  List filteredNames = <Athlete>[]; // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search); 
  final _boughtAthletes = <Athlete>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // HTTP requests for athletes
  Future<List<Athlete>> _loadData() async {
    return fetchAthletes(); // From Athlete class
  }

  void _searchPressed() {
  setState(() {
    if (this._searchIcon.icon == Icons.search) {
      this._searchIcon = new Icon(Icons.close);
      this._appBarTitle = new TextField(
        controller: _filter,
        decoration: new InputDecoration(
          suffixIcon: new Icon(Icons.search),
          hintText: 'Search...',
        ),
      );
    } else {
      this._searchIcon = new Icon(Icons.search);
      this._appBarTitle = new Text('Search Example');
      filteredNames = _athletesList;
      _filter.clear();
    }
  });
}

  Widget _buildAthletes(AsyncSnapshot<List<Athlete>> snapshot) {
    for (int i = 0; i < snapshot.data.length; i++)

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
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: RefreshIndicator(
          onRefresh: _loadData,
          child: Center(
            child: FutureBuilder<List<Athlete>>(
              future: _loadData(),
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
