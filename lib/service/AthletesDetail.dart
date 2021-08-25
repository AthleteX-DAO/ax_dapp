import 'package:flutter/material.dart';

class AthleteDetail extends StatefulWidget {
  AthleteDetail({Key? key}) : super(key: key);

  @override
  _AthleteDetailState createState() => _AthleteDetailState();
}

class _AthleteDetailState extends State<AthleteDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Row(
            children: [
              Text("Chart Goes Here"),
              Column(
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                          onPressed: () {
                            print("Adding to your tokens");
                          },
                          icon: Icon(Icons.call_made_outlined),
                          label: const Text("Long")),
                      TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.call_received_outlined),
                          label: const Text("SHORT"))
                    ],
                  )
                ],
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ),
    );
  }
}
