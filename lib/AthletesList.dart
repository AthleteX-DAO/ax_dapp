import 'package:flutter/material.dart';
import 'package:ae_dapp/Athlete.dart';
import 'dart:convert';

class AthletesList extends StatefulWidget {
  @override
  _allAthletesListState createState() => _allAthletesListState();
}

class _allAthletesListState extends State<AthletesList> {
  List<Athlete> _allAthletesList = <Athlete>[]; //All athletes
  List<Athlete> _allAthletes = <Athlete>[];
  List<Athlete> _athletesSearchableList = <Athlete>[];
  List<Athlete> returnableListData = <Athlete>[];

  final TextEditingController _filter = new TextEditingController(); //
  Widget _appBarTitle = new Text('Buy an Athlete');
  List filteredNames = <Athlete>[]; // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  final _boughtAthletes = <Athlete>{};
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

    super.initState();
  }

  // HTTP requests for athletes
  Future<List<Athlete>> _loadData() async {
    return fetchAthletes(); // From Athlete class
  }

  void updateFilter(String text) {
    print("updated Text: ${text}");
  }

  void _searchPressed(String title) {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          style: setTextStyle(),
          controller: _filter,
          decoration: new InputDecoration(
              // Probably need to abstract this out later - vx for search
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              prefixIcon: new Icon(
                Icons.search,
                color: Colors.black,
              ),
              hintText: 'Search...',
              hintStyle: setTextStyle()),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(title);
        _filter.clear();
        this._appBarTitle = null;
      }
    });
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

  Widget _buildAthletes(AsyncSnapshot<List<Athlete>> snapshot) {
    _allAthletesList.addAll(snapshot.data);
    _athletesSearchableList.addAll(_allAthletesList);
    List<Athlete> _athleteFilteredList = <Athlete>[];
    return ListView.builder(
      itemCount: snapshot.data.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        if (index.isOdd) return Divider(); /*2*/
        final i = index ~/ 2; // i is every even item in this iteration
        if (_athletesSearchableList[i].name.toLowerCase().contains(_searchText)) {
          _athleteFilteredList.add(_allAthletesList[i]);
        }
        _buildRow(_allAthletesList[i]);
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
            subtitle: Text("Buy: \$" + a.fantasyPoints.toString()),
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
                _searchPressed("Search an Athlete");
              })
        ],
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
