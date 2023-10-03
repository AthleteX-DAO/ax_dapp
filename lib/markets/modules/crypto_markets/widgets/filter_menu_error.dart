import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';

class FilterMenuError extends StatelessWidget {
  const FilterMenuError({
    required this.selectedChain,
    super.key,
  });
  final EthereumChain? selectedChain;

  @override
  Widget build(BuildContext context) {
    final warningText = selectedChain == EthereumChain.polygonMainnet
        ? 'Change to SX network for SX Betting Markets'
        : selectedChain == EthereumChain.sxMainnet
            ? 'Change to Polygon network for MLB Tokens'
            : 'Error producing markets, try reloading the dapp';
    const warningText2 = 'Error producing markets, try reloading the dapp';
    return const SizedBox(
      height: 80,
      width: 600,
      child: Text(
        warningText2,
        style: TextStyle(
          color: Colors.amber,
          fontSize: 30,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }
}
