import 'package:ax_dapp/pages/farm/modules/box_decoration.dart';
import 'package:ax_dapp/pages/farm/modules/dialog_text_style.dart';
import 'package:flutter/material.dart';
class FailedDialog extends StatelessWidget {
  const FailedDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              children: <Widget>[
                SizedBox(
                  width: wid - edge,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(width: 5),
                      Text(
                        'Transaction Rejected',
                        style: textStyle(Colors.white, 20, false),
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
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 150,
                      color: Colors.amber[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
