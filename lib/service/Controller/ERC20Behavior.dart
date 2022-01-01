import 'package:ax_dapp/contracts/ERC20.g.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:web3dart/web3dart.dart';

mixin ERC20Behavior on Token {
  var balance = BigInt.zero;
  var maxTokens = 0.0;
  late ERC20 erc20;
  Future<void> updateBalance() async {
    print("updated balance: ${controller.publicAddress.value}");
    balance = await erc20.balanceOf(controller.publicAddress.value);
    update();
  }

  void updateERC20([String? newAddress]) {
    updateAddress(newAddress!);
    EthereumAddress ethAddress = EthereumAddress.fromHex(address.value);
    erc20 = ERC20(address: ethAddress, client: controller.client.value);
    update();
  }

  Future<String> approve(EthereumAddress dest, double amount) {
    // Both need to happen for any transaction
    BigInt amountToApprove = BigInt.from(amount);
    return erc20.approve(dest, amountToApprove,
        credentials: controller.credentials);
  }
}
