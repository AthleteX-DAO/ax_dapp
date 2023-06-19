import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:tokens_repository/tokens_repository.dart';

class SportSelection extends StatefulWidget {
  const SportSelection({super.key});

  @override
  State<SportSelection> createState() => _SportSelectionState();
}

class _SportSelectionState extends State<SportSelection> {
  late List<SupportedSport> selectedSports;
  final supportedSports = [
    SupportedSport.MLB,
    SupportedSport.NFL,
  ];
  late SupportedSport dropDownValue;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final league = context.read<EditRulesBloc>().state.league;
    dropDownValue = league.sports.first;
    selectedSports = league.sports;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Sport(s): ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w400,
          ),
        ),
        MultiSelectDialogField(
          initialValue: league.sports,
          chipDisplay: MultiSelectChipDisplay<SupportedSport>(
            chipColor: Colors.transparent,
            textStyle: TextStyle(
              color: Colors.amber[400],
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              border: Border.all(
                color: Colors.amber,
                width: 2,
              ),
            ),
          ),
          dialogWidth: _width / 2,
          dialogHeight: _height / 2,
          items: supportedSports
              .map(
                (supportedSport) => MultiSelectItem(
                  supportedSport,
                  supportedSport.name,
                ),
              )
              .toList(),
          itemsTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w400,
          ),
          unselectedColor: Colors.white,
          title: const Text(
            'Sports',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
            ),
          ),
          selectedItemsTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w400,
          ),
          selectedColor: Colors.amber[400],
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            border: Border.all(
              color: Colors.amber,
              width: 2,
            ),
          ),
          buttonIcon: Icon(
            Icons.sports,
            color: Colors.amber[400],
          ),
          buttonText: Text(
            'Choose Sports',
            style: TextStyle(
              color: Colors.amber[400],
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
            ),
          ),
          onConfirm: (results) {
            selectedSports = results as List<SupportedSport>;
            context
                .read<EditRulesBloc>()
                .add(UpdateSports(selectedSports: selectedSports));
          },
        ),
      ],
    );
  }
}
