import 'abstractWallet.dart';
import 'package:bip39/bip39.dart'
    as bip39; // Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

DappWallet newWallet() => MobileWallet();

class MobileWallet extends DappWallet {
  var rpcUrl = "https://polygon-rpc.com";

  @override
  Future<void> connect() async {
    String rpcUrl = "";
    String mainRPCUrl = "https://polygon-rpc.com";
    String testRPCUrl = "https://matic-mumbai.chainstacklabs.com/";

    switch (activeChainId) {
      case 137:
        rpcUrl = mainRPCUrl;
        break;
      default:
        rpcUrl = testRPCUrl;
    }

    if (seedHex == null) {
      this.createNewMnemonic();
    }

    this.client = Web3Client(rpcUrl, Client());
    publicAddress = credentials.extractAddress();
    credentials = EthPrivateKey.fromHex(seedHex);
    networkID = client.getNetworkId();
    print("[Console] updated client and credentials at $publicAddress");
  }

  void createNewMnemonic() {
    this.mnemonic = bip39.generateMnemonic();
    this.seedHex = bip39.mnemonicToSeedHex(mnemonic);
  }

// This will import mnemonics & convert to seed hexes
  Future<bool> importMnemonic(String _mnemonic) async {
    // validate if mnemonic
    bool isValidMnemonic = bip39.validateMnemonic(_mnemonic);
    if (isValidMnemonic) {
      this.seedHex = bip39.mnemonicToSeedHex(_mnemonic);
      this.mnemonic = _mnemonic;
    }
    return isValidMnemonic;
  }
}



// This will create mnemonics & convert to seed hexes

