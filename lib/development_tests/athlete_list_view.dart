import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MyHomePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.8,
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // APT Title & Sport Filter
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('APT List'),
                    const Text('|'),
                    TextButton(
                      onPressed: () {},
                      child: const Text('ALL'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('NFL'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('NBA'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('MMA'),
                    ),
                  ],
                ),
              ),
              // List Headers
              Row(
                children: <Widget>[
                  Container(width: 50),
                  const SizedBox(
                    width: 175,
                    child: Text(
                      'Athlete',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 125,
                    child: Text(
                      'Team',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 150,
                    child: Text(
                      'Market Price / Change',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 150,
                    child: Text(
                      'Book Value / Change',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              // ListView of Athletes
              createAthleteCards('Tom Brady')
            ],
          ),
        ),
      ),
    );
  }

  // Athlete Cards
  Widget createAthleteCards(String athName) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: () {},
        child: Row(
          children: <Widget>[
            // Icon
            SizedBox(
              width: 50,
              child: Icon(Icons.sports_football, color: Colors.grey[700]),
            ),
            // Athlete Name
            SizedBox(
              width: 175,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    athName,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    'Quarterback',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
            ),
            // Team
            SizedBox(
              width: 125,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tampa Bay',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Buckaneers',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
            ),
            // Market Price
            SizedBox(
              width: 150,
              child: Row(
                children: const <Widget>[
                  Text(
                    r'$0.0422',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    '+%4',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  )
                ],
              ),
            ),
            // Book Price
            SizedBox(
              width: 150,
              child: Row(
                children: const <Widget>[
                  Text(
                    r'$0.0412',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    '-%2',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  )
                ],
              ),
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
                child: const Text(
                  'Buy',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            Container(width: 25),
            // Mint
            Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Mint',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
