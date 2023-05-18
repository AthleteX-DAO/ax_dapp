import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:league_repository/league_repository.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:tokens_repository/tokens_repository.dart';

class EditRulesDialog extends StatefulWidget {
  const EditRulesDialog({
    super.key,
    required this.league,
  });

  final League league;

  @override
  State<EditRulesDialog> createState() => _EditRulesDialog();
}

class _EditRulesDialog extends State<EditRulesDialog> {
  final TextEditingController leagueNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController teamSizeController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();
  late List<bool> _private;
  late List<bool> _lock;

  bool vertical = false;
  List<SupportedSport> selectedSports = <SupportedSport>[];
  final supportedSports = [
    SupportedSport.MLB,
    SupportedSport.NFL,
  ];
  late SupportedSport dropDownValue;
  late bool _privateToggle;
  late bool _lockToggle;

  @override
  void initState() {
    leagueNameController.text = widget.league.name;
    startDateController.text = widget.league.dateStart;
    endDateController.text = widget.league.dateEnd;
    teamSizeController.text = widget.league.teamSize.toString();
    participantsController.text = widget.league.maxTeams.toString();
    dropDownValue = widget.league.sports.first;
    _privateToggle = widget.league.isPrivate;
    _lockToggle = widget.league.isLocked;
    _private = widget.league.isPrivate ? [false, true] : [true, false];
    _lock = widget.league.isLocked ? [false, true] : [true, false];
    super.initState();
  }

  @override
  void dispose() {
    leagueNameController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    teamSizeController.dispose();
    participantsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LeagueGameBloc>();
    final walletAddress =
        context.read<WalletBloc>().state.formattedWalletAddress;
    final walletId = (walletAddress.isEmpty || walletAddress == kEmptyAddress)
        ? ''
        : walletAddress;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name: ',
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
                      controller: leagueNameController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400]!,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 20,
                            color: Colors.grey[400]!,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: 'Enter League Name',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start-Date: ',
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
                      controller: startDateController,
                      readOnly: true,
                      onTap: () async {
                        final leagueStartDate =
                            DateTime.parse(startDateController.text);
                        final startDate = await showDatePicker(
                          context: context,
                          initialDate: leagueStartDate,
                          firstDate:
                              DateTime.now().add(const Duration(days: 1)),
                          lastDate: DateTime(2101),
                        );
                        if (startDate != null) {
                          final formattedDate =
                              DateFormat('yyyy-MM-dd').format(startDate);
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 20,
                            color: Colors.grey[400]!,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: 'Enter Start-Date',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'End-Date: ',
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
                      enabled: startDateController.text.isNotEmpty,
                      controller: endDateController,
                      readOnly: true,
                      onTap: () async {
                        final leagueEndDate =
                            DateTime.parse(startDateController.text)
                                .add(const Duration(days: 1));
                        final endDate = await showDatePicker(
                          context: context,
                          initialDate: leagueEndDate,
                          firstDate: leagueEndDate,
                          lastDate: DateTime(2101),
                        );
                        if (endDate != null) {
                          final formattedDate =
                              DateFormat('yyyy-MM-dd').format(endDate);
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 20,
                            color: Colors.grey[400]!,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: 'Enter End-Date',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Team Size: ',
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 20,
                            color: Colors.grey[400]!,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: 'Enter Team Size',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Participants: ',
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 20,
                            color: Colors.grey[400]!,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: 'Enter Participants',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
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
                      initialValue: widget.league.entryFee.toString(),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400]!,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 20,
                            color: Colors.grey[400]!,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: 'Enter Fee',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sport(s): ',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: textSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  MultiSelectDialogField(
                    initialValue: widget.league.sports,
                    chipDisplay: MultiSelectChipDisplay<SupportedSport>(
                      chipColor: Colors.transparent,
                      textStyle: TextStyle(
                        color: Colors.amber[400],
                        fontFamily: 'OpenSans',
                        fontSize: textSize,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: Colors.amber,
                          width: 2,
                        ),
                      ),
                    ),
                    dialogWidth: _width / 2,
                    dialogHeight: _height / 2,
                    items: supportedSports
                        .map(
                          (supportedSport) => MultiSelectItem(
                            supportedSport,
                            supportedSport.name,
                          ),
                        )
                        .toList(),
                    itemsTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: textSize,
                      fontWeight: FontWeight.w400,
                    ),
                    unselectedColor: Colors.white,
                    title: Text(
                      'Sports',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: textSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    selectedItemsTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: textSize,
                      fontWeight: FontWeight.w400,
                    ),
                    selectedColor: Colors.amber[400],
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      border: Border.all(
                        color: Colors.amber,
                        width: 2,
                      ),
                    ),
                    buttonIcon: Icon(
                      Icons.sports,
                      color: Colors.amber[400],
                    ),
                    buttonText: Text(
                      'Choose Sports',
                      style: TextStyle(
                        color: Colors.amber[400],
                        fontFamily: 'OpenSans',
                        fontSize: textSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onConfirm: (results) {
                      selectedSports = results as List<SupportedSport>;
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Private: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: textSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 145,
                    height: 25,
                    child: ToggleButtons(
                      direction: vertical ? Axis.vertical : Axis.horizontal,
                      onPressed: (int index) {
                        setState(() {
                          for (var i = 0; i < _private.length; i++) {
                            _private[i] = i == index;
                            _privateToggle = _private[i];
                          }
                        });
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
                            fontSize: textSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: textSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lock: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: textSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 145,
                    height: 25,
                    child: ToggleButtons(
                      direction: vertical ? Axis.vertical : Axis.horizontal,
                      onPressed: (int index) {
                        setState(() {
                          for (var i = 0; i < _lock.length; i++) {
                            _lock[i] = i == index;
                            _lockToggle = _lock[i];
                          }
                        });
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
                            fontSize: textSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: textSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                        if (DateTime.parse(startDateController.text).isAfter(
                              DateTime.parse(
                                endDateController.text,
                              ),
                            ) ||
                            DateTime.parse(startDateController.text) ==
                                DateTime.parse(endDateController.text))
                          {
                            context.showWarningToast(
                              title: 'Error',
                              description:
                                  'Cannot have a start date that is after the end date!',
                            )
                          }
                        else
                          {
                            bloc.add(
                              EditLeagueEvent(
                                leagueID: widget.league.leagueID,
                                name: leagueNameController.text,
                                adminWallet: walletId,
                                dateStart: startDateController.text,
                                dateEnd: endDateController.text,
                                teamSize: int.parse(teamSizeController.text),
                                maxTeams:
                                    int.parse(participantsController.text),
                                entryFee: widget.league.entryFee,
                                isPrivate: _privateToggle,
                                isLocked: _lockToggle,
                                sports: selectedSports.isEmpty
                                    ? widget.league.sports
                                    : selectedSports,
                                prizePoolAddress:
                                    widget.league.prizePoolAddress,
                              ),
                            ),
                            Navigator.pop(context),
                          }
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
