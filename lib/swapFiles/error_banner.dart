import 'package:flutter/material.dart';

/// An error banner to be displayed when errors occur calling an external API
class ErrorBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Provided by Udacity
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Color(0xFF912D2D),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: 180.0,
              color: Colors.white,
            ),
            Text(
              "Oh no! Can't connect right now!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}