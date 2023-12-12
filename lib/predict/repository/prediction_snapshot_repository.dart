import 'dart:convert';

import 'package:ax_dapp/predict/predict.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class PredictionSnapshotRepository {
  Future<List<PredictionModel>> fetchCurrentMarkets() async {
    final predictions = <PredictionModel>[];
    try {
      final url = Uri.parse('https://hub.snapshot.org/graphql');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'query': '''
        query Proposals {
          proposals(where: {space_in: ["athletex.eth"], state: "done"}, orderBy: "created", orderDirection: desc) {
            id
            title
            body
          }
        }
      '''
      });
      final response = await http.post(url, headers: headers, body: body);
      final result = jsonDecode(response.body);
      final proposalsData = result['data']['proposals'];
      final proposalList =
          List<Map<String, dynamic>>.from(proposalsData as Iterable<dynamic>);
      final proposalMap = proposalList
          .map(
            (proposal) => {
              'id': proposal['id'] as String,
              'title': proposal['title'] as String,
              'body': proposal['body'] as String,
            },
          )
          .toList();
      for (final proposal in proposalMap) {
        final id = proposal['id'] as int;
        final title = proposal['title'] as String;
        final body = proposal['body'] as String;
        predictions.add(
          PredictionModel(
            id: id,
            prompt: title,
            details: body,
            marketAddress: '',
            yesTokenAddress: '',
            noTokenAddress: '',
            yesName: '',
            noName: '',
            time: '',
            longTokenPrice: 0,
            shortTokenPrice: 0,
            longTokenPercentage: 0,
            shortTokenPercentage: 0,
            longTokenPriceUsd: 0,
            shortTokenPriceUsd: 0,
            supportedPredictionMarkets: SupportedPredictionMarkets.voted,
          ),
        );
      }
      return predictions;
    } catch (e) {
      debugPrint('$e');
      return [];
    }
  }
}
