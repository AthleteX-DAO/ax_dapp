import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class TopNavigationBarItem extends StatelessWidget {
  const TopNavigationBarItem({
    super.key,
    required this.routeName,
    required this.buttonName,
    required this.isSelected,
    required this.onPressed,
  });

  final String routeName;
  final String buttonName;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const navigationBarItemTextSize = 25.0;
    return TextButton(
      onPressed: onPressed,
      child: Text(
        buttonName,
        style: isSelected
            ? textStyle(
                Colors.amber[400]!,
                navigationBarItemTextSize,
                isBold: true,
                isUline: true,
              )
            : textStyle(
                Colors.white,
                navigationBarItemTextSize,
                isBold: true,
                isUline: false,
              ),
      ),
    );
  }
}
