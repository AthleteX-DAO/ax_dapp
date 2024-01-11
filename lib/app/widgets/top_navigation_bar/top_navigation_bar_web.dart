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
    const navigationBarItemTextSize = 25.0;
    return BlocBuilder<TopNavigationBarBloc, TopNavigationBarState>(
      builder: (context, state) {
        final selectedButton =
            (state is ButtonSelectedState) ? state.selectedButton : '';
        final bloc = context.read<TopNavigationBarBloc>();
        return SizedBox(
          width: _width,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: _width * 0.5,
                child: Row(
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
                      routeName: 'predict',
                      buttonName: 'Predict',
                      isSelected: selectedButton == 'predict',
                      onPressed: () {
                        bloc.add(
                            const SelectButtonEvent(buttonName: 'predict'));
                        context.goNamed('predict');
                      },
                    ),
                    // TopNavigationBarItem(
                    //   routeName: 'scout',
                    //   buttonName: 'Markets',
                    //   isSelected: selectedButton == 'scout',
                    //   onPressed: () {
                    //     bloc.add(const SelectButtonEvent(buttonName: 'scout'));
                    //     context.goNamed('scout');
                    //   },
                    // ),
                    TopNavigationBarItem(
                      routeName: 'trade',
                      buttonName: 'Trade',
                      isSelected: selectedButton == 'trade',
                      onPressed: () {
                        bloc.add(const SelectButtonEvent(buttonName: 'trade'));
                        context.goNamed('trade');
                      },
                    ),
                    TopNavigationBarItem(
                      routeName: 'pool',
                      buttonName: 'Pool',
                      isSelected: selectedButton == 'pool',
                      onPressed: () {
                        bloc.add(const SelectButtonEvent(buttonName: 'pool'));
                        context.goNamed('pool');
                      },
                    ),
                    TopNavigationBarItem(
                      routeName: 'farm',
                      buttonName: 'Earn',
                      isSelected: selectedButton == 'farm',
                      onPressed: () {
                        bloc.add(const SelectButtonEvent(buttonName: 'farm'));
                        context.goNamed('farm');
                      },
                    ),
                    TopNavigationBarItem(
                      routeName: 'league',
                      buttonName: 'League',
                      isSelected: selectedButton == 'league',
                      onPressed: () {
                        bloc.add(const SelectButtonEvent(buttonName: 'league'));
                        context.goNamed('league');
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        launchUrl(
                          Uri.parse(
                            'https://snapshot.org/#/athletex.eth',
                          ),
                        );
                      },
                      child: Text(
                        'Vote',
                        style: textStyle(
                          Colors.white,
                          navigationBarItemTextSize,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const WalletTopBar(),
            ],
          ),
        );
      },
    );
  }
}
