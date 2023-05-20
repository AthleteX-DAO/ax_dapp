import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CreateLeagueProgressIndicator extends StatelessWidget {
  const CreateLeagueProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final textSize = _width <= 768 ? 12.0 : 16.0;
    return Container(
      decoration: boxDecoration(
        Colors.grey[900]!,
        30,
        0,
        Colors.black,
      ),
      width: _width <= 768 ? _width * 0.25 : _width * 0.2,
      height: 50,
      child: FittedBox(
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Creating League',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: textSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Loader(),
            ],
          ),
        ),
      ),
    );
  }
}
