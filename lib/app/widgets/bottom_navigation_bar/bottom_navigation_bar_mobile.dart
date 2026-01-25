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
        context.goNamed('league');
        break;
      case 2:
        context.goNamed('spot-markets');
        break;
      case 3:
        context.goNamed('earn');
        break;
      case 4:
        context.goNamed('perpetuals');
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
              tooltip: 'Trade on athlete prediction markets',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.trophy,
                size: 24,
              ),
              label: 'League',
              tooltip: 'cross-sport fantasy league, what else?',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chartLine),
              label: 'Spot',
              tooltip: 'Trade spot markets',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.vault),
              label: 'Vaults',
              tooltip: 'Earn yield on your assets',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.arrowTrendUp),
              label: 'Perps',
              tooltip: 'Trade perpetual futures',
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
