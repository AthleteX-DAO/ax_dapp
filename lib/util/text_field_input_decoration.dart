import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

final kTextFieldDecoration = InputDecoration(
  hintText: '',
  labelText: '',
  hintStyle: const TextStyle(color: Colors.white),
  fillColor: secondaryOrangeColor,
  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryOrangeColor),
    borderRadius: const BorderRadius.all(Radius.circular(32)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryOrangeColor, width: 2),
    borderRadius: const BorderRadius.all(Radius.circular(32)),
  ),
);
