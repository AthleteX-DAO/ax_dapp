import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../V1App.dart';

class DeviceAuthentication extends StatefulWidget {
  @override
  _DeviceAuthenticationState createState() => _DeviceAuthenticationState();
}

class _DeviceAuthenticationState extends State<DeviceAuthentication> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Color primaryWhiteColor = Color.fromRGBO(255, 255, 255, 1);
  Color primaryOrangeColor = Color.fromRGBO(254, 197, 0, 1);
  Color secondaryGreyColor = Color.fromRGBO(56, 56, 56, 1);
  Color greyTextColor = Color.fromRGBO(160, 160, 160, 1);
  Color secondaryOrangeColor = Color.fromRGBO(254, 197, 0, 0.2);

  @override
  void initState() {
    super.initState();
    if (_authorized == 'Authorized') {
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => V1App()));
      });
    }
  }

  Future<void> _authenticate(BuildContext context) async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      if (authenticated) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => V1App()));
      }
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      if (authenticated) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => V1App()));
      }
    });
  }

  Future<void> _cancelAuthentication() async {
    setState(() {
      _isAuthenticating = false;
      auth.stopAuthentication();
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/axBackground.jpeg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 30),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      width: _width,
                      height: _height * 0.1,
                      child: Stack(
                        children: [
                          Positioned(
                              left: 20,
                              bottom: 0,
                              height: 40,
                              width: 40,
                              child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ))),
                          Positioned(
                              right: _width * .25,
                              bottom: 0,
                              height: 40,
                              width: _width * .5,
                              child: Container(
                                alignment: Alignment.center,
                                child: Center(
                                  child: Text(
                                    'Current State: $_authorized\n',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    if (_isAuthenticating)
                      Container(
                        decoration: boxDecoration(
                            Colors.grey[300]!.withOpacity(0.15),
                            20,
                            1,
                            Colors.transparent),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                          onPressed: _cancelAuthentication,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              Text('Cancel Authentication',
                                  style: TextStyle(color: Colors.white)),
                              Icon(Icons.cancel),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        children: <Widget>[
                          Container(
                            height: 40,
                            decoration: boxDecoration(secondaryOrangeColor, 10,
                                1, Colors.transparent),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Authenticate',
                                    style: TextStyle(
                                      color: primaryOrangeColor,
                                    ),
                                  ),
                                  Icon(
                                    Icons.perm_device_information,
                                    color: primaryOrangeColor,
                                  ),
                                ],
                              ),
                              onPressed: () => _authenticate(context),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 40,
                            decoration: boxDecoration(
                                Colors.grey[300]!.withOpacity(0.15),
                                10,
                                1,
                                Colors.transparent),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    _isAuthenticating
                                        ? 'Cancel'
                                        : 'Authenticate: biometrics only',
                                    style: TextStyle(color: primaryWhiteColor),
                                  ),
                                  Icon(
                                    Icons.fingerprint,
                                    color: primaryWhiteColor,
                                  ),
                                ],
                              ),
                              onPressed: _authenticateWithBiometrics,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration boxDecoration(
      Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: secondaryGreyColor, width: borWid));
  }
}
