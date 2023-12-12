import 'package:ax_dapp/util/chain_localized_error.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterMenuError extends StatelessWidget {
  const FilterMenuError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedChain = context.select((WalletBloc bloc) => bloc.state.chain);
    return SizedBox(
      height: 80,
      width: 600,
      child: Text(
        selectedChain.localizedError,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 30,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }
}
