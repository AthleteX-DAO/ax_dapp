import 'package:flutter/material.dart';
class Swap extends StatefulWidget {
  @override
  _SwapState createState() => _SwapState();
}
  
class _SwapState extends State<Swap> {
  
  final int _buf = 2;
  final int _blocks = 2;
  final int _textBox = 4;
  final int _col2 = 3;
  final int _button = 1;
  String selectedValue = 'ETH';
  double amount = 0;
  double balance1 = 500;
  double balance2 = 1000;
  double rt = 3.6;
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Swap"),
      ),
      body: Column(
        children: <Widget>[
          new Expanded(
            flex: _buf,
            child: Container(
            ),
          ),
          
          // First Box
          new Expanded(
            flex: _blocks,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: <Widget>[
                    new Expanded(
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
                    new Expanded(
                      flex: 1,
                      child: Container(
                      ),
                    ),
                    new Expanded(
                      flex: _col2,
                      child: Column(
                        children: <Widget>[
                          new Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0,5,0,0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Balance: ' + balance1.toString())
                              ),
                            ),
                          ),
                          new Expanded(
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
          new Expanded(
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
          new Expanded(
            flex: _blocks,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      flex: _textBox,
                      child: Column(
                        children: <Widget>[
                          new Expanded(
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
                          new Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15,0,5,0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  convertionRate(rt).toString(),
                                  style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white,),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: Container(
                      ),
                    ),
                    new Expanded(
                      flex: _col2,
                      child: Column(
                        children: <Widget>[
                          new Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0,5,0,0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Balance: ' + balance2.toString())
                              ),
                            ),
                          ),
                          new Expanded(
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
          new Expanded(
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
                  onPressed: () {convert()},
                ),
              ),
            ),
          ),
          new Expanded(
            flex: _buf,
            child: Container(
            ),
          ),
        ],
      ),
    );
  }

  double convertionRate(double _rate) {
    return balance1 * _rate;
  }

  String convert() {
    if (balance1 < amount) {
      return "insufficient funds";
    }
  }
} //_SwapState class end
