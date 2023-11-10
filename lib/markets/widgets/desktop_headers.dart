import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class DesktopHeaders extends StatelessWidget {
  const DesktopHeaders({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return SizedBox(
      child: OutlinedButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (_) => BorderSide.none,
          ),
          mouseCursor: MaterialStateProperty.resolveWith<MouseCursor>(
            (_) => MouseCursor.defer,
          ),
        ),
        onPressed: () => {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FittedBox(
              child: SizedBox(
                width: _width * 0.13,
                child: const Text(
                  'Athlete (Seasonal APT)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ),
            if (_width >= 875)
              FittedBox(
                child: SizedBox(
                  width: _width * 0.1,
                  child: Text(
                    'Team',
                    style: textStyle(
                      Colors.grey[400]!,
                      12,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ),
              ),
            FittedBox(
              child: SizedBox(
                width: _width * 0.2,
                child: Text(
                  'Market Price / Change',
                  style: textStyle(
                    Colors.grey[400]!,
                    10,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              ),
            ),
            FittedBox(
              child: SizedBox(
                width: _width * 0.2,
                child: Text(
                  'Book Value / Change',
                  style: textStyle(
                    Colors.grey[400]!,
                    10,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
