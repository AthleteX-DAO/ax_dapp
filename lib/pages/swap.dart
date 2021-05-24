import 'package:flutter/material.dart';
  
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swap',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
  
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
  
class _MyHomePageState extends State<MyHomePage> {
  
  final int _buf = 2;
  final int _blocks = 2;
  final int _textBox = 4;
  final int _col2 = 3;
  final int _button = 1;
  String selectedValue = 'ETH';
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Swap"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: _buf,
            child: Container(
            ),
          ),
          
          // First Box
          Expanded(
            flex: _blocks,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: _textBox,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15,0,5,0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter an amount',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                      ),
                    ),
                    Expanded(
                      flex: _col2,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0,5,0,0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Balance: 0.000000')
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0,0,5,5),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Switch Button
          Expanded(
            flex: _button,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10,15,10,15),
              child: Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child: ElevatedButton(
                  child: Text(
                    '/\\  \\/',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          
          //Second Box
          Expanded(
            flex: _blocks,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: _textBox,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15,30,0,0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Conversion:',
                                  style: TextStyle(fontSize: 12, color: Colors.white,),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15,0,5,0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '0.123456789AFBCEF00',
                                  style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white,),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                      ),
                    ),
                    Expanded(
                      flex: _col2,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0,5,0,0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Balance: 0.000000')
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0,0,5,5),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Exchange Button
          Expanded(
            flex: _button,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10,20,10,0),
              child: Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child: RaisedButton(
                  color: Colors.green,
                  child: Text(
                    'Exchange',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Expanded(
            flex: _buf,
            child: Container(
            ),
          ),
        ],
      ),
    );
  }
}