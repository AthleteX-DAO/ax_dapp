import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

class AccountAssetCard extends StatelessWidget {
  const AccountAssetCard({
    super.key,
    required this.token,
  });

  final Token token;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: () {},
        child: Row(
          children: <Widget>[
            Container(
              height: 30,
              width: 60,
              alignment: Alignment.centerLeft,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    scale: 0.5,
                    image: tokenImage(token),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 45,
              // ticker/name column "AX/AthleteX"
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: (_width < 350.0) ? 110 : 125,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      token.ticker,
                      style: textStyle(
                        Colors.white,
                        14,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                  ),
                  Container(
                    width: (_width < 350.0) ? 110 : 125,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      token.name,
                      style: textStyle(
                        Colors.grey[100]!,
                        9,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
