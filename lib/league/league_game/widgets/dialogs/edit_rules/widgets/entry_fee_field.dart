import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntryFeeField extends StatelessWidget {
  const EntryFeeField({
    super.key,
    required this.textSize,
    required this.textBoxWid,
  });

  final double textSize;
  final double textBoxWid;

  @override
  Widget build(BuildContext context) {
    final league = context.read<EditRulesBloc>().state.league;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Entry Fee: ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: textSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          width: textBoxWid,
          child: TextFormField(
            readOnly: true,
            initialValue: league.entryFee.toString(),
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
              hintText: 'Enter Fee',
            ),
          ),
        ),
      ],
    );
  }
}
