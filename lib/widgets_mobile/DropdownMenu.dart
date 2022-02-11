import 'package:flutter/material.dart';

class DropdownItem extends StatefulWidget {
  const DropdownItem({ Key? key }) : super(key: key);

  @override
  _DropdownItemState createState() => _DropdownItemState();
}

class _DropdownItemState extends State<DropdownItem> {
  var dropdownItems;
  String selectedValue = "USA";
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedValue,
      items: dropdownItems,
      onChanged:
      );
  }
}