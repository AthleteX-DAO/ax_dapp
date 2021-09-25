import 'dart:html';
import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/pages/ScoutPage.dart';
import 'package:ae_dapp/pages/DexPage.dart';
import 'package:ae_dapp/pages/HelpPage.dart';
import 'package:ae_dapp/style/Style.dart';
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
          toolbarHeight: 70,
          leading: 
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Image(
                image: AssetImage('../assets/images/x.png'),
                width: 60,
              ),
            ),
          actions: [
            TextButton(child: Text('SCOUT',
              style: toolbarButton), 
              onPressed: () {
              _selectedIndex = 0;
              _onItemTapped(_selectedIndex);
              },),
            TextButton(child: Text('DEX',
              style: toolbarButton), 
              onPressed: () {
              _selectedIndex = 1;
              _onItemTapped(_selectedIndex);
              },),
            TextButton(child: Text('FAQ',
              style: toolbarButton),
              onPressed: () {
              _selectedIndex = 2;
              _onItemTapped(_selectedIndex);
              },),
          ],
          backgroundColor: Colors.black,
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
          // Scout page
          if (_selectedIndex == 0) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          '../assets/images/axBackground.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    children: [Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: Image(
                            image: AssetImage('../assets/images/x.png'),
                            height: 40
                          ),
                        )
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                            child: ElevatedButton(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text('Connect Wallet',
                                  style: connectWalletMobile),
                                ),
                              style: connectWallet,
                              onPressed: () {},
                            )
                          ),
                        )
                      ],)
                    )
                  ]),
                )
              )
            );
          } 
          // Dex page
          else if (_selectedIndex == 1) {
           return Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          '../assets/images/axBackground.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    children: [Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: Image(
                            image: AssetImage('../assets/images/x.png'),
                            height: 40
                          ),
                        )
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                            child: ElevatedButton(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text('Connect Wallet',
                                  style: connectWalletMobile),
                                ),
                              style: connectWallet,
                              onPressed: () {},
                            )
                          ),
                        )
                      ],)
                    )
                  ]),
                )
              )
            );
          } 
          // Help page
          else {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          '../assets/images/axBackground.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    children: [Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: Image(
                            image: AssetImage('../assets/images/x.png'),
                            height: 40
                          ),
                        )
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                            child: ElevatedButton(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text('Connect Wallet',
                                  style: connectWalletMobile),
                                ),
                              style: connectWallet,
                              onPressed: () {},
                            )
                          ),
                        )
                      ],)
                    )
                  ]),
                )
              )
            );
          }  
        }
        // Return desktop pages here
        else {
          if (_selectedIndex == 0) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          '../assets/images/axBackground.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(children: [
                    
                  ],
                  ),
                )
              )
            );
          } else if (_selectedIndex == 1) {
           return Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          '../assets/images/axBackground.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(children: [
                    
                  ],
                  ),
                )
              )
            );
          } else {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          '../assets/images/axBackground.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(children: [
                    
                  ],
                  ),
                )
              )
            );
          }  
        }
      }
    ));
  }
}