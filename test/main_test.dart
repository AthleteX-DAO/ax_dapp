import 'package:ax_dapp/main.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  test('Testing dapp launch', () {
    final theDapp = MyApp();
    
    expect(theDapp.runtimeType, StatelessWidget);
  });
}
