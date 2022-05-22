import 'package:flutter/material.dart';

Widget noData(height, width) {
  return Center(
    child: SizedBox(
      height: height,
      width: width,
      child: Text("No Farms to Display.",
          style: TextStyle(color: Colors.amber, fontSize: 30)),
    ),
  );
}
