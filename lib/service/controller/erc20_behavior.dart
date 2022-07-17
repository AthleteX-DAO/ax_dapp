import 'package:ax_dapp/service/controller/token.dart';
import 'package:erc20/erc20.dart';
import 'package:web3dart/web3dart.dart';

mixin ERC20Behavior on Token {
  double maxTokens = 0;

  Future<void> updateBalance() async {
    updateERC20();
    balance.value = await erc20.balanceOf(controller.publicAddress.value);
    update();
  }

  void updateERC20([String? newAddress]) {
    var theAddress = '';
    if (newAddress == null || newAddress == '') {
      theAddress = address.value;
    } else {
      theAddress = newAddress;
    }
    updateAddress(theAddress);
    final ethAddress = EthereumAddress.fromHex(theAddress);
    erc20 = ERC20(address: ethAddress, client: controller.client.value);
    update();
  }

  Future<String> approve(EthereumAddress dest, double amount) {
    // Both need to happen for any transaction
    final amountToApprove = BigInt.from(amount);
    return erc20.approve(
      dest,
      amountToApprove,
      credentials: controller.credentials,
    );
  }
}
