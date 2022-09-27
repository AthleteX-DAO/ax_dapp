import 'package:flutter/material.dart';

class NoResultFound extends StatelessWidget {
  const NoResultFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 70,
      width: 400,
      child: Text(
        'No Result Found',
        style: TextStyle(color: Colors.yellow, fontSize: 30),
      ),
    );
  }
}
