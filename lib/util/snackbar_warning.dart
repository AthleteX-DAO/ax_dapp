import 'package:flutter/material.dart';

extension SnackBarWarning on BuildContext {
  SnackBar showSnackBarWarning({required String warningMessage}) => SnackBar(
        backgroundColor: Colors.transparent,
        content: Text(
          warningMessage,
          style: const TextStyle(
            color: Colors.amber,
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        duration: const Duration(seconds: 2),
      );
}
