import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConfirmTransactionDialog extends StatelessWidget {
  const ConfirmTransactionDialog({super.key,});

  @override
  Widget build(BuildContext context) {
    var isWeb = true;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var wid = 500.0;
    const edge = 40.0;
    if (_width < 505) wid = _width;
    var hgt = 335.0;
    if (_height < 340) hgt = _height;
      return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Center(
        child: SizedBox(
          height: 275,
          width: wid - edge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: wid - edge,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 5),
                    Text(
                      'Transaction Confirmed',
                      style: textStyle(Colors.white, 20, isBold:false),
                    ),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 150,
                    color: Colors.amber[400],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 275,
                    height: 50,
                    decoration: isWeb
                        ? boxDecoration(
                            Colors.amber[400]!,
                            500,
                            1,
                            Colors.amber[400]!,
                          )
                        : boxDecoration(
                            Colors.amber[500]!.withOpacity(0.20),
                            500,
                            1,
                            Colors.transparent,
                          ),
                    child: TextButton(
                      onPressed: () {
                        Controller.viewTx();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'View on Polygonscan',
                        style: isWeb
                            ? textStyle(Colors.black, 16, isBold:false)
                            : textStyle(Colors.amber[500]!, 16, isBold:false),
                      ),
                    ),
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
}
