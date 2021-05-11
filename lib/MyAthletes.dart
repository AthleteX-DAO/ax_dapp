//To be Implemented -- keep track of bets

import 'package:ae_dapp/Athlete.dart';
import 'package:flutter/material.dart';

class MyAthletes extends StatefulWidget {
  MyAthletes({Key key}) : super(key: key);

  @override
  _MyAthletesState createState() => _MyAthletesState();
}

class _MyAthletesState extends State<MyAthletes> {

  List<Athlete> _MyAthletes = List.generate(
      20,
      (index) => Athlete(
            name: "A",
            fantasyPoints: (11.4 * index),
            playerID: index * 1000, walks: ''
          ));

  @override
  Widget build(BuildContext context) {
    // final Athlete boughtAthlete = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Athletes"),
        actions: [],
      ),
      body: ReorderableListView.builder(
          itemCount: _MyAthletes.length,
          itemBuilder: (context, index) {
            final Athlete productName = _MyAthletes[index];
            return Card(
              key: ValueKey(productName),
              color: Colors.amberAccent,
              elevation: 1,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                contentPadding: EdgeInsets.all(25),
                title: Text(
                  productName.name,
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {/* Do something else */},
              ),
            );
          },
          // The reorder function
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex = newIndex - 1;
              }
              final element = _MyAthletes.removeAt(oldIndex);
              _MyAthletes.insert(newIndex, element);
            });
          }),
    );
  }
}
