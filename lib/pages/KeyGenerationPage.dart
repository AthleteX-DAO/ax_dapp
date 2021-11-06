import 'package:ae_dapp/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Singleton.dart';

class KeyGenerationPage extends StatefulWidget {
  const KeyGenerationPage({Key? key}) : super(key: key);

  @override
  _KeyGenerationPageState createState() => _KeyGenerationPageState();
}

class _KeyGenerationPageState extends State<KeyGenerationPage> {
  Singleton userData = Singleton();

  @override
  Widget build(BuildContext context) {
    Future<String> mnemonic = Singleton().createNewMnemonic();
    // Future<String> mnemonic = Future<String>.delayed(
    //   const Duration(seconds: 5),
    //   () => 'Data Loaded',
    // );

    return FutureBuilder<String>(
      future: mnemonic,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          String mn = "${snapshot.data}";
          return mainBuild(readyChild(mn));
        } else {
          return mainBuild(notReadyChild());
        }
      },
    );
  }

  Widget mainBuild(Widget child) {
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
                  )),
              Text("Your New Key",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: lgTxSize,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  )),
              child,
            ],
          ),
        ],
      ),
    );
  }

  Widget readyChild(String _mnemonic) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.only(top: 80, bottom: 20),
            child: Text("Your new Mnemonic is:",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                ))),
        Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: MediaQuery.of(context).size.width * .75,
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: SelectableText(_mnemonic,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[400],
                ))),
        Container(
            padding: EdgeInsets.only(top: 20, bottom: 50),
            child: Text("Keep this key and save it for your future use",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                ))),
        Container(
            padding: EdgeInsets.only(top: 20, bottom: 50),
            child: Text("DO NOT LOSE THIS",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                ))),
        ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 250, height: 55),
            child: ElevatedButton(
              child: Text("START TRADING",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber[400],
                  )),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.amber[400]!),
                  ))),
            )),
      ],
    );
  }

  Widget notReadyChild() {
    return Column(children: <Widget>[
      SizedBox(
        child: CircularProgressIndicator(),
        width: 60,
        height: 60,
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Awaiting Mnemonic Key...'),
      )
    ]);
  }
}
