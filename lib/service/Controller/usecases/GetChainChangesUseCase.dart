import 'dart:async';

import 'package:ax_dapp/util/CurrentChain.dart';
import 'package:ax_dapp/util/EthereumChainWrapper.dart';

class GetChainChangesUseCase {
  final EthereumWebChainWrapper ethereumChain;
  final StreamController _streamController = StreamController<CurrentChain>();
  Stream get stream {
    return _streamController.stream.asBroadcastStream();
  }

  GetChainChangesUseCase(this.ethereumChain) {
    subscribeToChainChanged();
  }

  void subscribeToChainChanged() {
    ethereumChain.onChainChanged((chainId) {
      addCurrentChainToStream(chainId);
    });
  }

  void printChainChanged(chainId) {
    print("GetChainChangesUseCase: current chain id is: $chainId");
  }

  void addCurrentChainToStream(int chainId) {
    switch (chainId) {
      case (137):
        {
          _streamController.add(CurrentChain.POLYGON);
        }
        break;
      case (416):
        {
          _streamController.add(CurrentChain.SX);
        }
        break;
      default:
        {
          _streamController.add(CurrentChain.UNSUPPORTED_CHAIN);
        }
    }
  }
}
