import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ae_dapp/swapFiles/currency_provider.dart';
import 'package:ae_dapp/swapFiles/unit.dart';

class CurrencyProviderImpl implements CurrencyProvider {
  http.Client httpClient;

  // We are going to use a free API for currency conversion
  // See: https://free.currencyconverterapi.com/
  final String _url = 'free.currencyconverterapi.com';

  CurrencyProviderImpl({required this.httpClient}) {
    this.httpClient = null == this.httpClient ? http.Client() : this.httpClient;
  }

  @override
  Future<double> convert(Unit from, Unit to, double value) async {
    final String query = '${from.name}_${to.name}';
    final queryParams = {'q': query, 'compact': 'ultra'};

    final jsonResponse = await this
        ._fetchJson(Uri.https(this._url, '/api/v6/convert', queryParams));

    return value * double.parse(jsonResponse[query].toString());
  }

  @override
  Future<List<Unit>> getUnits() async {
    final jsonResponse =
        await this._fetchJson(Uri.https(this._url, '/api/v6/currencies'));

    final units = jsonResponse['results']
        .keys
        .map((unit) => Unit(name: unit, conversion: 1.0))
        .toList()
        .cast<Unit>();
    units.sort();

    return units;
  }

  /// Fetches and decodes a JSON object from the external API
  Future<Map<String, dynamic>> _fetchJson(Uri uri) async {
    final response = await this.httpClient.get(uri);

    if (response.statusCode != 200) {
      final String message = '${response.statusCode} - ${response.body}';
      throw Exception('Unsuccessful response: $message');
    }

    return json.decode(response.body);
  }
}