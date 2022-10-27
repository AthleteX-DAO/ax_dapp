import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FailedDialog extends StatelessWidget {
  const FailedDialog({
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
        const wid = 500.0;
        const hgt = 335.0;
        const edge = 40.0;
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: constraints.maxHeight < 340 ? _height : hgt,
            width: constraints.maxWidth < 505 ? _width : wid,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(30),
            ),
            child: isWeb
                ? const WebLayoutView(wid: wid, edge: edge)
                : const MobileLayoutView(wid: wid, edge: edge),
          ),
        );
      },
    );
  }
}

class WebLayoutView extends StatelessWidget {
  const WebLayoutView({
    super.key,
    required this.wid,
    required this.edge,
  });

  final double wid;
  final double edge;

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  const SizedBox(width: 5),
                  const FittedBox(
                    child: Text(
                      'Transaction Rejected',
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
    );
  }
}

class MobileLayoutView extends StatelessWidget {
  const MobileLayoutView({
    super.key,
    required this.wid,
    required this.edge,
  });

  final double wid;
  final double edge;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 275,
        width: wid - edge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: wid - edge,
              child: Container(
                alignment: Alignment.center,
                child: const FittedBox(
                  child: Text(
                    'Transaction Rejected',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 275,
                  height: 50,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      color: Colors.amber[500]!.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: FittedBox(
                        child: Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.amber[500],
                            fontSize: 16,
                            fontFamily: 'OpenSans',
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
    );
  }
}
