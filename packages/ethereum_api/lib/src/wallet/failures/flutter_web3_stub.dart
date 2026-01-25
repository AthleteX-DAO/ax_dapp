class EthereumException implements Exception {
  EthereumException({this.code = -1, this.message = 'Unsupported platform'});

  final int code;
  final String message;
}

class EthereumUserRejected extends EthereumException {
  EthereumUserRejected()
      : super(code: 4001, message: 'User rejected operation (stub)');
}

class EthereumUnrecognizedChainException extends EthereumException {
  EthereumUnrecognizedChainException()
      : super(code: 4902, message: 'Unrecognized chain (stub)');
}
