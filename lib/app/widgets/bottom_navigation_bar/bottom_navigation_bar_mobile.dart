import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// TODO(Ryan): Remove ignore message when package is ready to use
// ignore: unused_import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationBarMobile extends StatefulWidget {
  const BottomNavigationBarMobile({
    super.key,
  });

  @override
  State<BottomNavigationBarMobile> createState() =>
      _BottomNavigationBarMobileState();
}

class _BottomNavigationBarMobileState extends State<BottomNavigationBarMobile> {
  void _onItemTapped(int index) {
    context
        .read<BottomNavigationBarBloc>()
        .add(SelectItemEvent(itemIndex: index));

    switch (index) {
      case 0:
        context.goNamed('predict');
        break;
      case 1:
        context.goNamed('scout');
        break;
      case 2:
        context.goNamed('trade');
        break;
      case 3:
        context.goNamed('pool');
        break;
      case 4:
        context.goNamed('farm');
        break;
      case 5:
        context.goNamed('league');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBarBloc, BottomNavigationBarState>(
      builder: (context, state) {
        final selectedIndex =
            (state is ItemSelectedState) ? state.selectedItem : 0;

        return BottomNavigationBar(
          showUnselectedLabels: false,
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontFamily: 'OpenSans',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontFamily: 'OpenSans',
          ),
          type: BottomNavigationBarType.shifting,
          backgroundColor: Colors.transparent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.percent,
                size: 24,
              ),
              label: 'Predict',
              tooltip: 'Make a prediction',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 24),
              label: 'Markets',
              tooltip: 'Trade Live Markets',
            ),
            BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.arrowRightArrowLeft,
                  size: 24,
                ),
                label: 'Trade',
                tooltip: 'Swap betwen your favorite coins'),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.coins),
              label: 'Pool',
              tooltip: 'Pool Tokens together and Add Liquidity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.agriculture_rounded),
              label: 'Farm',
              tooltip: 'Earn rewards for depositing your money',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.trophy,
                size: 24,
              ),
              label: 'League',
              tooltip: 'Start a cross-sport fantasy league',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: primaryOrangeColor,
          unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
        );
      },
    );
  }
}
