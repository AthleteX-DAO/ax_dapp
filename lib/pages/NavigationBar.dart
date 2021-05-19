import 'package:flutter/material.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:ae_dapp/pages/wallet.dart';
import 'package:ae_dapp/pages/AthletesList.dart';

class NavigationBar extends StatefulWidget {
  NavigationBar({Key key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Wallet(),
    // Text(
    //   'Coming Soon!',
    //   style: optionStyle,
    // ), // MyAthletes()
    AthletesList(),
    Text(
      'Coming soon!',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          // BottomNavigationBarItem(  // Move this into same tab as Buy Athletes
          //   icon: Icon(Icons.account_balance_wallet),
          //   label: 'My Athletes',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball),
            label: 'Buy Athletes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horizontal_circle_sharp),
            label: 'Token Swap',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Settings',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Vx.hexToColor("#fec901"),
        unselectedItemColor: Vx.hexToColor("#f8f8ff"),
        onTap: _onItemTapped,
        backgroundColor: Vx.hexToColor("#232b2b"),
      ),
    );
  }
}
