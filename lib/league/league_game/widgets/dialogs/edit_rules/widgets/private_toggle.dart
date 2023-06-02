import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_repository/league_repository.dart';

class PrivateToggle extends StatefulWidget {
  const PrivateToggle({
    super.key,
    required this.league,
    required this.textSize,
  });

  final League league;
  final double textSize;

  @override
  State<PrivateToggle> createState() => _PrivateToggleState();
}

class _PrivateToggleState extends State<PrivateToggle> {
  late List<bool> _private;
  late bool _privateToggle;

  @override
  void initState() {
    _privateToggle = widget.league.isPrivate;
    _private = widget.league.isPrivate ? [false, true] : [true, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Private: ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: widget.textSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          width: 145,
          height: 25,
          child: ToggleButtons(
            onPressed: (int index) {
              setState(() {
                for (var i = 0; i < _private.length; i++) {
                  _private[i] = i == index;
                  _privateToggle = _private[i];
                }
              });
              context
                  .read<EditRulesBloc>()
                  .add(UpdatePrivateToggle(privateToggleValue: _privateToggle));
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.amber[700],
            selectedColor: Colors.black,
            fillColor: Colors.amber[400],
            color: Colors.amber[400],
            constraints: const BoxConstraints(
              minHeight: 40,
              minWidth: 71,
            ),
            isSelected: _private,
            children: <Widget>[
              Text(
                'No',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: widget.textSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Yes',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: widget.textSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
