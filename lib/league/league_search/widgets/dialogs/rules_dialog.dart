import 'package:ax_dapp/league/league_search/bloc/league_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:tokens_repository/tokens_repository.dart';

class LeagueDialog extends StatefulWidget {
  const LeagueDialog({super.key});

  @override
  State<LeagueDialog> createState() => _LeagueDialog();
}

class _LeagueDialog extends State<LeagueDialog> {
  final TextEditingController leagueNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController teamSizeController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();
  final TextEditingController entryFeeController = TextEditingController();
  final List<bool> _private = <bool>[true, false];
  final List<bool> _lock = <bool>[true, false];
  var _privateToggle = false;
  var _lockToggle = false;
  bool vertical = false;
  List<SupportedSport> selectedSports = <SupportedSport>[];
  final supportedSports = [
    SupportedSport.MLB,
    SupportedSport.NFL,
  ];
  SupportedSport dropDownValue = SupportedSport.MLB;

  @override
  void dispose() {
    leagueNameController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    teamSizeController.dispose();
    participantsController.dispose();
    entryFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LeagueBloc>();
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
                      'Create League',
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
                            DateTime.now().add(const Duration(days: 1));
                        final startDate = await showDatePicker(
                          context: context,
                          initialDate: leagueStartDate,
                          firstDate: leagueStartDate,
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
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp('[0-9.]'),
                        ),
                      ],
                      controller: entryFeeController,
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
                              title: 'Date Range Error',
                              description:
                                  'Cannot have a start date that is after the end date!',
                            ),
                          }
                        else if (selectedSports.isEmpty)
                          {
                            context.showWarningToast(
                              title: 'Selected Sports Error',
                              description: 'Select At Least One Sport!',
                            ),
                          }
                        else
                          {
                            bloc.add(
                              CreateLeague(
                                name: leagueNameController.text,
                                adminWallet: walletId,
                                dateStart: startDateController.text,
                                dateEnd: endDateController.text,
                                teamSize: int.parse(teamSizeController.text),
                                maxTeams:
                                    int.parse(participantsController.text),
                                entryFee: int.parse(entryFeeController.text),
                                isPrivate: _privateToggle,
                                isLocked: _lockToggle,
                                sports: selectedSports,
                              ),
                            ),
                            Navigator.pop(context),
                          },
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
