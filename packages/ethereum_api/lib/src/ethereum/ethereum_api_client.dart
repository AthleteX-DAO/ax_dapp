import 'package:ethereum_api/src/tokens/tokens.dart';
import 'package:ethereum_api/src/wallet/models/models.dart';
import 'package:shared/shared.dart';

/// {@template ethereum_api_client}
/// API client which handles interaction with the `Ethereum` blockchain.
/// {@endtemplate}
class EthereumApiClient {
  /// {@macro ethereum_api_client}
  EthereumApiClient({required Web3Client web3Client})
      : _web3Client = web3Client;

  final Web3Client _web3Client;

  final _tokensController = BehaviorSubject<List<Token>>();

  /// Allows listening to changes to the current [Token]s.
  Stream<List<Token>> get tokensChanges => _tokensController.stream;

  /// Returns the current [Token]s synchronously. The returned [Token]s are
  /// based on the current [EthereumChain].
  List<Token> get tokens => _tokensController.valueOrNull ?? const [];

  /// Allows listening to changes to the current [Apt]s.
  Stream<List<Apt>> get aptsChanges => _tokensController.stream
      .map((tokens) => tokens.whereType<Apt>().toList());

  /// Returns the current [Apt]s synchronously. The returned [Apt]s are
  /// based on the current [EthereumChain].
  List<Apt> get apts => tokens.whereType<Apt>().toList();

  /// Allows listening to changes to the [Apt]s (long and short) for the
  /// athlete identified by [athleteId].
  Stream<AptPair> aptPairChanges(int athleteId) =>
      _tokensController.stream.map((tokens) => tokens.whereType<Apt>()).map(
            (apts) => AptPair(
              longApt: apts.singleWhere(
                (apt) => apt.athleteId == athleteId && apt.type.isLong,
                orElse: () => const Apt.empty(),
              ),
              shortApt: apts.singleWhere(
                (apt) => apt.athleteId == athleteId && apt.type.isShort,
                orElse: () => const Apt.empty(),
              ),
            ),
          );

  /// Returns the current [AptPair] for the given [athleteId] synchronously.
  /// The returned [AptPair] is based on the current [EthereumChain].
  AptPair aptPair(int athleteId) {
    final apts = tokens.whereType<Apt>();
    return AptPair(
      longApt: apts.singleWhere(
        (apt) => apt.athleteId == athleteId && apt.type.isLong,
        orElse: () => const Apt.empty(),
      ),
      shortApt: apts.singleWhere(
        (apt) => apt.athleteId == athleteId && apt.type.isShort,
        orElse: () => const Apt.empty(),
      ),
    );
  }

  /// Allows switching the current [Token]s, which are set based on the current
  /// [EthereumChain].
  ///
  /// The [Token]s are updated only if the current [EthereumChain] is supported.
  /// Otherwise, we keep the existing data.
  void switchTokens(EthereumChain chain) {
    if (chain.isSupported) {
      _tokensController.add(Token.values(chain));
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
