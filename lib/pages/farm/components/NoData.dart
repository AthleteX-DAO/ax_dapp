import 'package:flutter/material.dart';

Widget noData() {
  return Center(
    child: SizedBox(
      height: 70,
      width: 400,
      child: Text("No Farms to Display.",
          style: TextStyle(color: Colors.amber, fontSize: 30)),
    ),
  );
}
