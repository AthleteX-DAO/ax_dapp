import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:ethereum_api/erc20_api.dart';
import 'package:shared/shared.dart' hide ERC20;

class AccountRepository {
  Controller controller = Controller();

  Future<void> transerTokens({
    required String toAddress,
    required String tokenAddress,
    required double inputAmount,
    required int tokenDecimals,
  }) async {
    final to = EthereumAddress.fromHex(toAddress);
    final address = EthereumAddress.fromHex(tokenAddress);
    final tokenAmount = normalizeInput(inputAmount, decimal: tokenDecimals);
    final token = ERC20(address: address, client: controller.client.value);
    var transactionHash = '';
    try {
      transactionHash = await token.transfer(
        to,
        tokenAmount,
        credentials: controller.credentials,
      );
      controller.transactionHash = transactionHash;
    } catch (_) {
      controller.transactionHash = '';
    }
  }
}
