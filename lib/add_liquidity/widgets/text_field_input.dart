import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WebTextField extends StatelessWidget {
  const WebTextField({
    super.key,
    required this.elementWdt,
    required this.textInputFontSize,
    required TextEditingController tokenAmountOneController,
    required this.tokenInputChanged,
  }) : _tokenAmountOneController = tokenAmountOneController;

  final double elementWdt;
  final double textInputFontSize;
  final TextEditingController _tokenAmountOneController;
  final void Function(int, String) tokenInputChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: elementWdt * 0.5,
      ),
      child: IntrinsicWidth(
        child: TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: _tokenAmountOneController,
          onChanged: (tokenInput) {
            tokenInputChanged(
              1,
              tokenInput,
            );
          },
          style: textStyle(
            Colors.grey[400]!,
            textInputFontSize,
            isBold: false,
            isUline: false,
          ),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: textStyle(
              Colors.grey[400]!,
              textInputFontSize,
              isBold: false,
              isUline: false,
            ),
            contentPadding: const EdgeInsets.all(9),
            border: InputBorder.none,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^(\d+)?\.?\d{0,6}'),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileTextField extends StatelessWidget {
  const MobileTextField({
    super.key,
    required this.textInputFontSize,
    required TextEditingController tokenAmountOneController,
    required this.tokenInputChanged,
  }) : _tokenAmountOneController = tokenAmountOneController;

  final double textInputFontSize;
  final TextEditingController _tokenAmountOneController;
  final void Function(int, String) tokenInputChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: _tokenAmountOneController,
        onChanged: (tokenInput) {
          tokenInputChanged(
            1,
            tokenInput,
          );
        },
        style: textStyle(
          Colors.grey[400]!,
          textInputFontSize,
          isBold: false,
          isUline: false,
        ),
        decoration: InputDecoration(
          hintText: '0.00',
          hintStyle: textStyle(
            Colors.grey[400]!,
            textInputFontSize,
            isBold: false,
            isUline: false,
          ),
          contentPadding: const EdgeInsets.all(9),
          border: InputBorder.none,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'^(\d+)?\.?\d{0,6}'),
          ),
        ],
      ),
    );
  }
}
