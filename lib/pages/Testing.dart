import 'package:ae_dapp/service/NFLAthlete.dart';
import 'package:ae_dapp/service/NFLAthleteApi.dart';
import 'package:flutter/material.dart';


class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  _TestingState createState() => _TestingState();
}


class _TestingState extends State<Testing> {

  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();
  List<NFLAthlete> athleteList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder<dynamic>(
            future: NFLAthleteApi.getAthletesLocally(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                // return circle indicator for progress
                return Center(
                  child: CircularProgressIndicator(),
                );
                default:
                  return ListView.builder(
                    itemCount: athleteList.length,
                    itemBuilder: (context, index) {
                      final athlete = athleteList[index];
                      return Card(
                        color: Colors.grey[900],
                        shadowColor: Colors.grey[900],
                        child: ListTile(
                          title: Text(athlete.name)
                        )
                      );
                    }
                  );
              }
            }
          );
        }
      )
    );
  }
}