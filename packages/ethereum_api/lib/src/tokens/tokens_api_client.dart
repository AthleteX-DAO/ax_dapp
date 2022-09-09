import 'package:ethereum_api/src/tokens/tokens.dart';
import 'package:ethereum_api/src/wallet/models/models.dart';
import 'package:shared/shared.dart';

/// {@template tokens_api_client}
/// Client that manages the tokens API on `Ethereum`.
/// {@endtemplate}
class TokensApiClient {
  /// {@macro tokens_api_client}
  TokensApiClient({
    required EthereumChain defaultChain,
    required ValueStream<Web3Client> reactiveWeb3Client,
  })  : _reactiveWeb3Client = reactiveWeb3Client,
        _tokensController = ReplaySubject<List<Token>>(maxSize: 2)
          ..add(defaultChain.createTokens());

  final ValueStream<Web3Client> _reactiveWeb3Client;
  Web3Client get _web3Client => _reactiveWeb3Client.value;

  final ReplaySubject<List<Token>> _tokensController;
  // final _tokensController = ReplaySubject<List<Token>>(maxSize: 2);

  /// Allows listening to changes to the current [Token]s.
  Stream<List<Token>> get tokensChanges => _tokensController.stream;

  /// Returns the current [Token]s synchronously. The returned [Token]s are
  /// based on the current [EthereumChain].
  List<Token> get currentTokens =>
      _tokensController.values.lastOrNull ?? const [];

  /// Returns the previous [Token]s synchronously. The returned [Token]s are
  /// based on the previous [EthereumChain].
  ///
  /// Defaults to an empty list when there's no previous [EthereumChain],
  /// meaning the wallet was not yet connected or it was just connected but the
  /// chain wasn't yet changed.
  List<Token> get previousTokens {
    final values = _tokensController.values;
    return values.length < 2 ? const [] : values.first;
  }

  /// Allows switching the current [Token]s, which are set based on the current
  /// [EthereumChain].
  ///
  /// The [Token]s are updated only if the current [EthereumChain] is supported.
  /// Otherwise, we keep the existing data.
  void switchTokens(EthereumChain chain) {
    if (chain.isSupported) {
      _tokensController.add(chain.createTokens());
    }
  }

  /// Returns the symbol for the [Token] identified by the [tokenAddress].
  ///
  /// Defaults to returning an empty string on error.
  Future<String> getTokenSymbol(String tokenAddress) async {
    try {
      final tokenEthereumAddress = EthereumAddress.fromHex(tokenAddress);
      final token = ERC20(address: tokenEthereumAddress, client: _web3Client);
      return await token.symbol();
    } catch (_) {
      return '';
    }
  }
}
