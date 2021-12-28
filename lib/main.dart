import 'package:ax_dapp/pages/LandingPage.dart';
import 'package:ax_dapp/pages/V1App.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Controller.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Returns anything!

    return MaterialApp(
      title: "AthleteX",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.yellow[700],
          accentColor: Colors.black),
          home: LandingPage(),
      // home: V1App(),
      // home: HomePage()
    );
  }
}
