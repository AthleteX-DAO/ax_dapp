import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class EditLeagueHeader extends StatelessWidget {
  const EditLeagueHeader({super.key, required this.wid});
  final double wid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wid,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Edit League',
            style: textStyle(
              Colors.white,
              20,
              isBold: false,
              isUline: false,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
