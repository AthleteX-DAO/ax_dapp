import 'package:flutter_web3/flutter_web3.dart' as FlutterWeb3;

class EthereumWebChainWrapper {
  final FlutterWeb3.Ethereum _ethereumChain = FlutterWeb3.ethereum!;

  EthereumWebChainWrapper();

  onChainChanged(void Function(int chainId) listener) {
    _ethereumChain.onChainChanged(listener);
  }
}
