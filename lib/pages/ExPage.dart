import 'package:ae_dapp/service/AllAthletesList.dart';
import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/style/Style.dart';

import 'package:flutter/material.dart';

class ExPage extends StatefulWidget {
  const ExPage({Key? key}) : super(key: key);

  @override
  _ExPageState createState() => _ExPageState();
}

class _ExPageState extends State<ExPage> {

  bool athleteFlag = false;

  late final ValueNotifier<Athlete> rightAthlete;
  // ignore: non_constant_identifier_names
  List<Athlete> _AllAthletesList = <Athlete>[]; //All athletes
  Future<dynamic>? _loadData;
  // Athlete? rightAthlete;
  final TextEditingController _filter = new TextEditingController(); //
  String _searchText = "";
  

  @override
  void initState() {
    // TODO: implement initState
    //
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          updateFilter(_searchText);
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          updateFilter(_searchText);
        });
      }
    });
    _loadData = _loadAthletes();
    super.initState();
  }

  void updateFilter(String text) {
    print("updated Text: $text");
  }

  Future<dynamic> _loadAthletes() async {
    return await fetchAthletes();
  }



  // **********************************************************
  // Build Left Side (Athlete List)
  // **********************************************************


  Widget _buildRow(Athlete _athlete) {
    return Card(
      color: Colors.grey[900],
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
            child: ListTile(
              title: Text(_athlete.name ?? "",
                  textAlign: TextAlign.left, style: athleteListText),
              trailing: Text(_athlete.getPriceString(), style: TextStyle(fontSize: 20)),
              onTap: () {
                athleteFlag = true;
                rightAthlete.value = _athlete;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAthletes(AsyncSnapshot<dynamic> snapshot) {
    _AllAthletesList.addAll(snapshot.data!);

    return ListView.builder(
      itemCount: 20,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        if (index.isOdd) return Divider(); /*2*/
        final i = index ~/ 2; // i is every even item in this iteration
        return _buildRow(_AllAthletesList[i]);
      },
    );
  }

  Widget buildList() {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text("Athlete Tokens",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ))),
        SizedBox(
          width: 250,
          height: 50,
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(250, 60)),
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  fillColor: Colors.grey[800],
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: (Colors.grey[900])!,
                      width: 3.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: (Colors.grey[900])!,
                      width: 3.0,
                    ),
                  ),
                  border: UnderlineInputBorder(),
                  hintText: 'Search for an Athlete',
                  hintStyle: TextStyle(
                    fontSize: 15,
                  )),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .45,
          width: MediaQuery.of(context).size.width / 2 - 350,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius:
                  BorderRadius.all(const Radius.circular(10.0)),
            ),
            // child: AllAthletesList(),
            child: FutureBuilder<dynamic>(
              future: _loadData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                      onRefresh: () {
                        return _loadData = fetchAthletes();
                      },
                      child: Center(
                        child: _buildAthletes(snapshot),
                      ));
                } else if (snapshot.hasError) {
                  return Text(
                    "Something went wrong! make sure you're connected to the internet",
                  );
                }
                return Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey[500],
                    ),
                    height: 50,
                    width: 50,
                  ),
                );
              },
            ),
          )
        ),
      ],
    );
  }


  // **********************************************************
  // Build Right Side (Athlete Stats)
  // **********************************************************

  Widget buildRight() {
    if (!athleteFlag){
      return Container(
        padding: EdgeInsets.all(100),
        child: Image(
          image: AssetImage("assets/images/x.png")
        )
      );
    }
    else
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // athlete header and name
        Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: SizedBox(
                  width: 600,
                  height: 60,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(children: [
                          Container(
                              color: Colors.grey[900],
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Icon(
                                  Icons.sports_baseball_rounded,
                                  size: 40,
                                  color: Colors.yellow[760],
                                ),
                              )),
                        ]),
                        ValueListenableBuilder<Athlete>(
                          valueListenable: rightAthlete,
                          builder: (BuildContext context, Athlete _ath, Widget? w)
                          {
                            return Column(
                              children: [
                                Container(
                                  color: Colors.grey[900],
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(15, 5, 50, 0),
                                    child: Text(
                                      _ath.name!,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w400
                                      ),
                                    )
                                  )
                                ),
                              ],
                            );
                          },
                        ),
                        ValueListenableBuilder<Athlete>(
                          valueListenable: rightAthlete,
                          builder: (BuildContext context, Athlete _ath, Widget? w)
                          {
                            return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  color: Colors.grey[900],
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                                    child: Text(
                                      _ath.getPriceString(),
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )),
                            ]);
                          }
                        ),
                        Column(children: [
                          Container(
                              color: Colors.grey[900],
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                  child: Text(
                                    '+1.02%',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w400),
                                  ))),
                        ])
                      ])),
            )),
        Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SizedBox(width: 600, height: 75, child: Row(children: [])),
            )),

        // insert athlete graph here
        Align(
            child: SizedBox(
          width: 600,
          height: 200,
        )),

        Align(
          alignment: Alignment.center,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 600,
                    height: 75,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              color: Colors.grey[900],
                              child: ElevatedButton(
                                style: longButton,
                                child: Text('LONG'),
                                onPressed: () {},
                              )),
                          Container(
                              color: Colors.grey[900],
                              child: ElevatedButton(
                                style: shortButton,
                                child: Text('SHORT'),
                                onPressed: () {},
                              )),
                          Container(
                              color: Colors.grey[900],
                              child: ElevatedButton(
                                style: mintButton,
                                child: Text('MINT'),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _mintAPT(context),
                                  );
                                },
                              )),
                          Container(
                              color: Colors.grey[900],
                              child: ElevatedButton(
                                style: redeemButton,
                                child: Text('REDEEM'),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _redeemAX(context),
                                  );
                                },
                              ))
                        ]))
              ]),
        ),
        Align(
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: SizedBox(
                          width: 300,
                          height: 75,
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tight(Size(250, 60)),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey[800],
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: (Colors.amber[600])!,
                                      width: 3.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: (Colors.grey[900])!,
                                      width: 3.0,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(),
                                  hintText:
                                      'Enter the amount of APT to long/short',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                  )),
                            ),
                          ),
                        )),
                  ]),
                  Column(
                    children: [
                      SizedBox(
                          width: 300,
                          height: 40,
                          child: Text(
                            '**Mint: Supply AX and receive APT-LSP (Athlete Performance Token Long/Short Pair)**',
                            style: mintAndRedeemText,
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                          width: 300,
                          height: 40,
                          child: Text(
                              '**Redeem: Supply APT-LSP (Athlete Performace Token Long/Short Pair and receive AX**',
                              style: mintAndRedeemText,
                              textAlign: TextAlign.center))
                    ],
                  )
                ])),
        // Align(
        //   alignment: Alignment.center,
        //   child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         // SizedBox(
        //         //   width: 300,
        //         //   height: 75,
        //         //   child: Container(),
        //         // ),
        //         SizedBox(
        //             width: 600,
        //             height: 75,
        //             child: Row(
        //                 mainAxisAlignment:
        //                     MainAxisAlignment.spaceAround,
        //                 crossAxisAlignment:
        //                     CrossAxisAlignment.center,
        //                 children: [
        //                   Container(
        //                       color: Colors.grey[900],
        //                       child: ElevatedButton(
        //                         style: mintButton,
        //                         child: Text('MINT'),
        //                         onPressed: () {},
        //                       )),
        //                   Container(
        //                       color: Colors.grey[900],
        //                       child: ElevatedButton(
        //                         style: redeemButton,
        //                         child: Text('REDEEM'),
        //                         onPressed: () {},
        //                       ))
        //                 ]))
        //       ]),
        // ),
      ],
    );
  }

  //////////////////////////////////
    
  Widget _mintAPT(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text('Confirm Swap', textAlign: TextAlign.left, style: confirmText),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //FROM
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text('From', style: confirmText)],
                ),
                Column(
                  children: [Text('~\$1,300.00', style: confirmText)],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text('ETH', style: confirmTextCoin)],
                ),
                Column(
                  children: [Text('10.0702', style: confirmTextCoin)],
                )
              ],
            ),
          ),
          //DOWN ARROW
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [Icon(Icons.arrow_downward, size: 15)],
                )
              ],
            ),
          ),
          //TO
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text('To', style: confirmText)],
                ),
                Row(children: [
                  Column(children: [Text('~\$1,290.00', style: confirmText)]),
                  Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Column(children: [
                        Text('(0.079%)', style: confirmTextPercent)
                      ]))
                ])
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'AX',
                      style: confirmTextCoin,
                    )
                  ],
                ),
                Column(
                  children: [Text('9.1000', style: confirmTextCoin)],
                )
              ],
            ),
          ),
          //PRICE
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Price',
                      style: confirmText,
                    )
                  ],
                ),
                Column(
                  children: [
                    Text('1 AX = .00589 ETH', style: confirmTextOtherBold)
                  ],
                )
              ],
            ),
          ),
          //OTHER INFO
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Liquidity Provider Fee',
                      style: confirmTextOther,
                    )
                  ],
                ),
                Column(
                  children: [Text('0.000824 ETH', style: confirmTextOtherBold)],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Price Impact',
                      style: confirmTextOther,
                    )
                  ],
                ),
                Column(
                  children: [Text('-0.03%', style: confirmTextOtherBold)],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Maximum sent',
                      style: confirmTextOther,
                    )
                  ],
                ),
                Column(
                  children: [Text('0.289529 ETH', style: confirmTextOtherBold)],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Slippage tolerance',
                      style: confirmTextOther,
                    )
                  ],
                ),
                Column(
                  children: [Text('0.05%', style: confirmTextOtherBold)],
                )
              ],
            ),
          ),
          //CONFIRMATION BUTTON
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {},
                    style: confirmSwap,
                    child: Text('Cofirm Swap'))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _redeemAX(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text('Confirm Swap', textAlign: TextAlign.left, style: confirmText),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //FROM
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text('From', style: confirmText)],
                ),
                Column(
                  children: [Text('~\$1,300.00', style: confirmText)],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text('ETH', style: confirmTextCoin)],
                ),
                Column(
                  children: [Text('10.0702', style: confirmTextCoin)],
                )
              ],
            ),
          ),
          //DOWN ARROW
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [Icon(Icons.arrow_downward, size: 15)],
                )
              ],
            ),
          ),
          //TO
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text('To', style: confirmText)],
                ),
                Row(children: [
                  Column(children: [Text('~\$1,290.00', style: confirmText)]),
                  Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Column(children: [
                        Text('(0.079%)', style: confirmTextPercent)
                      ]))
                ])
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'AX',
                      style: confirmTextCoin,
                    )
                  ],
                ),
                Column(
                  children: [Text('9.1000', style: confirmTextCoin)],
                )
              ],
            ),
          ),
          //PRICE
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Price',
                      style: confirmText,
                    )
                  ],
                ),
                Column(
                  children: [
                    Text('1 AX = .00589 ETH', style: confirmTextOtherBold)
                  ],
                )
              ],
            ),
          ),
          //OTHER INFO
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Liquidity Provider Fee',
                      style: confirmTextOther,
                    )
                  ],
                ),
                Column(
                  children: [Text('0.000824 ETH', style: confirmTextOtherBold)],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Price Impact',
                      style: confirmTextOther,
                    )
                  ],
                ),
                Column(
                  children: [Text('-0.03%', style: confirmTextOtherBold)],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Maximum sent',
                      style: confirmTextOther,
                    )
                  ],
                ),
                Column(
                  children: [Text('0.289529 ETH', style: confirmTextOtherBold)],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Slippage tolerance',
                      style: confirmTextOther,
                    )
                  ],
                ),
                Column(
                  children: [Text('0.05%', style: confirmTextOtherBold)],
                )
              ],
            ),
          ),
          //CONFIRMATION BUTTON
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {},
                    style: confirmSwap,
                    child: Text('Confirm Swap'))
              ],
            ),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////
    
  final ButtonStyle longButton = ElevatedButton.styleFrom(
      textStyle: TextStyle(
          fontSize: 12, fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
      primary: Colors.green,
      onPrimary: Colors.white,
      fixedSize: Size(100, 50));

  final ButtonStyle shortButton = ElevatedButton.styleFrom(
      textStyle: TextStyle(
          fontSize: 12, fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
      primary: Colors.red,
      onPrimary: Colors.white,
      fixedSize: Size(100, 50));

  final ButtonStyle mintButton = ElevatedButton.styleFrom(
      textStyle: TextStyle(
          fontSize: 12, fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
      primary: Colors.red,
      onPrimary: Colors.white,
      fixedSize: Size(100, 50));

  final ButtonStyle redeemButton = ElevatedButton.styleFrom(
      textStyle: TextStyle(
          fontSize: 12, fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
      primary: Colors.red,
      onPrimary: Colors.white,
      fixedSize: Size(100, 50));



  // **********************************************************
  // Build main
  // **********************************************************


  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: const Color(0xff7c94b6),
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(.9), BlendMode.darken),
                image: AssetImage("assets/images/background.jpeg"),
              ),
            ),
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
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("EXPLORE",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: lgTxSize,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  )
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 250,
                height: MediaQuery.of(context).size.height * .675,
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[900],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    buildList(),
                    buildRight()
                  ]
                ),
              )
            ]
          )
        ]
      )
    );
  }
}