library userinfo;

import 'package:js/js.dart';

@JS()
abstract class TransactionReceipt {
  external factory TransactionReceipt({
    bool status,
    String transactionHash,
    num transactionIndex,
    String blocHash,
    num blockNumber,
    String from,
    String to,
    String? contractAddress,
    num cumulativeGasUsed,
    num gasUsed,
    num effectiveGasPrice,
  });
  external bool get status;
  external set status(bool value);
  external String get transactionHash;
  external set transactionHash(String value);
  external num get transactionIndex;
  external set transactionIndex(num value);
  external String get blockHash;
  external set blockHash(String value);
  external num get blockNumber;
  external set blockNumber(num value);
  external String get from;
  external set from(String value);
  external String get to;
  external set to(String value);
  external String get contractAddress;
  external set contractAddress(String value);
  external num get cumulativeGasUsed;
  external set cumulativeGasUsed(num value);
  external num get gasUsed;
  external set gasUsed(num value);
  external num get effectiveGasPrice;
  external set effectiveGasPrice(num value);
}
