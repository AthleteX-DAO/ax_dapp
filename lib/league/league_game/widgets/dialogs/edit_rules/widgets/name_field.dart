import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameField extends StatefulWidget {
  const NameField({
    super.key,
    required this.textSize,
    required this.textBoxWid,
  });

  final double textSize;
  final double textBoxWid;

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  final TextEditingController leagueNameController = TextEditingController();

  @override
  void dispose() {
    leagueNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final league = context.read<EditRulesBloc>().state.league;
    leagueNameController.text = league.name;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Name: ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: widget.textSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          width: widget.textBoxWid,
          child: TextFormField(
            onChanged: (value) =>
                {context.read<EditRulesBloc>().add(UpdateName(name: value))},
            controller: leagueNameController,
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
              hintText: 'Enter League Name',
            ),
          ),
        ),
      ],
    );
  }
}
