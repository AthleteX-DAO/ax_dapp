import 'package:ax_dapp/service/controller/farm_behavior.dart';
import 'package:ax_dapp/service/controller/token.dart';

// Liquidity Pool Token
class LPT extends Token with FarmBehavior {
  LPT(super.name, super.ticker, super.address);
}
