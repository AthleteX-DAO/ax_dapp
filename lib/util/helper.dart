const kDecimals = 18;

BigInt days(int x) {
  return BigInt.from(60 * 60 * 24 * x);
}

Future<DateTime> now() async {
  return DateTime.now();
}
