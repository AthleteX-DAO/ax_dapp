import 'package:ax_dapp/app/widgets/bottom_navigation_bar/bloc/bottom_navigation_bar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// TODO(Ryan): re-enable this import for the league feature
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        context.goNamed('scout');
        break;
      case 1:
        context.goNamed('trade');
        break;
      case 2:
        context.goNamed('pool');
        break;
      case 3:
        context.goNamed('farm');
        break;
      case 4:
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
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontFamily: 'OpenSans',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontFamily: 'OpenSans',
          ),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/search.png',
                height: 24,
                width: 24,
              ),
              label: 'Scout',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/swap.png',
                height: 24,
                width: 24,
              ),
              label: 'Trade',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/coins.png',
                height: 24,
                width: 24,
              ),
              label: 'Pool',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/barn.png',
                height: 24,
                width: 24,
              ),
              label: 'Farm',
            ),
            // TODO(Ryan): enable the UI once the feature is ready
            // BottomNavigationBarItem(
            //   icon: FaIcon(
            //     FontAwesomeIcons.trophy,
            //     size: 24,
            //   ),
            //   label: 'League',
            // ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        );
      },
    );
  }
}
