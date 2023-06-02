import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:league_repository/league_repository.dart';

class StartDateField extends StatefulWidget {
  const StartDateField({
    super.key,
    required this.textSize,
    required this.textBoxWid,
    required this.league,
  });

  final double textSize;
  final double textBoxWid;
  final League league;

  @override
  State<StartDateField> createState() => _StartDateFieldState();
}

class _StartDateFieldState extends State<StartDateField> {
  final TextEditingController startDateController = TextEditingController();

  @override
  void initState() {
    startDateController.text = widget.league.dateStart;
    super.initState();
  }

  @override
  void dispose() {
    startDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Start-Date: ',
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
            controller: startDateController,
            readOnly: true,
            onTap: () async {
              final leagueStartDate = DateTime.parse(startDateController.text);
              final startDate = await showDatePicker(
                context: context,
                initialDate: leagueStartDate,
                firstDate: DateTime.now().add(const Duration(days: 1)),
                lastDate: DateTime(2101),
              );
              if (startDate != null) {
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(startDate);
                if (context.mounted) {
                  context
                      .read<EditRulesBloc>()
                      .add(UpdateStartDate(startDate: formattedDate));
                }
                setState(() {
                  startDateController.text = formattedDate;
                });
              }
            },
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
              hintText: 'Enter Start-Date',
            ),
          ),
        ),
      ],
    );
  }
}
