import 'dart:typed_data';

import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:ax_dapp/service/multicall3_service.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';

class SynthetixBatchSnapshot {
  const SynthetixBatchSnapshot({
    required this.deposited,
    required this.available,
    required this.debt,
    required this.collateralRatio,
  });

  final BigInt deposited;
  final BigInt available;
  final BigInt debt;
  final BigInt collateralRatio;
}

class SynthetixBatchQueries {
  SynthetixBatchQueries({required Web3Client client})
      : _multicall3 = Multicall3Service(client: client),
        _coreProxy = DeployedContract(
          ContractAbi.fromJson(_coreProxyAbi, 'SynthetixCoreProxy'),
          EthereumAddress.fromHex(SynthetixConfig.coreProxy),
        );

  final Multicall3Service _multicall3;
  final DeployedContract _coreProxy;

  Future<SynthetixBatchSnapshot> fetchAccountSnapshot({
    required int accountId,
    required String collateralAddress,
    required int poolId,
  }) async {
    final collateralType = EthereumAddress.fromHex(collateralAddress);
    final accountIdBig = BigInt.from(accountId);
    final poolIdBig = BigInt.from(poolId);

    final getCollateralFn = _coreProxy.function('getAccountCollateral');
    final getAvailableFn = _coreProxy.function('getAccountAvailableCollateral');
    final getDebtFn = _coreProxy.function('getPositionDebt');
    final getCRatioFn = _coreProxy.function('getPositionCollateralRatio');

    final calls = [
      Multicall3Call(
        target: _coreProxy.address,
        callData: Uint8List.fromList(
          getCollateralFn.encodeCall([accountIdBig, collateralType]),
        ),
      ),
      Multicall3Call(
        target: _coreProxy.address,
        callData: Uint8List.fromList(
          getAvailableFn.encodeCall([accountIdBig, collateralType]),
        ),
      ),
      Multicall3Call(
        target: _coreProxy.address,
        callData: Uint8List.fromList(
          getDebtFn.encodeCall([accountIdBig, poolIdBig, collateralType]),
        ),
      ),
      Multicall3Call(
        target: _coreProxy.address,
        callData: Uint8List.fromList(
          getCRatioFn.encodeCall([accountIdBig, poolIdBig, collateralType]),
        ),
      ),
    ];

    final results = await _multicall3.aggregate3(calls);

    BigInt deposited = BigInt.zero;
    BigInt assigned = BigInt.zero;
    BigInt available = BigInt.zero;
    BigInt debt = BigInt.zero;
    BigInt cRatio = BigInt.zero;

    if (results[0].success) {
      final decoded = getCollateralFn.decodeReturnValues(
        bytesToHex(results[0].returnData, include0x: true),
      );
      deposited = decoded[0] as BigInt;
      assigned = decoded[1] as BigInt;
    }
    if (results[1].success) {
      final decoded = getAvailableFn.decodeReturnValues(
        bytesToHex(results[1].returnData, include0x: true),
      );
      available = decoded[0] as BigInt;
    }
    if (results[2].success) {
      final decoded = getDebtFn.decodeReturnValues(
        bytesToHex(results[2].returnData, include0x: true),
      );
      debt = decoded[0] as BigInt;
    }
    if (results[3].success) {
      final decoded = getCRatioFn.decodeReturnValues(
        bytesToHex(results[3].returnData, include0x: true),
      );
      cRatio = decoded[0] as BigInt;
    }

    // Prefer deposited from collateral call; fallback to assigned if needed
    final effectiveDeposited = deposited != BigInt.zero ? deposited : assigned;

    return SynthetixBatchSnapshot(
      deposited: effectiveDeposited,
      available: available,
      debt: debt,
      collateralRatio: cRatio,
    );
  }

  static const String _coreProxyAbi = '''
  [
    {
      "inputs": [
        {"internalType": "uint128", "name": "accountId", "type": "uint128"},
        {"internalType": "address", "name": "collateralType", "type": "address"}
      ],
      "name": "getAccountCollateral",
      "outputs": [
        {"internalType": "uint256", "name": "totalDeposited", "type": "uint256"},
        {"internalType": "uint256", "name": "totalAssigned", "type": "uint256"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "uint128", "name": "accountId", "type": "uint128"},
        {"internalType": "address", "name": "collateralType", "type": "address"}
      ],
      "name": "getAccountAvailableCollateral",
      "outputs": [
        {"internalType": "uint256", "name": "availableCollateral", "type": "uint256"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "uint128", "name": "accountId", "type": "uint128"},
        {"internalType": "uint128", "name": "poolId", "type": "uint128"},
        {"internalType": "address", "name": "collateralType", "type": "address"}
      ],
      "name": "getPositionDebt",
      "outputs": [
        {"internalType": "int256", "name": "debt", "type": "int256"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "uint128", "name": "accountId", "type": "uint128"},
        {"internalType": "uint128", "name": "poolId", "type": "uint128"},
        {"internalType": "address", "name": "collateralType", "type": "address"}
      ],
      "name": "getPositionCollateralRatio",
      "outputs": [
        {"internalType": "uint256", "name": "cRatio", "type": "uint256"}
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]
  ''';
}
