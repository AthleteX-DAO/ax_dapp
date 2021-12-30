// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: non_constant_identifier_names

import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"inputs":[{"internalType":"address","name":"_factory","type":"address"},{"internalType":"address","name":"_WAVAX","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"WAVAX","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"tokenA","type":"address"},{"internalType":"address","name":"tokenB","type":"address"},{"internalType":"uint256","name":"amountADesired","type":"uint256"},{"internalType":"uint256","name":"amountBDesired","type":"uint256"},{"internalType":"uint256","name":"amountAMin","type":"uint256"},{"internalType":"uint256","name":"amountBMin","type":"uint256"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"addLiquidity","outputs":[{"internalType":"uint256","name":"amountA","type":"uint256"},{"internalType":"uint256","name":"amountB","type":"uint256"},{"internalType":"uint256","name":"liquidity","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"token","type":"address"},{"internalType":"uint256","name":"amountTokenDesired","type":"uint256"},{"internalType":"uint256","name":"amountTokenMin","type":"uint256"},{"internalType":"uint256","name":"amountAVAXMin","type":"uint256"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"addLiquidityAVAX","outputs":[{"internalType":"uint256","name":"amountToken","type":"uint256"},{"internalType":"uint256","name":"amountAVAX","type":"uint256"},{"internalType":"uint256","name":"liquidity","type":"uint256"}],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"factory","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountOut","type":"uint256"},{"internalType":"uint256","name":"reserveIn","type":"uint256"},{"internalType":"uint256","name":"reserveOut","type":"uint256"}],"name":"getAmountIn","outputs":[{"internalType":"uint256","name":"amountIn","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountIn","type":"uint256"},{"internalType":"uint256","name":"reserveIn","type":"uint256"},{"internalType":"uint256","name":"reserveOut","type":"uint256"}],"name":"getAmountOut","outputs":[{"internalType":"uint256","name":"amountOut","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountOut","type":"uint256"},{"internalType":"address[]","name":"path","type":"address[]"}],"name":"getAmountsIn","outputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountIn","type":"uint256"},{"internalType":"address[]","name":"path","type":"address[]"}],"name":"getAmountsOut","outputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountA","type":"uint256"},{"internalType":"uint256","name":"reserveA","type":"uint256"},{"internalType":"uint256","name":"reserveB","type":"uint256"}],"name":"quote","outputs":[{"internalType":"uint256","name":"amountB","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"address","name":"tokenA","type":"address"},{"internalType":"address","name":"tokenB","type":"address"},{"internalType":"uint256","name":"liquidity","type":"uint256"},{"internalType":"uint256","name":"amountAMin","type":"uint256"},{"internalType":"uint256","name":"amountBMin","type":"uint256"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"removeLiquidity","outputs":[{"internalType":"uint256","name":"amountA","type":"uint256"},{"internalType":"uint256","name":"amountB","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"token","type":"address"},{"internalType":"uint256","name":"liquidity","type":"uint256"},{"internalType":"uint256","name":"amountTokenMin","type":"uint256"},{"internalType":"uint256","name":"amountAVAXMin","type":"uint256"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"removeLiquidityAVAX","outputs":[{"internalType":"uint256","name":"amountToken","type":"uint256"},{"internalType":"uint256","name":"amountAVAX","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"token","type":"address"},{"internalType":"uint256","name":"liquidity","type":"uint256"},{"internalType":"uint256","name":"amountTokenMin","type":"uint256"},{"internalType":"uint256","name":"amountAVAXMin","type":"uint256"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"removeLiquidityAVAXSupportingFeeOnTransferTokens","outputs":[{"internalType":"uint256","name":"amountAVAX","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"token","type":"address"},{"internalType":"uint256","name":"liquidity","type":"uint256"},{"internalType":"uint256","name":"amountTokenMin","type":"uint256"},{"internalType":"uint256","name":"amountAVAXMin","type":"uint256"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"},{"internalType":"bool","name":"approveMax","type":"bool"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"removeLiquidityAVAXWithPermit","outputs":[{"internalType":"uint256","name":"amountToken","type":"uint256"},{"internalType":"uint256","name":"amountAVAX","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"token","type":"address"},{"internalType":"uint256","name":"liquidity","type":"uint256"},{"internalType":"uint256","name":"amountTokenMin","type":"uint256"},{"internalType":"uint256","name":"amountAVAXMin","type":"uint256"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"},{"internalType":"bool","name":"approveMax","type":"bool"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"removeLiquidityAVAXWithPermitSupportingFeeOnTransferTokens","outputs":[{"internalType":"uint256","name":"amountAVAX","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"tokenA","type":"address"},{"internalType":"address","name":"tokenB","type":"address"},{"internalType":"uint256","name":"liquidity","type":"uint256"},{"internalType":"uint256","name":"amountAMin","type":"uint256"},{"internalType":"uint256","name":"amountBMin","type":"uint256"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"},{"internalType":"bool","name":"approveMax","type":"bool"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"removeLiquidityWithPermit","outputs":[{"internalType":"uint256","name":"amountA","type":"uint256"},{"internalType":"uint256","name":"amountB","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountOut","type":"uint256"},{"internalType":"address[]","name":"path","type":"address[]"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"swapAVAXForExactTokens","outputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountOutMin","type":"uint256"},{"internalType":"address[]","name":"path","type":"address[]"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"swapExactAVAXForTokens","outputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountOutMin","type":"uint256"},{"internalType":"address[]","name":"path","type":"address[]"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"swapExactAVAXForTokensSupportingFeeOnTransferTokens","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountIn","type":"uint256"},{"internalType":"uint256","name":"amountOutMin","type":"uint256"},{"internalType":"address[]","name":"path","type":"address[]"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"swapExactTokensForAVAX","outputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountIn","type":"uint256"},{"internalType":"uint256","name":"amountOutMin","type":"uint256"},{"internalType":"address[]","name":"path","type":"address[]"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"swapExactTokensForAVAXSupportingFeeOnTransferTokens","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountIn","type":"uint256"},{"internalType":"uint256","name":"amountOutMin","type":"uint256"},{"internalType":"address[]","name":"path","type":"address[]"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"swapExactTokensForTokens","outputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountIn","type":"uint256"},{"internalType":"uint256","name":"amountOutMin","type":"uint256"},{"internalType":"address[]","name":"path","type":"address[]"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"swapExactTokensForTokensSupportingFeeOnTransferTokens","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountOut","type":"uint256"},{"internalType":"uint256","name":"amountInMax","type":"uint256"},{"internalType":"address[]","name":"path","type":"address[]"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"swapTokensForExactAVAX","outputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountOut","type":"uint256"},{"internalType":"uint256","name":"amountInMax","type":"uint256"},{"internalType":"address[]","name":"path","type":"address[]"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"swapTokensForExactTokens","outputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"stateMutability":"nonpayable","type":"function"},{"stateMutability":"payable","type":"receive"}]',
    'APTRouter');

class APTRouter extends _i1.GeneratedContract {
  APTRouter(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> WAVAX({_i1.BlockNum? atBlock}) async {
    final function = self.function('WAVAX');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> addLiquidity(
      _i1.EthereumAddress tokenA,
      _i1.EthereumAddress tokenB,
      BigInt amountADesired,
      BigInt amountBDesired,
      BigInt amountAMin,
      BigInt amountBMin,
      _i1.EthereumAddress to,
      BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('addLiquidity');
    final params = [
      tokenA,
      tokenB,
      amountADesired,
      amountBDesired,
      amountAMin,
      amountBMin,
      to,
      deadline
    ];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> addLiquidityAVAX(
      _i1.EthereumAddress token,
      BigInt amountTokenDesired,
      BigInt amountTokenMin,
      BigInt amountAVAXMin,
      _i1.EthereumAddress to,
      BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('addLiquidityAVAX');
    final params = [
      token,
      amountTokenDesired,
      amountTokenMin,
      amountAVAXMin,
      to,
      deadline
    ];
    return write(credentials, transaction, function, params);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> factory({_i1.BlockNum? atBlock}) async {
    final function = self.function('factory');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getAmountIn(
      BigInt amountOut, BigInt reserveIn, BigInt reserveOut,
      {_i1.BlockNum? atBlock}) async {
    final function = self.function('getAmountIn');
    final params = [amountOut, reserveIn, reserveOut];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getAmountOut(
      BigInt amountIn, BigInt reserveIn, BigInt reserveOut,
      {_i1.BlockNum? atBlock}) async {
    final function = self.function('getAmountOut');
    final params = [amountIn, reserveIn, reserveOut];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<BigInt>> getAmountsIn(
      BigInt amountOut, List<_i1.EthereumAddress> path,
      {_i1.BlockNum? atBlock}) async {
    final function = self.function('getAmountsIn');
    final params = [amountOut, path];
    final response = await read(function, params, atBlock);
    return (response[0] as List<dynamic>).cast<BigInt>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<BigInt>> getAmountsOut(
      BigInt amountIn, List<_i1.EthereumAddress> path,
      {_i1.BlockNum? atBlock}) async {
    final function = self.function('getAmountsOut');
    final params = [amountIn, path];
    final response = await read(function, params, atBlock);
    return (response[0] as List<dynamic>).cast<BigInt>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> quote(BigInt amountA, BigInt reserveA, BigInt reserveB,
      {_i1.BlockNum? atBlock}) async {
    final function = self.function('quote');
    final params = [amountA, reserveA, reserveB];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> removeLiquidity(
      _i1.EthereumAddress tokenA,
      _i1.EthereumAddress tokenB,
      BigInt liquidity,
      BigInt amountAMin,
      BigInt amountBMin,
      _i1.EthereumAddress to,
      BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('removeLiquidity');
    final params = [
      tokenA,
      tokenB,
      liquidity,
      amountAMin,
      amountBMin,
      to,
      deadline
    ];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> removeLiquidityAVAX(
      _i1.EthereumAddress token,
      BigInt liquidity,
      BigInt amountTokenMin,
      BigInt amountAVAXMin,
      _i1.EthereumAddress to,
      BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('removeLiquidityAVAX');
    final params = [
      token,
      liquidity,
      amountTokenMin,
      amountAVAXMin,
      to,
      deadline
    ];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> removeLiquidityAVAXSupportingFeeOnTransferTokens(
      _i1.EthereumAddress token,
      BigInt liquidity,
      BigInt amountTokenMin,
      BigInt amountAVAXMin,
      _i1.EthereumAddress to,
      BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function =
        self.function('removeLiquidityAVAXSupportingFeeOnTransferTokens');
    final params = [
      token,
      liquidity,
      amountTokenMin,
      amountAVAXMin,
      to,
      deadline
    ];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> removeLiquidityAVAXWithPermit(
      _i1.EthereumAddress token,
      BigInt liquidity,
      BigInt amountTokenMin,
      BigInt amountAVAXMin,
      _i1.EthereumAddress to,
      BigInt deadline,
      bool approveMax,
      BigInt v,
      _i2.Uint8List r,
      _i2.Uint8List s,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('removeLiquidityAVAXWithPermit');
    final params = [
      token,
      liquidity,
      amountTokenMin,
      amountAVAXMin,
      to,
      deadline,
      approveMax,
      v,
      r,
      s
    ];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> removeLiquidityAVAXWithPermitSupportingFeeOnTransferTokens(
      _i1.EthereumAddress token,
      BigInt liquidity,
      BigInt amountTokenMin,
      BigInt amountAVAXMin,
      _i1.EthereumAddress to,
      BigInt deadline,
      bool approveMax,
      BigInt v,
      _i2.Uint8List r,
      _i2.Uint8List s,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self
        .function('removeLiquidityAVAXWithPermitSupportingFeeOnTransferTokens');
    final params = [
      token,
      liquidity,
      amountTokenMin,
      amountAVAXMin,
      to,
      deadline,
      approveMax,
      v,
      r,
      s
    ];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> removeLiquidityWithPermit(
      _i1.EthereumAddress tokenA,
      _i1.EthereumAddress tokenB,
      BigInt liquidity,
      BigInt amountAMin,
      BigInt amountBMin,
      _i1.EthereumAddress to,
      BigInt deadline,
      bool approveMax,
      BigInt v,
      _i2.Uint8List r,
      _i2.Uint8List s,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('removeLiquidityWithPermit');
    final params = [
      tokenA,
      tokenB,
      liquidity,
      amountAMin,
      amountBMin,
      to,
      deadline,
      approveMax,
      v,
      r,
      s
    ];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> swapAVAXForExactTokens(BigInt amountOut,
      List<_i1.EthereumAddress> path, _i1.EthereumAddress to, BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('swapAVAXForExactTokens');
    final params = [amountOut, path, to, deadline];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> swapExactAVAXForTokens(BigInt amountOutMin,
      List<_i1.EthereumAddress> path, _i1.EthereumAddress to, BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('swapExactAVAXForTokens');
    final params = [amountOutMin, path, to, deadline];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> swapExactAVAXForTokensSupportingFeeOnTransferTokens(
      BigInt amountOutMin,
      List<_i1.EthereumAddress> path,
      _i1.EthereumAddress to,
      BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function =
        self.function('swapExactAVAXForTokensSupportingFeeOnTransferTokens');
    final params = [amountOutMin, path, to, deadline];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> swapExactTokensForAVAX(BigInt amountIn, BigInt amountOutMin,
      List<_i1.EthereumAddress> path, _i1.EthereumAddress to, BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('swapExactTokensForAVAX');
    final params = [amountIn, amountOutMin, path, to, deadline];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> swapExactTokensForAVAXSupportingFeeOnTransferTokens(
      BigInt amountIn,
      BigInt amountOutMin,
      List<_i1.EthereumAddress> path,
      _i1.EthereumAddress to,
      BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function =
        self.function('swapExactTokensForAVAXSupportingFeeOnTransferTokens');
    final params = [amountIn, amountOutMin, path, to, deadline];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> swapExactTokensForTokens(BigInt amountIn, BigInt amountOutMin,
      List<_i1.EthereumAddress> path, _i1.EthereumAddress to, BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('swapExactTokensForTokens');
    final params = [amountIn, amountOutMin, path, to, deadline];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> swapExactTokensForTokensSupportingFeeOnTransferTokens(
      BigInt amountIn,
      BigInt amountOutMin,
      List<_i1.EthereumAddress> path,
      _i1.EthereumAddress to,
      BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function =
        self.function('swapExactTokensForTokensSupportingFeeOnTransferTokens');
    final params = [amountIn, amountOutMin, path, to, deadline];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> swapTokensForExactAVAX(BigInt amountOut, BigInt amountInMax,
      List<_i1.EthereumAddress> path, _i1.EthereumAddress to, BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('swapTokensForExactAVAX');
    final params = [amountOut, amountInMax, path, to, deadline];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> swapTokensForExactTokens(BigInt amountOut, BigInt amountInMax,
      List<_i1.EthereumAddress> path, _i1.EthereumAddress to, BigInt deadline,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('swapTokensForExactTokens');
    final params = [amountOut, amountInMax, path, to, deadline];
    return write(credentials, transaction, function, params);
  }
}
