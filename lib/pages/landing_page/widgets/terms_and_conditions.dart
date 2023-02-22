import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    var buttonText = '';
    isWeb ? buttonText = 'Start Trading' : buttonText = 'Start';
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'By clicking $buttonText, you agree to the ',
            style: TextStyle(
              color: Colors.white,
              fontSize: isWeb ? 14 : 12,
              fontFamily: 'OpenSans',
            ),
          ),
          TextSpan(
            text: ' Terms and Conditions',
            style: TextStyle(
              color: Colors.amber[400],
              fontSize: isWeb ? 14 : 12,
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
