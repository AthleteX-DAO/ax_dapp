import 'package:ae_dapp/style/Style.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Athlete.dart';

var md2TxSize = 20;

class AllAthletesList extends StatefulWidget {
  @override
  _AllAthletesListState createState() => _AllAthletesListState();
}

class _AllAthletesListState extends State<AllAthletesList> {
  List<Athlete> _AllAthletesList = <Athlete>[]; //All athletes
  List<Athlete> returnableListData = <Athlete>[];

  final TextEditingController _filter = new TextEditingController(); //
  Widget _appBarTitle = new Text('My Team');
  List filteredNames = <Athlete>[]; // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  final _boughtAthletes = <Athlete>{};
  Future<dynamic>? _loadData;
  String _searchText = "";

  @override
  void initState() {
    // TODO: implement initState
    //
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          updateFilter(_searchText);
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          updateFilter(_searchText);
        });
      }
    });
    _loadData = _loadAthletes();
    super.initState();
  }

  void updateFilter(String text) {
    print("updated Text: $text");
  }

  Future<dynamic> _loadAthletes() async {
    return await fetchAthletes();
  }

  setTextStyle() {
    return TextStyle(color: Colors.blueGrey);
  }

  searchFilter(int i) {
    //     if (_athletesSearchableList[i]
    //     .name
    //     .toLowerCase()
    //     .contains(_searchText.toLowerCase())) {
    //   _athleteFilteredList.add(_athletesSearchableList[i]);
    // }
  }

  Widget _buildAthletes(AsyncSnapshot<dynamic> snapshot) {
    _AllAthletesList.addAll(snapshot.data!);

    return ListView.builder(
<<<<<<< HEAD
      itemCount: 20,
      padding: EdgeInsets.all(0),
=======
      itemCount: 9,
      padding: EdgeInsets.all(16.0),
>>>>>>> 6e55e5b9440c6ebf3c996ba8995f4a491060bf93
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
      color: Colors.grey[900],
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
            child: ListTile(
              leading: Icon(
                Icons.sports_baseball_rounded,
                color: Colors.yellow[760],
              ),
              title: Text(a.name ?? "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      letterSpacing: 1,
                      color: Colors.amber[600],
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              trailing: Text("\$3.1893", style: TextStyle(fontSize: 20)),
              onTap: () {},
            ),
<<<<<<< HEAD
=======
            title: Text(a.name ?? "",
                style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.amber[600],
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
            trailing: Text("\$0.0148",
                style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
            onTap: () {},
>>>>>>> 6e55e5b9440c6ebf3c996ba8995f4a491060bf93
          )
        ],
      ),
    );
  }

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
}
