import 'package:flutter/material.dart';

class MobileMarketBookText extends StatelessWidget {
  const MobileMarketBookText({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (title == 'Market Price')
          const Align(
            child: Text(
              'Market Price',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontFamily: 'OpenSans',
              ),
              textAlign: TextAlign.justify,
            ),
          )
        else
          const Align(
            child: Text(
              'Book Value',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontFamily: 'OpenSans',
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        Container(
          margin: const EdgeInsets.only(left: 2),
          child: const Align(
            child: Icon(
              Icons.autorenew,
              size: 10,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
