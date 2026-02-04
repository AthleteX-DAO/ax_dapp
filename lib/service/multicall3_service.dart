import 'dart:typed_data';

import 'package:ax_dapp/config/athletex_synthetix_config.dart';
import 'package:web3dart/web3dart.dart';

class Multicall3Call {
  const Multicall3Call({
    required this.target,
    required this.callData,
    this.allowFailure = false,
  });

  final EthereumAddress target;
  final Uint8List callData;
  final bool allowFailure;
}

class Multicall3Result {
  const Multicall3Result({
    required this.success,
    required this.returnData,
  });

  final bool success;
  final Uint8List returnData;
}

class Multicall3Service {
  Multicall3Service({
    required Web3Client client,
    EthereumAddress? multicallAddress,
  })  : _client = client,
        _multicall = DeployedContract(
          ContractAbi.fromJson(_multicall3Abi, 'Multicall3'),
          multicallAddress ??
              EthereumAddress.fromHex(
                AthleteXSynthetixConfig.multicall3Address,
              ),
        );

  final Web3Client _client;
  final DeployedContract _multicall;

  Future<List<Multicall3Result>> aggregate3(
    List<Multicall3Call> calls,
  ) async {
    final function = _multicall.function('aggregate3');
    final callData = calls
        .map((call) => [call.target, call.allowFailure, call.callData])
        .toList();

    final response = await _client.call(
      contract: _multicall,
      function: function,
      params: [callData],
    );

    final results = <Multicall3Result>[];
    for (final result in (response.first as List)) {
      final success = result[0] as bool;
      final returnData = result[1] as Uint8List;
      results.add(Multicall3Result(success: success, returnData: returnData));
    }
    return results;
  }

  static const String _multicall3Abi = '''
  [
    {
      "inputs": [
        {
          "components": [
            {"internalType": "address", "name": "target", "type": "address"},
            {"internalType": "bool", "name": "allowFailure", "type": "bool"},
            {"internalType": "bytes", "name": "callData", "type": "bytes"}
          ],
          "internalType": "struct Multicall3.Call3[]",
          "name": "calls",
          "type": "tuple[]"
        }
      ],
      "name": "aggregate3",
      "outputs": [
        {
          "components": [
            {"internalType": "bool", "name": "success", "type": "bool"},
            {"internalType": "bytes", "name": "returnData", "type": "bytes"}
          ],
          "internalType": "struct Multicall3.Result[]",
          "name": "returnData",
          "type": "tuple[]"
        }
      ],
      "stateMutability": "payable",
      "type": "function"
    }
  ]
  ''';
}
