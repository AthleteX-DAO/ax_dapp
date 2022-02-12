import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DropdownMenu extends StatefulWidget {
  const DropdownMenu();

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  String? dropdownValue = "";
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_horiz),
      onSelected: (String? newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
    );
  }
}
