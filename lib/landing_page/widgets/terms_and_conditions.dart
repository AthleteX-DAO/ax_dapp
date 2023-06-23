import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var buttonText = '';
    _width >= 768 ? buttonText = 'Start Trading' : buttonText = 'Start';
    const textSize = 14.0;
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'By clicking $buttonText, you agree to the ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: textSize,
              fontFamily: 'OpenSans',
            ),
          ),
          TextSpan(
            text: ' Terms and Conditions',
            style: TextStyle(
              color: Colors.amber[400],
              fontSize: textSize,
              fontFamily: 'OpenSans',
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(
                  Uri.parse(
                    'https://docs.google.com/document/d/1CaOmjoaxKk_pYukWFIHtYQhG4iTZ6skBC5QHGrFv5U4/edit',
                  ),
                );
              },
          ),
        ],
      ),
    );
  }
}
