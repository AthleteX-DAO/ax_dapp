import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletChain extends StatelessWidget {
  const WalletChain({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var showChainIcon = true;
    var showIcons = false;
    if (_width < 665) {
      showChainIcon = false;
      showIcons = true;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (showChainIcon)
          const Icon(
            Icons.link,
            color: Colors.grey,
          ),
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: BlocSelector<WalletBloc, WalletState, EthereumChain>(
              selector: (state) => state.chain,
              builder: (context, chain) {
                return DropdownButton<EthereumChain>(
                  dropdownColor: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 1,
                  value: chain,
                  items: [
                    for (final chain in EthereumChain.supportedValues)
                      DropdownMenuItem(
                        value: chain,
                        child: showIcons
                            ? Image(
                                width: 40,
                                height: 40,
                                image: AssetImage(chain.localizedImage),
                              )
                            : Text(chain.localizedName),
                      ),
                  ],
                  onChanged: (chain) => context
                      .read<WalletBloc>()
                      .add(SwitchChainRequested(chain)),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

extension EthereumChainLocalizationX on EthereumChain {
  String get localizedName {
    switch (this) {
      case EthereumChain.none:
      case EthereumChain.unsupported:
        throw UnsupportedError('$this');
      case EthereumChain.polygonMainnet:
        return 'Matic Network';
      case EthereumChain.goerliTestNet:
        return 'Goerli Test Network';
      case EthereumChain.sxMainnet:
        return 'SX Network';
      case EthereumChain.sxTestnet:
        return 'SX Test Network';
    }
  }
}

extension EthereumChainLocalizationImageX on EthereumChain {
  String get localizedImage {
    switch (this) {
      case EthereumChain.none:
      case EthereumChain.unsupported:
        throw UnsupportedError('$this');
      case EthereumChain.polygonMainnet:
        return 'assets/images/Polygon_Small.png';
      case EthereumChain.goerliTestNet:
        return 'assets/images/geth.png';
      case EthereumChain.sxMainnet:
        return 'assets/images/SX_small.png';
      case EthereumChain.sxTestnet:
        return 'assets/images/SX_small.png';
    }
  }
}
