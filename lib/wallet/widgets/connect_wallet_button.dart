import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/widgets/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ConnectWalletButton extends StatelessWidget {
  const ConnectWalletButton({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var width = 180.0;
    var text = 'Connect Wallet';
    if (_width < 565) {
      width = 110;
      text = 'Connect';
    }

    return Container(
      height: 37.5,
      width: width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.amber[400]!, width: 2),
      ),
      child: TextButton(
        onPressed: () {
          context.read<TrackingCubit>().onPressedConnectWallet(
                // TODO(Rolly): get address from wallet bloc
                publicAddress: Get.find<Controller>().publicAddress.toString(),
              );
          showDialog<void>(
            context: context,
            builder: (_) => const WalletDialog(),
          );
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.amber[400],
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
