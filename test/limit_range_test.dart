import 'package:ax_dapp/util/limit_range.dart';
import 'package:flutter/services.dart';
import 'package:test/test.dart';

void main() {
  test('LimitRange formatter sets value within the specified range', () {
    final formatter = LimitRange(0, 100);
    const oldValue = TextEditingValue.empty;

    final newValue1 = formatter.formatEditUpdate(
      oldValue,
      const TextEditingValue(text: '42'),
    );
    final newValue2 = formatter.formatEditUpdate(
      oldValue,
      const TextEditingValue(text: '-5'),
    );
    final newValue3 = formatter.formatEditUpdate(
      oldValue,
      const TextEditingValue(text: '150'),
    );

    expect(newValue1.text, '42');
    expect(newValue2.text, '0');
    expect(newValue3.text, '100');
  });
}
