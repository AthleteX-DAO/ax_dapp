library userinfo;

import 'package:js/js.dart';

@JS()
class TransactionReceipt {
  external factory TransactionReceipt({
    bool status,
    String transactionHash,
    int transactionIndex,
    String blocHash,
    int blockNumber,
    String from,
    String to,
    String? contractAddress,
    double cumulativeGasUsed,
    double gasUsed,
    double effectiveGasPrice,
  });
}
