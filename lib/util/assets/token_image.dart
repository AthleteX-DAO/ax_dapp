import 'package:flutter/painting.dart';
import 'package:tokens_repository/tokens_repository.dart';

// TODO(Rolly): gen assets & move to ui package
AssetImage tokenImage(Token token) {
  String tokenAssetName;
  switch (token.currency) {
    case EthereumCurrency.none:
      throw UnsupportedError('token image for ${token.currency}');
    case EthereumCurrency.ax:
      tokenAssetName = 'X_Logo_Black_BR.png';
      break;
    case EthereumCurrency.sx:
      tokenAssetName = 'SX_Small.png';
      break;
    case EthereumCurrency.wsx:
      tokenAssetName = 'WSX_Small.png';
      break;
    case EthereumCurrency.matic:
      tokenAssetName = 'w_matic.png';
      break;
    case EthereumCurrency.weth:
      tokenAssetName = 'weth_small.png';
      break;
    case EthereumCurrency.usdc:
      tokenAssetName = 'USDC_small.png';
      break;
    case EthereumCurrency.apt:
      return aptImage(token as Apt);
  }
  return AssetImage('assets/images/$tokenAssetName');
}

// TODO(Rolly): gen assets & move to ui package
AssetImage aptImage(Apt apt) {
  String tokenAssetName;
  switch (apt.type) {
    case AptType.none:
      throw UnsupportedError('apt image for ${apt.type}');
    case AptType.long:
      tokenAssetName = 'apt_noninverted.png';
      break;
    case AptType.short:
      tokenAssetName = 'apt_inverted.png';
      break;
  }
  return AssetImage('assets/images/$tokenAssetName');
}
