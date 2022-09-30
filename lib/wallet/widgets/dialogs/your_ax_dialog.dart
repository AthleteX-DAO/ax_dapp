import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/widgets/ax_information_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class YourAXDialog extends StatelessWidget {
  const YourAXDialog({super.key,});

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var wid = 400.0;
    const edge = 40.0;
    if (_width < 405) wid = _width;
    var hgt = 500.0;
    if (_height < 505) hgt = _height;
      return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 80,
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your AX',
                    style: textStyle(Colors.white, 20, isBold:false),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      context
                          .read<WalletBloc>()
                          .add(const UpdateAxDataRequested());
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            // 'X' logo
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width * (wid - 0.04),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  scale: 2,
                  image: AssetImage('assets/images/x.jpg'),
                ),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              height: 65,
              alignment: Alignment.center,
              child: const AxBalance(
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              width: wid - edge,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Balance:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      AxBalance(
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
            SizedBox(
              width: wid - edge,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AX price:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      const AxPrice(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AX in circulation:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      const AxCirculation(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AX total supply:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      const AxTotalSupply(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 150,
                    height: 30,
                    decoration: boxDecoration(
                      Colors.amber[600]!,
                      100,
                      0,
                      Colors.amber[600]!,
                    ),
                    child: TextButton(
                      onPressed: () {
                        // TODO(KevinKamto): Update this when we need sushiswap
                        // connection
                        // String axEth =
                        //     "https://app.sushi.com/swap?inputCurrency=0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df&outputCurrency=0x7ceb23fd6bc0add59e62ac25578270cff1b9f619";
                        const axEthUniswap =
                            'https://app.uniswap.org/#/swap?chain=polygon';

                        launchUrl(Uri.parse(axEthUniswap));
                      },
                      child: Text(
                        'Buy AX',
                        style: textStyle(Colors.black, 14, isBold:true),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
