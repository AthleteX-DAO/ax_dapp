import 'dart:convert';
import 'dart:io';

import 'package:ax_dapp/dialogs/buy/usecases/GetAPTBuyInfoUseCase.dart';
import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'GetAPTBuyInfoUseCase_test.mocks.dart';

@GenerateMocks([SubGraphRepo])
void main() {
  test('Get Buy Info For APT Successfully', () async {
    final subGraphRepo = MockSubGraphRepo();
    final file =
        new File('test_resources/queries/aaron_judge_ax_pair_query.json');
    final sampleQueryJson = await file.readAsString();
    final tokenAddress = "0x481bf3dbde952ce684dc500fd9edef88f6607a8c";

    when(subGraphRepo.queryPairDataForTokenAddress(AXT.polygonAddress, tokenAddress)).thenAnswer(
        (_) => Future.value(Either.left(json.decode(sampleQueryJson))));
    

    final GetAPTBuyInfoUseCase useCase = GetAPTBuyInfoUseCase(subGraphRepo);
    final result = await useCase.fetchAptBuyInfo(tokenAddress);
    final buyAptInfo = result.getLeft().toNullable()!.aptBuyInfo;
    print(buyAptInfo);

    assert(buyAptInfo.aptLiquidity == double.parse("0.001045161352545184"));
    assert(buyAptInfo.axLiquidity == double.parse("15.513558001418128"));
  });
}
