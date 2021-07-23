import 'package:ae_dapp/service/Controller.dart';
import 'package:bip39/bip39.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/pages/NavigationBar.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

class KeyGeneration extends StatefulWidget {
  const KeyGeneration({Key? key}) : super(key: key);

  @override
  _KeyGenerationState createState() => _KeyGenerationState();
}

class _KeyGenerationState extends State<KeyGeneration> {

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
                "Your New Key",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: lgTxSize,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                )
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                // child: generateKeyTxt(),
                child: FutureBuilder<Column>(
                  future: generateKeyTxt(),
                  builder: (context, AsyncSnapshot<Column> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else {
                      return Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 100, bottom: 50),
                            child: Text(
                              "Your key is being generated",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              )
                            )
                          ),
                          TextButton(onPressed: () {setState(() {});}, child: Text("Click here to refresh for key"))
                        ],
                      );
                    }
                  }
                )
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<Column> generateKeyTxt() async {

    var contractLink = Provider.of<Controller>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(top: 80, bottom: 20),
          child: Text(
            "Your new Mnemonic is:",
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
            )
          )
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width*.75,
          height: MediaQuery.of(context).size.height*.1,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10)
          ),
          alignment: Alignment.center,
          child: SelectableText(
            await contractLink.getMnemonic(),
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.amber[400],
            )
          )
        ),
        Container(
          padding: EdgeInsets.only(top: 20, bottom: 50),
          child: Text(
            "Keep this key and save it for your future use",
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
            )
          )
        ),
        Container(
          padding: EdgeInsets.only(top: 20, bottom: 50),
          child: Text(
            "DO NOT LOSE THIS",
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
            )
          )
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 250, height: 55),
            child: ElevatedButton(
            child: Text(
              "START TRADING",
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.amber[400],
              )
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => NavigationBar()),
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
    );
  }
}