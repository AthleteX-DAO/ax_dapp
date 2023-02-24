import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';

const List<String> list = <String>['MLB', 'NFL', 'NBA'];

//class LeagueDialog extends StatelessWidget {
//const LeagueDialog({super.key});
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
    });
    super.initState();
    startDateController.addListener(() {
      final text = startDateController.text.toLowerCase();
      startDateController.value = startDateController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    super.initState();
    endDateController.addListener(() {
      final text = endDateController.text.toLowerCase();
      endDateController.value = endDateController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    super.initState();
    teamSizeController.addListener(() {
      final text = teamSizeController.text.toLowerCase();
      teamSizeController.value = teamSizeController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    super.initState();
    participantsController.addListener(() {
      final text = participantsController.text.toLowerCase();
      participantsController.value = participantsController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    super.initState();
    entryFeeController.addListener(() {
      final text = entryFeeController.text.toLowerCase();
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
    if (_width < 565) wid = _width;

    var hgt = 550.0;
    if (_height < 505) hgt = _height;

    var dropdownvalue = 'MLB';
    final items = [
      'MLB',
      'NFL',
      'MBA',
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
              //edit this to add to popup
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
                    width: 250,
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
                    width: 250,
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
                    width: 250,
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
                    width: 250,
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
                  const Text('Number of Participants: '),
                  SizedBox(
                    width: 250,
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
                    width: 250,
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
                    child: ToggleSwitch(
                      totalSwitches: 2,
                      labels: const ['No', 'Yes'],
                      onToggle: (index) {},
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Lock: '),
                  SizedBox(
                    child: ToggleSwitch(
                      totalSwitches: 2,
                      labels: const ['No', 'Yes'],
                      onToggle: (index) {},
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
