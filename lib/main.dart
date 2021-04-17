import 'package:ae_dapp/MyAthletes.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/contract_linking.dart';
import 'package:ae_dapp/wallet.dart';
import 'package:ae_dapp/AthletesList.dart';
import 'package:ae_dapp/NavigationBar.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Returns anything!

    return ChangeNotifierProvider<ContractLinking>(
        create: (_) => ContractLinking(),
        child: MaterialApp(
          title: "Athlete Equity",
          debugShowCheckedModeBanner: false,
          initialRoute: "/",
          theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.yellow[700],
              accentColor: Colors.black),
          routes: {
            '/': (context) => NavigationBar(),
            '/wallet': (context) => Wallet(),
            '/athletes': (context) => AthletesList(),
            '/my-athletes': (context) => MyAthletes()
          },
        ));
  }
}
