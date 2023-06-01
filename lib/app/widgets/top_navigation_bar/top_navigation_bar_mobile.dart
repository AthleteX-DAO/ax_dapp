import 'package:ax_dapp/service/widgets_mobile/dropdown_menu.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TopNavigationBarMobile extends StatelessWidget {
  const TopNavigationBarMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Image.asset('assets/images/x.png'),
            iconSize: 40,
            onPressed: () {
              const urlString = 'https://www.athletex.io/';
              launchUrl(Uri.parse(urlString));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              WalletView(),
              DropdownMenuMobile(),
            ],
          ),
        ],
      ),
    );
  }
}
