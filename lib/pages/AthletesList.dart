import 'package:ae_dapp/pages/AthletesDetail.dart';
import 'package:ae_dapp/service/RSSReader.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Athlete.dart';
import 'package:search_page/search_page.dart';

class AthletesList extends StatefulWidget {
  @override
  _AllAthletesListState createState() => _AllAthletesListState();
}

class _AllAthletesListState extends State<AthletesList> {
  List<Athlete> _AllAthletesList = <Athlete>[]; //All athletes
  List<Athlete> returnableListData = <Athlete>[];
  final _boughtAthletes = <Athlete>{};
  List<Athlete>? _athletesDataEntity;

  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
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
        title: Center( child: Text("Latest Sports News"),),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 3.5,
        backgroundColor: Colors.yellow.shade600,
        tooltip: 'Search an athlete',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<Athlete>(
            onQueryUpdate: (s) => print(s),
            items: _AllAthletesList,
            searchLabel: 'Search athletes',
            suggestion: Center(
              child: Text('Filter athletes by name, position or playerID'),
            ),
            failure: Center(
              child: Text('No athlete found :('),
            ),
            filter: (athlete) => [
              athlete.name,
              athlete.position,
              athlete.playerID.toString(),
            ],
            builder: (athlete) => ListTile(
              title: Text(athlete.name!),
              subtitle: Text(athlete.position!),
              trailing: Text('${athlete.name} yo'),
            ),
          ),
        ),
        child: Icon(Icons.search),
      ),
      body: RSSReader(),
    );
  }
}
