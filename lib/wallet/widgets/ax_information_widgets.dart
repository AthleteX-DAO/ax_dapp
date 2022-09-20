import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AxPrice extends StatelessWidget {
  const AxPrice({super.key});

  @override
  Widget build(BuildContext context) {
    final price = context.select((WalletBloc bloc) => bloc.state.axData.price);
    final axPrice = price ?? '-';
    return Text(
      '$axPrice USD',
      style: TextStyle(
        fontSize: 15,
        color: Colors.grey[600],
      ),
    );
  }
}

class AxCirculation extends StatelessWidget {
  const AxCirculation({super.key});

  @override
  Widget build(BuildContext context) {
    final circulatingSupply = context
        .select((WalletBloc bloc) => bloc.state.axData.circulatingSupply);
    final axCirculation = circulatingSupply ?? '-';
    return Text(
      '$axCirculation',
      style: TextStyle(
        fontSize: 15,
        color: Colors.grey[600],
      ),
    );
  }
}

class AxTotalSupply extends StatelessWidget {
  const AxTotalSupply({super.key});

  @override
  Widget build(BuildContext context) {
    final totalSupply =
        context.select((WalletBloc bloc) => bloc.state.axData.totalSupply);
    final axTotalSupply = totalSupply ?? '-';
    return Text(
      '$axTotalSupply',
      style: TextStyle(
        fontSize: 15,
        color: Colors.grey[600],
      ),
    );
  }
}

class AxBalance extends StatelessWidget {
  const AxBalance({super.key, required this.style});

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final balance =
        context.select((WalletBloc bloc) => bloc.state.axData.balance);
    final axBalance = balance ?? '-';
    return Text('$axBalance AX', style: style);
  }
}
