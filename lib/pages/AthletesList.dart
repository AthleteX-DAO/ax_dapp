import 'package:ae_dapp/pages/AthletesDetail.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Athlete.dart';

class AthletesList extends StatefulWidget {
  @override
  _AllAthletesListState createState() => _AllAthletesListState();
}

class _AllAthletesListState extends State<AthletesList> {
  List<Athlete> _AllAthletesList = <Athlete>[]; //All athletes
  List<Athlete> returnableListData = <Athlete>[];

  final TextEditingController _filter = new TextEditingController(); //
  Widget _appBarTitle = new Text('My Team');
  List filteredNames = <Athlete>[]; // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  final _boughtAthletes = <Athlete>{};
  List<Athlete>? __athletesDataEntity;
  String _searchText = "";

  @override
  void initState() {
    // TODO: implement initState
    //

    initList(); //sets up synchronous array of athletes from async pull
    super.initState();
  }

  initList() async {
    __athletesDataEntity = await _loadAthletes();
  }

  Future<List<Athlete>> _loadAthletes() async {
    return await fetchAthletes();
  }

  setTextStyle() {
    return TextStyle(color: Colors.blueGrey);
  }

  Widget _buildAthletesList(List<Athlete>? _futureAthletes) {
    _AllAthletesList.addAll(_futureAthletes as List<Athlete>);

    return ListView.builder(
      itemCount: _AllAthletesList.length,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        if (index.isOdd) return Divider(); /*2*/
        final i = index ~/ 2; // i is every even item in this iteration
        return _buildRow(_AllAthletesList[i]);
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
            title: Text(a.name ?? ""),
            subtitle: Text("Buy: ${a.warValue}"),
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
        title: _appBarTitle == null ? Text("Buy an Athlete") : _appBarTitle,
        elevation: 2,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: _searchIcon,
              onPressed: () {
                //              _searchPressed("Search an Athlete");
              })
        ],
      ),
      body: _buildAthletesList(__athletesDataEntity),
    );
  }
}
