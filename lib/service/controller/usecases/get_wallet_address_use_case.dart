import 'package:ax_dapp/service/controller/controller.dart';

/// This WalletController usecase encapsulates functions for returning
/// the total balance for AX or any other given token address
class GetWalletAddressUseCase {
  GetWalletAddressUseCase(this.controller);

  final Controller controller;

  String? getWalletAddress() {
    if (controller.walletConnected) {
      return controller.publicAddress.value.toString();
    }
    return null;
  }
}
