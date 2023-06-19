import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamSizeField extends StatefulWidget {
  const TeamSizeField({
    super.key,
    required this.textBoxWid,
  });

  final double textBoxWid;

  @override
  State<TeamSizeField> createState() => _TeamSizeFieldState();
}

class _TeamSizeFieldState extends State<TeamSizeField> {
  final TextEditingController teamSizeController = TextEditingController();
  @override
  void dispose() {
    teamSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final league = context.read<EditRulesBloc>().state.league;
    teamSizeController.text = league.teamSize.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Team Size: ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          width: widget.textBoxWid,
          child: TextFormField(
            onChanged: (value) => {
              context
                  .read<EditRulesBloc>()
                  .add(UpdateTeamSize(teamSize: int.parse(value)))
            },
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                RegExp('[0-9]'),
              ),
            ],
            controller: teamSizeController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[400]!,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 20,
                  color: Colors.grey[400]!,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              hintText: 'Enter Team Size',
            ),
          ),
        ),
      ],
    );
  }
}
