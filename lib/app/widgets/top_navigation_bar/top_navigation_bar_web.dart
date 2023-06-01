import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TopNavigationBarWeb extends StatelessWidget {
  const TopNavigationBarWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var tabTextSize = _width * 0.0185;
    if (tabTextSize < 19) tabTextSize = 19;
    var tabBoxSize = _width * 0.45;
    if (tabBoxSize < 350) tabBoxSize = 350;
    return BlocBuilder<TopNavigationBarBloc, TopNavigationBarState>(
      builder: (context, state) {
        final selectedButton =
            (state is ButtonSelectedState) ? state.selectedButton : '';
        final bloc = context.read<TopNavigationBarBloc>();
        return SizedBox(
          width: _width * .95,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: tabBoxSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: 72,
                      height: 50,
                      child: IconButton(
                        icon: Image.asset('assets/images/x.png'),
                        iconSize: 40,
                        onPressed: () {
                          final urlString =
                              Uri.parse('https://www.athletex.io/');
                          launchUrl(urlString);
                        },
                      ),
                    ),
                    TopNavigationBarItem(
                      tabTextSize: tabTextSize,
                      routeName: 'scout',
                      buttonName: 'Scout',
                      isSelected: selectedButton == 'scout',
                      onPressed: () {
                        bloc.add(const SelectButtonEvent(buttonName: 'scout'));
                        context.goNamed('scout');
                      },
                    ),
                    TopNavigationBarItem(
                      tabTextSize: tabTextSize,
                      routeName: 'trade',
                      buttonName: 'Trade',
                      isSelected: selectedButton == 'trade',
                      onPressed: () {
                        bloc.add(const SelectButtonEvent(buttonName: 'trade'));
                        context.goNamed('trade');
                      },
                    ),
                    TopNavigationBarItem(
                      tabTextSize: tabTextSize,
                      routeName: 'pool',
                      buttonName: 'Pool',
                      isSelected: selectedButton == 'pool',
                      onPressed: () {
                        bloc.add(const SelectButtonEvent(buttonName: 'pool'));
                        context.goNamed('pool');
                      },
                    ),
                    TopNavigationBarItem(
                      tabTextSize: tabTextSize,
                      routeName: 'farm',
                      buttonName: 'Farm',
                      isSelected: selectedButton == 'farm',
                      onPressed: () {
                        bloc.add(const SelectButtonEvent(buttonName: 'farm'));
                        context.goNamed('farm');
                      },
                    ),
                    // TODO(Ryan): enable the UI once the feature is ready
                    // TopNavigationBarItem(tabTextSize: tabTextSize, routeName: 'league', buttonName: 'League'),
                    TextButton(
                      onPressed: () {
                        launchUrl(
                            Uri.parse('https://snapshot.org/#/athletex.eth'));
                      },
                      child: Text(
                        'Vote',
                        style: textStyle(
                          Colors.white,
                          tabTextSize,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const WalletView(),
            ],
          ),
        );
      },
    );
  }
}
