import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';



class MyTeam extends StatefulWidget {
  MyTeam({Key? key}) : super(key: key);

  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {

  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Team"),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: Text("Your portfolio history"),
            ),
            new Expanded(
              flex: 3,
              child: Container(
                child: new Sparkline(
                  data: data,
                  lineWidth: 10.0,
                  fillMode: FillMode.below,
                  fillColor: Colors.amber[700],
                  pointsMode: PointsMode.all,
                  pointColor: Colors.red[400],
                ),
              ),
            ),
            new Expanded(
              flex: 3,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
