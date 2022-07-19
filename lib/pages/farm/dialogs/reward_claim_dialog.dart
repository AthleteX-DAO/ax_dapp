import 'package:ax_dapp/pages/farm/modules/box_decoration.dart';
import 'package:ax_dapp/pages/farm/modules/dialog_text_style.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:flutter/material.dart';

// dynamic
Dialog rewardClaimDialog(BuildContext context) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  final wid = _width < 505.0 ? _width : 500.0;
  final hgt = _height < 340.0 ? _height : 335.0;
  const edge = 40;

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
                      'Rewards Claimed',
                      style: textStyle(Colors.white, 20, false),
                    ),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                    decoration: BoxDecoration(
                      color: Colors.amber[400],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Controller.viewTx();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'View on Polygonscan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
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
