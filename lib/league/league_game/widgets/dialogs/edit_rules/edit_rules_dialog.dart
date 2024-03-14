import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditRulesDialog extends StatefulWidget {
  const EditRulesDialog({
    super.key,
  });

  @override
  State<EditRulesDialog> createState() => _EditRulesDialog();
}

class _EditRulesDialog extends State<EditRulesDialog> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final league = context.read<EditRulesBloc>().state.league;

    var wid = 450.0;
    var textBoxWid = 250.0;
    if (_width < 500) {
      wid = _width;
      textBoxWid = _width * 0.5;
    }
    if (_width < 385) textBoxWid = _width * 0.45;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        height: _height <= 768 ? _height * 0.9 : _height * 0.75,
        width: wid,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              EditLeagueHeader(wid: wid),
              NameField(textBoxWid: textBoxWid),
              StartDateField(
                textBoxWid: textBoxWid,
                league: league,
              ),
              EndDateField(
                textBoxWid: textBoxWid,
                league: league,
              ),
              TeamSizeField(textBoxWid: textBoxWid),
              ParticipantsField(textBoxWid: textBoxWid),
              EntryFeeField(textBoxWid: textBoxWid),
              const SportSelection(),
              PrivateToggle(
                league: league,
              ),
              LockToggle(
                league: league,
              ),
              const ConfirmEdit(),
            ],
          ),
        ),
      ),
    );
  }
}
