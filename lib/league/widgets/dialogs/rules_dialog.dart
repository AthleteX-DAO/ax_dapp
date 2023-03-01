import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool vertical = false;

  @override
  void initState() {
    super.initState();
    leagueNameController.addListener(() {
      final text = leagueNameController.text.toLowerCase();
      leagueNameController.value = leagueNameController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
      startDateController.value = startDateController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
      endDateController.value = endDateController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
      teamSizeController.value = teamSizeController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
      participantsController.value = participantsController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
      entryFeeController.value = entryFeeController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

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

    var dropdownvalue = 'MLB';
    final items = [
      'MLB',
      'NFL',
      'NBA',
    ];
    const privateToggle = <Widget>[
      Text('No'),
      Text('Yes'),
    ];
    const lockToggle = <Widget>[
      Text('No'),
      Text('Yes'),
    ];

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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
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
                  DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
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
                      children: privateToggle,
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
                      children: lockToggle,
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
                        onPressed: () => {},
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
