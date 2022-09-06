import 'package:ethereum_api/src/config/models/apt_config.dart';
import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/ethereum/models/models.dart';
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

  const Contract.exchangeFactory(EthereumChain chain) : this(
    name: 'AthleteX Factory',
    addressConfig: const EthereumAddressConfig.dexFactoryAddress(),
    chain: chain,
  );
  const Contract.exchangeRouter(EthereumChain chain) : this(
    name: 'AthleteX Router',
    addressConfig: const EthereumAddressConfig.dexRouterAddress(),
    chain: chain,
  );
}

extension APTRouterX on Contract {
  String get address => _addressConfig.address(_chain);

  EthereumChain get chain => _chain;
}
