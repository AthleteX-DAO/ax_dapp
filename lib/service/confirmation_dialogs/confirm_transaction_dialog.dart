import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConfirmTransactionDialog extends StatelessWidget {
  const ConfirmTransactionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var isWeb = true;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    return LayoutBuilder(
      builder: (context, constraints) {
        final _height = constraints.maxHeight;
        final _width = constraints.maxWidth;
        const width = 500.0;
        const height = 335.0;
        const edge = 40.0;
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: constraints.maxHeight < 340 ? _height : height,
            width: constraints.maxWidth < 505 ? _width : width,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: SizedBox(
                height: 275,
                width: width - edge,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width - edge,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 5),
                          const FittedBox(
                            child: Text(
                              'Transaction Confirmed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'OpenSans',
                              ),
                            ),
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
                        SizedBox(
                          width: 275,
                          height: 50,
                          child: DecoratedBox(
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
                              child: FittedBox(
                                child: Text(
                                  'View on Polygonscan',
                                  style: isWeb
                                      ? textStyle(
                                          Colors.black,
                                          16,
                                          isBold: false,
                                          isUline: false,
                                        )
                                      : textStyle(
                                          Colors.amber[500]!,
                                          16,
                                          isBold: false,
                                          isUline: false,
                                        ),
                                ),
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
      },
    );
  }
}
