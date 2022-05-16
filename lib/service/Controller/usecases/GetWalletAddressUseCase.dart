import 'package:ax_dapp/service/Controller/Controller.dart';

/// This WalletController usecase encapsulates functions for returning
/// the total balance for AX or any other given token address
class GetWalletAddressUseCase {
  final Controller controller;

  GetWalletAddressUseCase(this.controller);

  String? getWalletAddress() {
    if (controller.walletConnected) {
      return controller.publicAddress.value.toString();
    } 
    return null;
  }
}
