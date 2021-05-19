import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Athlete.dart';

class AthletesList extends StatefulWidget {
  @override
  _allAthletesListState createState() => _allAthletesListState();
}

class _allAthletesListState extends State<AthletesList> {
  List<Athlete> _allAthletesList = <Athlete>[]; //All athletes
  List<Athlete> returnableListData = <Athlete>[];

  final TextEditingController _filter = new TextEditingController(); //
  Widget _appBarTitle = new Text('Buy an Athlete');
  List filteredNames = <Athlete>[]; // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  final _boughtAthletes = <Athlete>{};
  Future _loadData;
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
    print("updated Text: ${text}");
  }

  Future<List<Athlete>> _loadAthletes() async {
    return await fetchAthletes();
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

  void _AthleteDetails(Athlete aAthlete) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text("About ${aAthlete.name}"),),
          body: Text("Stuff goes here"),
        );
      }),
    );
  }

  Widget _buildAthletes(AsyncSnapshot<List<Athlete>> snapshot) {
    _allAthletesList.addAll(snapshot.data);
    return ListView.builder(
      itemCount: _allAthletesList.length,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        if (index.isOdd) return Divider(); /*2*/
        final i = index ~/ 2; // i is every even item in this iteration
        print('Loaded BuildAthetes');
        return _buildRow(_allAthletesList[i]);
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
            onLongPress: () => {_AthleteDetails(a)},
            subtitle: Text("Buy: ${a.playerID}"),
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
          onRefresh: () {
            return _loadData;
          },
          child: Center(
            child: FutureBuilder<List<Athlete>>(
              future: _loadData,
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
