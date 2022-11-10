import 'package:ax_dapp/add_liquidity/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

class YouReceived extends StatelessWidget {
  const YouReceived({
    super.key,
    required this.amountToReceive,
    required this.token0,
    required this.token1,
  });

  final String amountToReceive;
  final Token token0;
  final Token token1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return Container(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
            child: FittedBox(
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You will receive:',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    Text(
                      '$amountToReceive ${token0.ticker}/${token1.ticker} LP Tokens',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Column(
            children: [
              SizedBox(
                height: 25,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'You will receive:',
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      child: const YouReceiveToolTip(),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: Text(
                          amountToReceive,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${token0.ticker}/${token1.ticker}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          const Text(
                            'LP Tokens',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              )
            ],
          );
        }
      },
    );
  }
}
