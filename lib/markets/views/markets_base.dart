import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/markets/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Scout extends StatelessWidget {
  const Scout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    context
        .read<TopNavigationBarBloc>()
        .add(const SelectButtonEvent(buttonName: 'scout'));
    context
        .read<BottomNavigationBarBloc>()
        .add(const SelectItemEvent(itemIndex: 0));
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 715) {
          return DesktopMarkets();
        } else {
          return const MobileMarkets();
        }
      },
    );
  }
}
