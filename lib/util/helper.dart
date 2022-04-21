
const DECIMALS = 18;

BigInt days(x) {
  return new BigInt.from(60 * 60 * 24 * x);
}

Future<DateTime> now() async {
  return DateTime.now();
}
