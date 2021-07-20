import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ae_dapp/service/RSSReader.dart';
import 'package:intl/intl.dart';
import 'dart:collection';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

class Swap extends StatefulWidget {
  Swap({Key? key}) : super(key: key);

  @override
  _Swap createState() => _Swap();
}

class _Swap extends State<Swap> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.grey[800],
          accentColor: Color.fromRGBO(75, 214, 145, 1.0),
          fontFamily: 'Rockwell'),
      home: new MainPage(
        title: '',
      ),
      navigatorObservers: [routeObserver],
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> with RouteAware {
  var rates = new LinkedHashMap();

  var currentValue = 1;
  var convertedValue = 0.0;

  EdgeInsets _getEdgeInsets() {
    return new EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0);
  }

  MainAxisAlignment _getAxisAlignment() {
    return MainAxisAlignment.spaceBetween;
  }

  void _initPreferences() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // if (!(preferences.getKeys().contains("currencyParam")) && !(preferences.getKeys().contains("toParam"))) {
    //   await preferences.setString("currencyParam", "USD");
    //   await preferences.setString("toParam", "PHP");
    //   print("Successfully Initialized User Defaults");
    // }
    // else {
    //   print("User Defaults Already Instanciated");
    // }
    // setState(() {

    // });
  }

  String _getImageName(String index) {
    return "assets/" + index + ".png";
  }

  String _getDate() {
    DateTime now = new DateTime.now();
    var dateFormatter = new DateFormat('MMMM dd, yyyy');

    return dateFormatter.format(now);
  }

  void _showDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(content),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {}

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/background.jpeg"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(tabs: [
                  Tab(
                    child: Text(
                      "Swap",
                      style: new TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "News",
                      style: new TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ]),
                title: Text(
                  _getDate(),
                  style: new TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                actions: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {});
                    },
                  )
                ],
              ),
              body: TabBarView(
                children: [
                  new Column(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                        child: new Container(
                          color: Colors.transparent,
                          child: new Container(
                            padding: new EdgeInsets.all(12.0),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  new BorderRadius.all(const Radius.circular(10.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                            ),
                            child: new Center(
                              child: new Column(
                                children: <Widget>[
                                  new Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new GestureDetector(
                                        onTap: () {},
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            new Container(
                                              width: 6.0,
                                            ),
                                            new Container(
                                              width: 4.0,
                                            ),
                                            new Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.grey,
                                              size: 14.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Container(
                                    height: 4.0,
                                  ),
                                  new Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Container(
                                        width: 80.0,
                                        height: 0.5,
                                        color: Color.fromARGB(30, 0, 0, 0),
                                      ),
                                      new RawMaterialButton(
                                        onPressed: () {},
                                        child: new Icon(
                                          Icons.swap_vert,
                                          size: 20.0,
                                          color: Colors.white,
                                        ),
                                        shape: new CircleBorder(),
                                        elevation: 4.0,
                                        fillColor: Color.fromRGBO(75, 214, 145, 1.0),
                                        padding: new EdgeInsets.all(8.0),
                                      ),
                                      new Container(
                                        width: 80.0,
                                        height: 0.5,
                                        color: Color.fromARGB(30, 0, 0, 0),
                                      )
                                    ],
                                  ),
                                  new Container(
                                    height: 4.0,
                                  ),
                                  new Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new GestureDetector(
                                        onTap: () {},
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            new Container(
                                              width: 6.0,
                                            ),
                                            new Container(
                                              width: 4.0,
                                            ),
                                            new Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.grey,
                                              size: 13.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Scaffold(
                    appBar: AppBar(
                      title: Center(
                        child: Text("Latest Sports News"),
                      ),
                    ),
                    body: RSSReader(),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
