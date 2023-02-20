import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/widgets/ax_information_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UnownedAPTs extends StatelessWidget {
  const UnownedAPTs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var wid = 400.0;
    const edge = 40.0;
    if (_width < 405) wid = _width;
    var hgt = 500.0;
    if (_height < 505) hgt = _height;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: hgt,
        width: wid,
        decoration: boxDecoration(
          Colors.grey[900]!,
          30,
          0,
          Colors.black,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  'My First League Draft',
                  textAlign: TextAlign.center,
                  style: textStyle(
                    Colors.yellow,
                    24,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              ),
              Container(
                height: 250,
                alignment: Alignment.center,
                child: Text(
                  ' To complete registration for\n\n My First League\n\n'
                  ' Please proceed to draft your team\n\n'
                  ' Choose from APTs already owned or\n\n',
                  textAlign: TextAlign.center,
                  style: textStyle(
                    Colors.white,
                    20,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                width: wid,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      height: 30,
                      decoration: boxDecoration(
                        Colors.amber[600]!,
                        100,
                        0,
                        Colors.amber[600]!,
                      ),
                      child: TextButton(
                        onPressed: () {
                          launchUrl(
                            Uri.parse('https://stage.athletex.io/#/scout/'),
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Go Buy APTs',
                          style: textStyle(
                            Colors.black,
                            14,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                height: 30,
                decoration: boxDecoration(
                  Colors.transparent,
                  100,
                  0,
                  Colors.amber[600]!,
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'OK',
                    style: textStyle(
                      Colors.amber,
                      14,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
