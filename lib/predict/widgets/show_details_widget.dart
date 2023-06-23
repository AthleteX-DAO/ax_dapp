import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class ShowDetailsWidget extends StatefulWidget {
  const ShowDetailsWidget({
    super.key,
    required this.promptDetails,
  });

  final String promptDetails;

  @override
  State<ShowDetailsWidget> createState() => _ShowDetailsWidgetState();
}

class _ShowDetailsWidgetState extends State<ShowDetailsWidget> {
  List<bool> isSelected = [false];

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var wid = _width * 0.4;
    if (_width < 1160) wid = _width * 0.95;

    return SizedBox(
      width: wid,
      height: _height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.promptDetails,
                  textAlign: TextAlign.center,
                  style: textStyle(
                    Colors.white,
                    20,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
