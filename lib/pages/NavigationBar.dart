import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ae_dapp/pages/TradingBlock.dart';
import 'package:ae_dapp/pages/AXPage.dart';
import 'package:ae_dapp/pages/ScoutPage.dart';

class NavigationBar extends StatefulWidget {
  NavigationBar({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0;
  // This is where the pages are linked to the navigation
  List<Widget> _widgetOptions = <Widget>[
    ScoutPage(),
    TradingBlock(),
    // MyTeam(),
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
      bottomNavigationBar:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: 'SCOUT',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.swap_horizontal_circle_sharp),
                      label: 'DEX',
                    ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.group_sharp),
                    //   label: 'My Team',
                    // ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Vx.hexToColor("#fec901"),
                  unselectedItemColor: Vx.hexToColor("#f8f8ff"),
                  onTap: _onItemTapped,
                  backgroundColor: Colors.black,
                )
              : null,
    );
  }
}
