import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ae_dapp/pages/NavigationBar.dart';
import 'package:ae_dapp/pages/KeyGenerationPage.dart';

class EnterKeyPage extends StatefulWidget {
  const EnterKeyPage({Key? key}) : super(key: key);

  @override
  _EnterKeyPageState createState() => _EnterKeyPageState();
}

class _EnterKeyPageState extends State<EnterKeyPage> {

  final textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

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
                  controller: textController,
                  onSubmitted: (String _mnemonic) async {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        bool isValid = bip39.validateMnemonic(_mnemonic);
                        if (isValid) {
                          return NavigationBar();
                        }
                        else {
                          return AlertDialog(
                            title: const Text('Not a valid key'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        }
                      },
                    );
                  },
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 60),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 250, height: 55),
                    child: ElevatedButton(
                    child: Text(
                      "ENTER KEY",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          bool isValid = bip39.validateMnemonic(textController.text);
                          if (isValid) {
                            return NavigationBar();
                          }
                          else {
                            return AlertDialog(
                              title: const Text('Not a valid key'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          }
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.amber[400]!),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.amber[400]!),
                        )
                      )
                    ),
                  )
                )
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 250, height: 55),
                  child: ElevatedButton(
                  child: Text(
                    "CREATE AX WALLET",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => KeyGenerationPage()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.amber[400]!),
                      )
                    )
                  ),
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}