import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParticipantsField extends StatefulWidget {
  const ParticipantsField({
    super.key,
    required this.textBoxWid,
  });

  final double textBoxWid;

  @override
  State<ParticipantsField> createState() => _ParticipantsFieldState();
}

class _ParticipantsFieldState extends State<ParticipantsField> {
  final TextEditingController participantsController = TextEditingController();
  @override
  void dispose() {
    participantsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final league = context.read<EditRulesBloc>().state.league;
    participantsController.text = league.maxTeams.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Participants: ',
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
                  .add(UpdateParticipants(participants: int.parse(value)))
            },
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                RegExp('[0-9]'),
              ),
            ],
            controller: participantsController,
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
              hintText: 'Enter Participants',
            ),
          ),
        ),
      ],
    );
  }
}
