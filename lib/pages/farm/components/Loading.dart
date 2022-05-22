import 'package:flutter/material.dart';

Widget loading() {
  return Center(
    child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          color: Colors.amber,
        )),
  );
}
