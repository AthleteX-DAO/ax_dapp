import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_repository/league_repository.dart';

class LockToggle extends StatefulWidget {
  const LockToggle({
    super.key,
    required this.league,
    required this.textSize,
  });

  final League league;
  final double textSize;

  @override
  State<LockToggle> createState() => _LockToggleState();
}

class _LockToggleState extends State<LockToggle> {
  late List<bool> _lock;
  late bool _lockToggle;

  @override
  void initState() {
    _lockToggle = widget.league.isLocked;
    _lock = widget.league.isLocked ? [false, true] : [true, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Lock: ',
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
                for (var i = 0; i < _lock.length; i++) {
                  _lock[i] = i == index;
                  _lockToggle = _lock[i];
                }
              });
              context
                  .read<EditRulesBloc>()
                  .add(UpdateLockToggle(lockedToggleValue: _lockToggle));
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
            isSelected: _lock,
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
