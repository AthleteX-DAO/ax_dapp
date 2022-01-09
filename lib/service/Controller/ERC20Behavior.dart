import 'package:ax_dapp/contracts/ERC20.g.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:web3dart/web3dart.dart';

mixin ERC20Behavior on Token {

  late ERC20 erc20;
  Future<void> updateBalance() async {
    final account = controller.publicAddress.value;
    balance.value = await erc20.balanceOf(account);
    totalSupply.value = await erc20.totalSupply();
    print("updated balance: ${balance.value}");
    update();
  }

  void updateERC20([String? newAddress]){
    updateAddress(newAddress!);
    EthereumAddress ethAddress = EthereumAddress.fromHex(address.value);
    final client = controller.client.value;
    erc20 = ERC20(address: ethAddress, client: client);
    updateBalance();
    update();
  }

  Future<String> approve(EthereumAddress dest, double amount) {
    // Both need to happen for any transaction
    BigInt amountToApprove = BigInt.from(amount);
    return erc20.approve(dest, amountToApprove,
        credentials: controller.credentials);
  }
}
