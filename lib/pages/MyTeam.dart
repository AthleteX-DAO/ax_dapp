import 'package:ae_dapp/pages/AthletesList.dart';
import 'package:ae_dapp/pages/Portfolio.dart';
import 'package:ae_dapp/service/Athlete.dart';
import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';

class MyTeam extends StatefulWidget {
  MyTeam({Key? key}) : super(key: key);

  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  static List<Athlete> _AllAthletesList = [
  ];

  Widget _buildOwnedAthletesList(List<Athlete>? _futureAthletes) {
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
            trailing: Icon(Icons.check_circle_outline),
            onTap: () {

            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Container headerBottomBarWidget() {
      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.arrow_downward,
            //   color: Colors.white,
            // ),
            // Text("Swipe down to buy athletes")
          ],
        ),
      );
    }

    Container headerWidget(BuildContext context) => Container(
          child: Center(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Portfolio()
                  //       new Sparkline(data: data,
                  // lineWidth: 10.0,
                  // fillMode: FillMode.below,
                  // fillColor: Colors.amber[700],
                  // pointsMode: PointsMode.all,
                  // pointSize: 3.0,
                  // pointColor: Colors.black)
                ],
              ),
            ),
          ),
        );

    ListView listView() {
      return ListView.builder(
        padding: EdgeInsets.only(top: 0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 2,
        shrinkWrap: true,
        itemBuilder: (context, index) => Card(
          color: Colors.white70,
          child: ListTile(
            leading: CircleAvatar(
              child: Text("$index"),
            ),
            title: Text("Athlete"),
            subtitle: Text("Player"),
          ),
        ),
      );
    }

    return DraggableHome(
      leading: Icon(Icons.arrow_back),
      title: Text("My Team"),
      headerWidget: headerWidget(context),
      headerBottomBar: headerBottomBarWidget(),
      body: [
        Row(
          children: [
            Text(
              "Your Athletes",
              style: TextStyle(
                  color: Colors.amber[400], fontWeight: FontWeight.bold),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        listView()
      ],
      fullyStretchable: true,
      expandedBody: AthletesList(),
    );
  }
}
