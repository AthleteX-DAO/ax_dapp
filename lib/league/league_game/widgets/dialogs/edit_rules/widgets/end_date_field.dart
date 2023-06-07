import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:league_repository/league_repository.dart';

class EndDateField extends StatefulWidget {
  const EndDateField({
    super.key,
    required this.textSize,
    required this.textBoxWid,
    required this.league,
  });

  final double textSize;
  final double textBoxWid;
  final League league;

  @override
  State<EndDateField> createState() => _EndDateFieldState();
}

class _EndDateFieldState extends State<EndDateField> {
  final TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    endDateController.text = widget.league.dateEnd;
    super.initState();
  }

  @override
  void dispose() {
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'End-Date: ',
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
            enabled: widget.league.dateStart.isNotEmpty,
            controller: endDateController,
            readOnly: true,
            onTap: () async {
              final leagueEndDate =
                  DateTime.parse(widget.league.dateStart).add(const Duration(days: 1));
              final endDate = await showDatePicker(
                context: context,
                initialDate: leagueEndDate,
                firstDate: leagueEndDate,
                lastDate: DateTime(2101),
              );
              if (endDate != null) {
                final formattedDate = DateFormat('yyyy-MM-dd').format(endDate);
                if (context.mounted) {
                  context
                      .read<EditRulesBloc>()
                      .add(UpdateEndDate(endDate: formattedDate));
                }
                setState(() {
                  endDateController.text = formattedDate;
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
              hintText: 'Enter End-Date',
            ),
          ),
        ),
      ],
    );
  }
}
