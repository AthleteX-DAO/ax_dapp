import 'dart:html';
import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/pages/ScoutPage.dart';
import 'package:ae_dapp/pages/DexPage.dart';
import 'package:ae_dapp/pages/HelpPage.dart';
import 'package:webfeed/domain/media/media.dart';

class HomePage extends StatefulWidget{
  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override 
  Widget build(BuildContext context) {
    return Scaffold(

      // NAVIGATION BAR //
      // if desktop, top app bar //
      appBar: (MediaQuery.of(context).size.width <= 768) 
        ? null 
        : AppBar(
          leading: Icon(Icons.menu),
          title: Text('Page title'),
          actions: [
            TextButton(child: Text('SCOUT'), onPressed: () {
              _selectedIndex = 0;
              _onItemTapped(_selectedIndex);
              },),
            TextButton(child: Text('DEX'), onPressed: () {
              _selectedIndex = 1;
              _onItemTapped(_selectedIndex);
              },),
            TextButton(child: Text('FAQ'), onPressed: () {
              _selectedIndex = 2;
              _onItemTapped(_selectedIndex);
              },),
          ],
          backgroundColor: Colors.purple,
        ),
      // if mobile, bottom app bar //
      bottomNavigationBar: (MediaQuery.of(context).size.width < 768) 
        ? BottomNavigationBar(
          selectedFontSize: 15,
          selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 30),
          selectedItemColor: Colors.amberAccent,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: Colors.black,
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'SCOUT',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_calls),
              label: 'DEX',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help),
              label: 'FAQ',
            ),
          ],
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
        ) 
        : null,

      // main body
      body: LayoutBuilder(builder: (context, constraints) {
        // Return mobile pages here
        if (constraints.maxWidth<768){
          
          if (_selectedIndex == 0) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Row(children: [
                    Image(image: AssetImage('../assets/images/x.png'),)
                  ],),
                )
              )
            );
          } else if (_selectedIndex == 1) {
            return Text('');
          } else {
            return Text('');
          }  
        }
        // Return desktop pages here
        else {
          if (_selectedIndex == 0) {
            return Text('');
          } else if (_selectedIndex == 1) {
            return Text('');
          } else {
            return Text('');
          }
        }
      }
    ));
  }
}