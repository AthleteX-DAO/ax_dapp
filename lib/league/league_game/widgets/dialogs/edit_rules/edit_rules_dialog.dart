import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class EditRulesDialog extends StatefulWidget {
  const EditRulesDialog({
    super.key,
  });

  @override
  State<EditRulesDialog> createState() => _EditRulesDialog();
}

class _EditRulesDialog extends State<EditRulesDialog> {
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

    var textSize = 16.0;
    if (_width <= 768) textSize = 12.0;

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
              SizedBox(
                width: wid,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit League',
                      style: textStyle(
                        Colors.white,
                        20,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              NameField(textSize: textSize, textBoxWid: textBoxWid),
              StartDateField(
                textSize: textSize,
                textBoxWid: textBoxWid,
                league: league,
              ),
              EndDateField(
                textSize: textSize,
                textBoxWid: textBoxWid,
                league: league,
              ),
              TeamSizeField(textSize: textSize, textBoxWid: textBoxWid),
              ParticipantsField(textSize: textSize, textBoxWid: textBoxWid),
              EntryFeeField(textSize: textSize, textBoxWid: textBoxWid),
              SportSelection(textSize: textSize),
              PrivateToggle(league: league, textSize: textSize),
              LockToggle(league: league, textSize: textSize),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(color: Colors.amber[400]!),
                          ),
                        ),
                      ),
                      onPressed: () => {
                        // if (DateTime.parse(startDateController.text).isAfter(
                        //       DateTime.parse(
                        //         endDateController.text,
                        //       ),
                        //     ) ||
                        //     DateTime.parse(startDateController.text) ==
                        //         DateTime.parse(endDateController.text))
                        //   {
                        //     context.showWarningToast(
                        //       title: 'Date Range Error',
                        //       description:
                        //           'Cannot have a start date that is after the end date!',
                        //     )
                        //   }
                        // else if (selectedSports.isEmpty)
                        //   {
                        //     context.showWarningToast(
                        //       title: 'Selected Sports Error',
                        //       description: 'Select At Least One Sport!',
                        //     )
                        //   }
                        // else
                        //   {
                        //     bloc.add(
                        //       EditLeagueEvent(
                        //         leagueID: league.leagueID,
                        //         name: leagueNameController.text,
                        //         adminWallet: walletId,
                        //         dateStart: startDateController.text,
                        //         dateEnd: endDateController.text,
                        //         teamSize: int.parse(teamSizeController.text),
                        //         maxTeams:
                        //             int.parse(participantsController.text),
                        //         entryFee: league.entryFee,
                        //         isPrivate: _privateToggle,
                        //         isLocked: _lockToggle,
                        //         sports: selectedSports.isEmpty
                        //             ? league.sports
                        //             : selectedSports,
                        //         prizePoolAddress: league.prizePoolAddress,
                        //       ),
                        //     ),
                        //     Navigator.pop(context),
                        //   }
                        context.read<EditRulesBloc>().add(UpdateLeague()),
                        Navigator.pop(context),
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.amber,
                          fontFamily: 'OpenSans',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
