import 'package:ax_dapp/service/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../service/custom_styles.dart';

class DesktopLeague extends StatelessWidget {
  const DesktopLeague({super.key});

  @override
  Widget build(BuildContext context) {
    final global = Global();
    return global.buildPage(
      context,
      const Center(
        child: LeagueDialog(),
      ),
    );
  }
}

class LeagueDialog extends StatelessWidget {
  const LeagueDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    var wid = 400.0;
    if (_width < 565) wid = _width;

    var hgt = 400.0;
    if (_height < 505) hgt = _height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.amber[400]!),
      ),
      child: TextButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //edit this to add to popup
                  SizedBox(
                    width: wid,
                    height: hgt,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create League',
                          style: textStyle(
                            Colors.white,
                            20,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Text('Name: '),
                  const SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter League Name',
                      ),
                    ),
                  ),
                  const Text('Start-Date: '),
                  const SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Start-Date',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        child: const Text(
          'League PopUp',
          style: TextStyle(
            color: Colors.amber,
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
