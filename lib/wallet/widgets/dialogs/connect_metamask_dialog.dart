import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectMetaMaskDialog extends StatelessWidget {
  const ConnectMetaMaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          constraints: const BoxConstraints(minHeight: 235, maxHeight: 250),
          height: constraints.maxHeight * 0.26,
          width: constraints.maxWidth * 0.27,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(30),
            border: Border.all(width: 0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Metamask wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Couldn't find MetaMask extension",
                    style: TextStyle(color: Colors.grey[400]),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 40),
                    width: constraints.maxWidth < 450
                        ? constraints.maxWidth * 0.62
                        : constraints.maxWidth * 0.22,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.purple[900]!, width: 2),
                    ),
                    child: TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse('https://metamask.io/download/'));
                        Navigator.pop(context);
                      },
                      child: const AutoSizeText(
                        'Install MetaMask extension',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
