import 'package:ax_dapp/util/debouncer.dart';
import 'package:test/test.dart';

void main() {
  test('Debouncer runs action after specified milliseconds', () async {
    final debouncer = Debouncer(milliseconds: 500);
    var counter = 0;
    debouncer.run(() {
      counter++;
    });
    expect(counter, 0);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    expect(counter, 1);
    debouncer.dispose();
  });

  test('Debouncer cancels previous action and runs new action', () async {
    final debouncer = Debouncer(milliseconds: 500);
    var counter = 0;
    debouncer.run(() {
      counter++;
    });
    expect(counter, 0);
    debouncer.run(() {
      counter++;
    });
    await Future<void>.delayed(const Duration(milliseconds: 600));
    expect(counter, 1);
    debouncer.dispose();
  });

  test('Debouncer cancels action on dispose', () async {
    final debouncer = Debouncer(milliseconds: 500);
    var counter = 0;
    debouncer.run(() {
      counter++;
    });
    expect(counter, 0);
    debouncer.dispose();
    await Future<void>.delayed(const Duration(milliseconds: 600));
    expect(counter, 0);
  });
}
