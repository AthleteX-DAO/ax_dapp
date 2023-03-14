import 'package:ax_dapp/pages/league/league_search/bloc/league_bloc.dart';
import 'package:ax_dapp/pages/league/models/league.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final items = [
    'MLB',
    'NFL',
    'NBA',
  ];
  String dropDownValue = 'MLB';

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

    var wid = 450.0;
    if (_width < 500) wid = _width;

    var textBoxWid = 250.0;
    var participantsWid = 250.0;
    if (_width < 500) textBoxWid = _width * 0.5;
    if (_width < 500) participantsWid = _width * 0.475;
    if (_width < 385) textBoxWid = _width * 0.45;
    if (_width < 385) participantsWid = _width * 0.425;

    var hgt = 550.0;
    if (_height < 505) hgt = _height;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        height: hgt,
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
                  const Text('Name: '),
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
                  const Text('Start-Date: '),
                  SizedBox(
                    width: textBoxWid,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp('[0-9/]'),
                        ),
                      ],
                      controller: startDateController,
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
                  const Text('End-Date: '),
                  SizedBox(
                    width: textBoxWid,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp('[0-9/]'),
                        ),
                      ],
                      controller: endDateController,
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
                  const Text('Team Size: '),
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
                  const Text('Participants: '),
                  SizedBox(
                    width: participantsWid,
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
                        hintText: 'Enter Number',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Entry Fee: '),
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
                  const Text('Sport(s): '),
                  DropdownButton<String>(
                    value: dropDownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map<DropdownMenuItem<String>>((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownValue = newValue!;
                      });
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Private: '),
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
                      children: const <Widget>[
                        Text('No'),
                        Text('Yes'),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Lock: '),
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
                      children: const <Widget>[
                        Text('No'),
                        Text('Yes'),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.amber[400]!),
                      ),
                      child: TextButton(
                        onPressed: () => {
                          bloc.add(
                            CreateLeague(
                              league: League(
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
                                rosters: {},
                                sports: [SupportedSport.MLB],
                              ),
                            ),
                          ),
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
