import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/wallet/models/models.dart';
import 'package:shared/shared.dart';

/// {@template contract}
/// Configures an object with addresses, one for each supported [Contract].
/// {@endtemplate}
class Contract extends Equatable {
  /// {@macro contract}
  const Contract({
    required this.name,
    required EthereumAddressConfig addressConfig,
    required EthereumChain chain,
  })  : _addressConfig = addressConfig,
        _chain = chain;
  
  /// Exchanges the Contracts Router [EthereumAddressConfig]
  const Contract.exchangeRouter(EthereumChain chain) : this(
    name: 'AthleteX Router',
    addressConfig: const EthereumAddressConfig.dexRouterAddress(),
    chain: chain,
  );

  /// Exchanges the Contracts Factory [EthereumAddressConfig]
  const Contract.exchangeFactory(EthereumChain chain) : this(
    name: 'AthleteX Factory',
    addressConfig: const EthereumAddressConfig.dexFactoryAddress(),
    chain: chain,
  );

  /// Represents the [name]
  final String name;

  /// Represents the [_addressConfig]
  final EthereumAddressConfig _addressConfig;

  /// Represents the [_chain]
  final EthereumChain _chain;

  @override
  List<Object?> get props => [
        name,
        _addressConfig,
        _chain,
      ];
}

/// []
extension APTRouterX on Contract {
  /// Retrieves the current address from the [EthereumAddressConfig]
  String get address => _addressConfig.address(_chain);

  /// Retrieves the current [EthereumChain]
  EthereumChain get chain => _chain;
}
