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
        ? 'Change to SX network for NFL Tokens'
        : selectedChain == EthereumChain.sxMainnet
            ? 'Change to Polygon network for MLB Tokens'
            : 'Athletes not supported yet';

    return SizedBox(
      height: 80,
      width: 600,
      child: Text(
        warningText,
        style: const TextStyle(color: Colors.amber, fontSize: 30),
      ),
    );
  }
}
