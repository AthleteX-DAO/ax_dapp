import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationBarMobile extends StatelessWidget {
  const BottomNavigationBarMobile({
    super.key,
    required this.selectedIndex,
  });

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    Color iconColor(int index) {
      if (index == selectedIndex) {
        return Colors.white;
      } else {
        return Colors.grey;
      }
    }

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
            color: iconColor(0),
          ),
          label: 'Scout',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/swap.png',
            height: 24,
            width: 24,
            color: iconColor(1),
          ),
          label: 'Trade',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/coins.png',
            height: 24,
            width: 24,
            color: iconColor(2),
          ),
          label: 'Pool',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/barn.png',
            height: 24,
            width: 24,
            color: iconColor(3),
          ),
          label: 'Farm',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
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
        }
      },
    );
  }
}
