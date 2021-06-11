import 'package:flutter/material.dart'; 
  
class Swap extends StatelessWidget {
  const Swap({Key? key}) : super(key: key);

  static const String _title = 'Swap';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: SwapWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class SwapWidget extends StatefulWidget {
  const SwapWidget({Key? key}) : super(key: key);

  @override
  State<SwapWidget> createState() => _SwapState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SwapState extends State<SwapWidget> {
  
  final TextEditingController _ctrlRate = TextEditingController();
  final TextEditingController _ctrlBalance1 = TextEditingController();
  final TextEditingController _ctrlBalance2 = TextEditingController();
  final TextEditingController _ctrlConversion = TextEditingController();
  
  
  final int _buf = 1;
  final int _blocks = 2;
  final int _textBox = 4;
  final int _col2 = 3;
  final int _button = 1;
  
  double amount = 0;
  double balance1 = 500;
  double balance2 = 1000;
  double rate = 3.6;
  var rates;

  @override
  void initState() {
    
    rates = [rate, 1/rate];
    
    _ctrlRate.addListener(() {
      setState(() {});
    });
    
    _ctrlBalance1.addListener(() {
      setState(() {});
    });
    
    _ctrlBalance2.addListener(() {
      setState(() {});
    });
    
    _ctrlConversion.addListener(() {
      setState(() {});
    });
    
    updateCtrl();
    super.initState();
  }


  @override
  void dispose() {
    _ctrlRate.dispose();
    _ctrlBalance1.dispose();
    _ctrlBalance2.dispose();
    _ctrlConversion.dispose();
    super.dispose();
  }
  
  void updateCtrl() {
    _ctrlRate.text = rate.toString();
    _ctrlBalance1.text = balance1.toString();
    _ctrlBalance2.text = balance2.toString();
    _ctrlConversion.text = (amount * rate).toString();
  }
  
  
  void changeAmount(String _text) {
    if (!isNumeric(_text))
      print('Please enter a decimal number.');

    else {
      amount = double.parse(_text);
      if (amount > balance1) {
        amount = 0;
        print('You do not have sufficient funds in your balance');
      }
      else
        print('Amount: $amount');
    }
  }

  bool isNumeric(String _text) {
    return double.tryParse(_text) != null;
  }
  
  // Used when entering an amount
  bool getConversion(String _text) {
    _ctrlConversion.text = '0';
    if (!isNumeric(_text) && _text != '')
      return false;
    
    if (_text == '')
      return true;
    
    _ctrlConversion.text = (amount * rate).toString();
    return true;
  }

  // Used when exchange is pressed
  String convert() {
    if (balance1 < amount) {
      return "insufficient funds";
    }
    else {
      balance1 -= amount;
      balance2 += (amount * rate);
      
      updateCtrl();
      return "transaction complete";
    }
  }
  
  // When /\ \/ is presssed
  void switchTokens() {
    double temp = balance2;
    balance2 = balance1;
    balance1 = temp;
    rate == rates[0] ? rate = rates[1] : rate = rates[0];
    updateCtrl();
  }
  
  // Sets the decimal of balance to 8 figures
  String getBalance(String _bal) {
    double temp = double.parse(_bal);
    return temp.toStringAsFixed(8);
  }
  
// -------------------------
  
  /// Components
  
  // Empty Expanded/Container
  Expanded empty(int size) {
    return Expanded(
      flex: size,
      child: Container(),
    );
  }
  
  // Rate
  Expanded rateBox() {
    return Expanded(
      flex: _buf,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          children: <Widget> [
            empty(1),
            new Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Rate: $rate",
                  textAlign: TextAlign.center,
                )
              ),
            ),
            empty(1),
          ]
        )
      )
    );
  }
  
  // Token Dropdown
  Expanded tokenDropdown() {
    return Expanded(
    flex: 3,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0,0,5,5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
        ),
      ),
    );
  }
  
  // First Box
  Expanded token1Box() {
    return Expanded(
      flex: _blocks,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Container(
          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: <Widget>[
              // TextBox
              new Expanded(
                flex: _textBox,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15,0,5,0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter an amount',
                    ),
                    onChanged: (_text) {
                      if (!getConversion(_text))
                        amount = 0;
                      else
                        amount = double.parse(_text);
                      updateCtrl();
                    },
                  ),
                ),
              ),
              empty(1),
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
                          child: Text("Balance: " + getBalance(_ctrlBalance1.text))
                        ),
                      ),
                    ),
                    
                    tokenDropdown(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Switch Button
  Expanded switchButton() {
    return Expanded(
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
            onPressed: () {switchTokens();},
          ),
        ),
      ),
    );
  }
  
  //Second Box
  Expanded token2Box() {
    return Expanded(
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
                            "${_ctrlConversion.text}",
                            style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              empty(1),
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
                          child: Text('Balance: ' + getBalance(_ctrlBalance2.text))
                        ),
                      ),
                    ),

                    tokenDropdown(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Exchange Button
  Expanded exchangeButton() {
    return Expanded(
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
            onPressed: () {convert();},
          ),
        ),
      ),
    );
  }
  
//---------------------
  // Widget
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter layout demo'),
        ),
        body: Column(
        children: <Widget>[
          new Expanded(
            flex: _buf,
            child: Container(
            ),
          ),
          
          rateBox(),
          
          token1Box(),
          
          switchButton(),
          
          token2Box(),
          
          exchangeButton(),
          
          empty(_buf),
        ],
      ),
      ),
    );
  }
}