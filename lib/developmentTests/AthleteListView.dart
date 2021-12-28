import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height*0.75,
          width: MediaQuery.of(context).size.width*0.8,
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // APT Title & Sport Filter
              Container(
                width: MediaQuery.of(context).size.width*0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("APT List"),
                    Text("|"),
                    Container(
                      child: TextButton(
                        onPressed: () {},
                        child: Text("ALL"),
                      )
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {},
                        child: Text("NFL"),
                      )
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {},
                        child: Text("NBA"),
                      )
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {},
                        child: Text("MMA"), 
                      )
                    ),        
                  ]
                ),
              ),
              // List Headers
              Row(
                children: <Widget>[
                  Container(
                    width: 50
                  ),
                  Container(
                    width: 175,
                    child: Text(
                      "Athlete",
                      style: TextStyle(
                        fontSize: 12,
                      )
                    )
                  ),
                  Container(
                    width: 125,
                    child: Text(
                      "Team",
                      style: TextStyle(
                        fontSize: 12,
                      )
                    )
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      "Market Price / Change",
                      style: TextStyle(
                        fontSize: 12,
                      )
                    )
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      "Book Value / Change",
                      style: TextStyle(
                        fontSize: 12,
                      )
                    )
                  ),
                ]
              ),
              // ListView of Athletes
              createAthleteCards("Tom Brady")
            ]
          )
        )
      )
    );
  }
  
  
  // Athlete Cards
  Widget createAthleteCards(String athName) {
    return Container(
//       color: Colors.grey[100],
      height: 50,
      child: OutlinedButton(
        onPressed: () {},
        child: Row(
          children: <Widget>[
            // Icon
            Container(
              width: 50,
              child: Icon(
                Icons.sports_football,
                color: Colors.grey[700]
              )
            ),
            // Athlete Name
            Container(
              width: 175,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    athName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                    )
                  ),
                  Text(
                    "Quarterback",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[700]
                    )
                  )
                ]
              )
            ),
            // Team
            Container(
              width: 125,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Tampa Bay",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700]
                    )
                  ),
                  Text(
                    "Buckaneers",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[700]
                    )
                  )
                ]
              )
            ),
            // Market Price
            Container(
              width: 150,
              child: Row(
                children: <Widget>[
                  Text(
                    "\$0.0422",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    )
                  ),
                  Text(
                    "+%4",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green
                    )
                  )
                ]
              )
            ),
            // Book Price
            Container(
              width: 150,
              child: Row(
                children: <Widget>[
                  Text(
                    "\$0.0412",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    )
                  ),
                  Text(
                    "-%2",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red
                    )
                  )
                ]
              )
            ),
            // Buy
            Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.amber[400],
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Buy",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black
                  )
                )
              )
            ),
            Container(
              width: 25
            ),
            // Mint
            Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Mint",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}
