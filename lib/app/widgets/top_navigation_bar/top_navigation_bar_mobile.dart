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
            icon: const Image(
              image: AssetImage('assets/images/x.png'),
              width: 35,
              height: 35,
            ),
            iconSize: 40,
            onPressed: () {
              const urlString = 'https://www.athletex.io/';
              launchUrl(Uri.parse(urlString));
            },
          ),
          const Spacer(),
          const WalletTopBar(),
          const DropdownMenuMobile(),
        ],
      ),
    );
  }
}
