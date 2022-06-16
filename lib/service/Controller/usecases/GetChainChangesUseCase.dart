import 'dart:async';

import 'package:ax_dapp/service/Controller/createWallet/web.dart';
import 'package:ax_dapp/util/CurrentChain.dart';
// import 'package:web3_browser/web3_browser.dart';
import 'package:flutter_web3/flutter_web3.dart' as FlutterWeb3;

class GetChainChangesUseCase {
  final WebWallet webWallet;

  FlutterWeb3.Ethereum? ethereum;
  final StreamController _streamController = StreamController<CurrentChain>();
  Stream get stream {
    return _streamController.stream.asBroadcastStream();
  }

  GetChainChangesUseCase({required this.webWallet}) {
    // this.ethereum = this.webWallet.getWindowEthereum();
    this.ethereum = webWallet.getEthereumApiObj();
    subscribeToChainChanged();
  }

  void subscribeToChainChanged() {
    // ethereum!.onChainChanged(printChainChanged);
    ethereum!.onChainChanged((chainId) {
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
