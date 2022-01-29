import 'package:ax_dapp/contracts/ERC20.g.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';

mixin ERC20Behavior on Token {
  var maxTokens = 0.0;

  Future<void> updateBalance() async {
    updateERC20();
    balance.value = await erc20.balanceOf(controller.publicAddress.value);
    print("updated balance: ${balance.value}");
    update();
  }

  void updateERC20([String? newAddress]) {
    String theAddress = "";
    if (newAddress == null || newAddress == "") {
      theAddress = address.value;
    } else {
      theAddress = newAddress;
    }
    print("token address $theAddress");
    updateAddress(theAddress);
    EthereumAddress ethAddress = EthereumAddress.fromHex(theAddress);
    erc20 = Erc20(address: ethAddress, client: controller.client.value);
    update();
  }

  Future<String> approve(EthereumAddress dest, double amount) {
    // Both need to happen for any transaction
    BigInt amountToApprove = BigInt.from(amount);
    return erc20.approve(dest, amountToApprove,
        credentials: controller.credentials);
  }
}
