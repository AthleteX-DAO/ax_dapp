import 'package:ax_dapp/service/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletMatic extends StatelessWidget {
  const WalletMatic({super.key, required this.controller});

  final Controller controller;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: controller.getCurrentGas,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Icon(
            Icons.local_gas_station,
            color: Colors.grey,
          ),
          Obx(
            () => Text(
              '${controller.gasString} gwei',
              style: TextStyle(
                color: Colors.grey[400],
                fontFamily: 'OpenSans',
                fontSize: 11,
              ),
            ),
          )
        ],
      ),
    );
  }
}
