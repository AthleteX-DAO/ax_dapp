import 'package:ae_dapp/pages/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Controller.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Returns anything!

    return ChangeNotifierProvider<Controller>(
        create: (_) => Controller(),
        child: MaterialApp(
          title: "AthleteX",
          debugShowCheckedModeBanner: false,
          initialRoute: "/",
          theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.yellow[700],
              accentColor: Colors.black),
          home: LandingPage(),
        ));
  }
}
