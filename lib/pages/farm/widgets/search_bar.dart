import 'package:ax_dapp/pages/farm/bloc/farm_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebSearchBar extends StatelessWidget {
  const WebSearchBar({
    super.key,
    required this.isWeb,
    required this.myController,
    required this.layoutWdt,
    required this.layoutHgt,
  });

  final bool isWeb;
  final TextEditingController myController;
  final double layoutWdt;
  final double layoutHgt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWeb ? 250 : layoutWdt / 2,
      height: isWeb ? 40 : layoutHgt * 0.05,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[300]!),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: myController,
              onChanged: (value) {
                context
                    .read<FarmBloc>()
                    .add(OnSearchFarms(searchedName: value));
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 8.5),
                hintText: 'Search a farm',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileSearchBar extends StatelessWidget {
  const MobileSearchBar({
    super.key,
    required this.isWeb,
    required this.myController,
    required this.layoutWdt,
    required this.layoutHgt,
  });

  final bool isWeb;
  final TextEditingController myController;
  final double layoutWdt;
  final double layoutHgt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWeb ? 250 : layoutWdt / 2,
      height: isWeb ? 40 : layoutHgt * 0.05,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[300]!),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: myController,
              onChanged: (value) {
                context
                    .read<FarmBloc>()
                    .add(OnSearchFarms(searchedName: value));
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: layoutHgt * 0.022),
                hintText: 'Search a farm',
                hintStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
