import '../service/Controller/Swap/SupportedChain.dart';
import 'package:flutter_web3/flutter_web3.dart' as FlutterWeb3;

class ChainManager {
  static SupportedChain _selectedChain = SupportedChain.MATIC;

  void setSelectedChain(SupportedChain selectedChain) {
    _selectedChain = selectedChain;
    print("[Console] Chain has been set to ${_selectedChain.name}");
  }

  static SupportedChain getSelectedChain() { return _selectedChain; }

  static int _getSelectedChainId() {
    switch(_selectedChain){
      case SupportedChain.MATIC: return 137;
      case SupportedChain.TESTNET_MATIC: return 80001;

      case SupportedChain.SX: return 416;
      case SupportedChain.TESTNET_SX: return 647;
    }
  }

  static SupportedChain? getSupportedChainById(int chainId) {
    switch(chainId){
      case 137: return SupportedChain.MATIC;
      case 80001: return SupportedChain.TESTNET_MATIC;
      case 416: return SupportedChain.SX;
      case 647: return SupportedChain.TESTNET_SX;
      default: return null;
    }
  }

  static String getCurrentChainName(){
    return getChainName(_selectedChain);
  }

  static String getChainName(SupportedChain chain){
    switch(chain){
      case SupportedChain.MATIC: return "Polygon Mainnet";
      case SupportedChain.TESTNET_MATIC: return "Polygon Testnet";

      case SupportedChain.SX: return "SX Mainnet";
      case SupportedChain.TESTNET_SX: return "SX Testnet";
    }
  }

  static FlutterWeb3.CurrencyParams _getChainCurrencyParams() {
    switch(_selectedChain){
      case SupportedChain.MATIC:
      case SupportedChain.TESTNET_MATIC:
        return FlutterWeb3.CurrencyParams(name: 'MATIC Token', symbol: 'MATIC', decimals: 18);
      case SupportedChain.SX:
      case SupportedChain.TESTNET_SX:
        return FlutterWeb3.CurrencyParams(name: 'SX', symbol: 'SX', decimals: 18);
    }
  }

   static String getChainRpcUrl() {
    switch(_selectedChain){
      case SupportedChain.MATIC: return "https://polygon-rpc.com";
      case SupportedChain.TESTNET_MATIC: return "https://matic-mumbai.chainstacklabs.com/";
      case SupportedChain.SX: return "https://rpc.sx.technology";
      case SupportedChain.TESTNET_SX: return "https://rpc.toronto.sx.technology";
    }
  }

   static String _getChainExplorerUrl() {
    switch(_selectedChain){
      case SupportedChain.MATIC: return 'https://polygonscan.com/';
      case SupportedChain.TESTNET_MATIC: return 'https://mumbai.polygonscan.com/';
      case SupportedChain.SX: return "https://explorer.sx.technology";
      case SupportedChain.TESTNET_SX: return "https://explorer.toronto.sx.technology/";
    }
  }

  static Future<void> switchChain() async {
    print("Inside switchChain()");

    try {
      // switching the chain
      await FlutterWeb3.ethereum!.walletSwitchChain(_getSelectedChainId());
      print("[Console] MetaMask switched the chain to ${_selectedChain.name}");
    } catch (err) {
      // adding chain to the metamask
      print("[Console] The ${_selectedChain.name} is not added on the MetaMask");
      await FlutterWeb3.ethereum!.walletAddChain(
          chainId: _getSelectedChainId(),
          chainName: getCurrentChainName(),
          nativeCurrency: _getChainCurrencyParams(),
          rpcUrls: [getChainRpcUrl()],
          blockExplorerUrls: [_getChainExplorerUrl()]);
      print("[Console] Chain has been switched to ${_selectedChain.name}");
    }
  }

}
