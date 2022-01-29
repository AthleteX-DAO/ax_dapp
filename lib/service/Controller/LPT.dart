import 'package:ax_dapp/service/Controller/FarmBehavior.dart';
import 'package:ax_dapp/service/Controller/Token.dart';

// Liquidity Pool Token
class LPT extends Token with FarmBehavior {
  LPT(String name, String ticker) : super(name, ticker);
}
