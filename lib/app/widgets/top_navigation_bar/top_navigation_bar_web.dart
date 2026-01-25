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
    final _width = MediaQuery.sizeOf(context).width;
    const navigationBarItemTextSize = 25.0;
    return BlocBuilder<TopNavigationBarBloc, TopNavigationBarState>(
      builder: (context, state) {
        final selectedButton =
            (state is ButtonSelectedState) ? state.selectedButton : '';
        final bloc = context.read<TopNavigationBarBloc>();
        return SizedBox(
          width: _width,
          height: kTopNavBarHeightWeb,
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
                          const SelectButtonEvent(buttonName: 'predict'),
                        );
                        context.goNamed('predict');
                      },
                    ),
                    TopNavigationBarItem(
                      routeName: 'earn',
                      buttonName: 'Vaults',
                      isSelected: selectedButton == 'earn',
                      onPressed: () {
                        bloc.add(const SelectButtonEvent(buttonName: 'earn'));
                        context.goNamed('earn');
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
                    TopNavigationBarItem(
                      routeName: 'perpetuals',
                      buttonName: 'Perps',
                      isSelected: selectedButton == 'perpetuals',
                      onPressed: () {
                        bloc.add(
                            const SelectButtonEvent(buttonName: 'perpetuals'));
                        context.goNamed('perpetuals');
                      },
                    ),
                    TopNavigationBarItem(
                      routeName: 'spot-markets',
                      buttonName: 'Spot',
                      isSelected: selectedButton == 'spot-markets',
                      onPressed: () {
                        bloc.add(
                            const SelectButtonEvent(buttonName: 'spot-markets'));
                        context.goNamed('spot-markets');
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
