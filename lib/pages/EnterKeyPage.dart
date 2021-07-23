import 'package:flutter/material.dart';
// import 'package:web3dart/web3dart.dart'; //Reference Library https://pub.dev/packages/web3dart/example
import 'package:bip39/bip39.dart' as bip39;

class EnterKeyPage extends StatefulWidget {
  const EnterKeyPage({Key? key}) : super(key: key);

  @override
  _EnterKeyPageState createState() => _EnterKeyPageState();
}

class _EnterKeyPageState extends State<EnterKeyPage> {

  @override
  // Future<Widget> build(BuildContext context) async {
  Widget build(BuildContext context) {

  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  double lgTxSize = 52;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/background.jpeg"),
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Image(
                    width: 80,
                    height: 80,
                    image: AssetImage("assets/images/x.png"),
                  ),
                )
              ),
              Text(
                "Enter Your Key",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: lgTxSize,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                )
              ),
              Container(
                padding: EdgeInsets.only(top: 50, bottom: 20),
                child: Text(
                  "Enter your mnemonic key then hit return",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                  )
                )
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
                child: TextField(
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onSubmitted: (String _mnemonic) async {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        bool isValid = bip39.validateMnemonic(_mnemonic);
                        return AlertDialog(
                          title: const Text('Thanks!'),
                          content: Text(
                              isValid.toString()),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}