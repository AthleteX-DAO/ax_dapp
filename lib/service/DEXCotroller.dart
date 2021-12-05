import 'package:ae_dapp/contracts/Dex.g.dart';
import 'package:ae_dapp/service/Controller.dart';
import '../contracts/Dex.g.dart';
import '../contracts/APTRouter.g.dart';
import 'package:web3dart/web3dart.dart';

class DEXController extends Controller {
  final EthereumAddress dexAddress =
      EthereumAddress.fromHex("0x778EF52b9c18dBCbc6B4A8a58B424eA6cEa5a551");
  final EthereumAddress routerAddress = EthereumAddress.fromHex("0x7EFc361e568d0038cfB200dF9d9Be27943e19017");
  late Dex _dex = Dex(address: dexAddress, client: client);
  late APTRouter _aptRouter = APTRouter(address: routerAddress, client: client);

  Future<void> swap() async {
    
  }

  Future<void> route() async {
    _aptRouter.WAVAX();
  }

  Future<void> createPair() asyc {
    _dex.createPair(tokenA, tokenB, credentials: credentials);
  }
}
