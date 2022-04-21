import 'dart:convert';
import 'dart:io';

import 'package:ax_dapp/dialogs/buy/usecases/GetAPTBuyInfoUseCase.dart';
import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'GetAPTBuyInfoUseCase_test.mocks.dart';

@GenerateMocks([SubGraphRepo])
void main() {
  test('Get Buy Info For APT Successfully', () async {
    final subGraphRepo = MockSubGraphRepo();
    final file = new File('test_resources/queries/aaron_judge_mlb_pair_query.json');
    final sampleQueryJson = await file.readAsString();

    when(subGraphRepo.queryAllPairs()).thenAnswer((_) => Future.value(Either.left(json.decode(sampleQueryJson))));
    final tokenAddress = "0x481bf3dbde952ce684dc500fd9edef88f6607a8c";


    final GetAPTBuyInfoUseCase useCase = GetAPTBuyInfoUseCase(subGraphRepo);
    final result = await useCase.fetchAptBuyInfo(tokenAddress);
    final buyAptInfo = result.getLeft().toNullable()!.aptBuyInfo;

    assert(buyAptInfo.aptLiquidity == double.parse("0.000936894635175985"));
    assert(buyAptInfo.axLiquidity == double.parse("17"));
  });
}
