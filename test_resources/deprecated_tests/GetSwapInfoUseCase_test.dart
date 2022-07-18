// ignore_for_file: lines_longer_than_80_chars

/*NEEDS TO BE UPDATED
import 'dart:convert';
import 'dart:io';

import 'package:ax_dapp/repositories/usecases/GetSwapInfoUseCase.dart';
import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/service/controller/swap/axt.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'GetSwapInfoUseCase_test.mocks.dart';

@GenerateMocks([SubGraphRepo])
void main() {
  test('Get Swap Info From AX to Apt Successfully', () async {
    final subGraphRepo = MockSubGraphRepo();
    final file =
        new File('test_resources/queries/aaron_judge_ax_pair_query.json');
    final sampleQueryJson = await file.readAsString();
    final tokenAddress = "0x481bf3dbde952ce684dc500fd9edef88f6607a8c";

    when(subGraphRepo.queryPairDataForTokenAddress(
            AXT.polygonAddress, tokenAddress))
        .thenAnswer(
            (_) => Future.value(Either.left(json.decode(sampleQueryJson))));

    final GetSwapInfoUseCase useCase = GetSwapInfoUseCase(subGraphRepo);
    final result = await useCase.fetchSwapInfo(
        tokenTo: tokenAddress, tokenFrom: AXT.polygonAddress);
    print("parsed swapInfo: ${result.toString}");
    final swapInfo = result.getLeft().toNullable()!.swapInfo;

    assert(swapInfo.toReserve == double.parse("0.001045161352545184"));
    assert(swapInfo.fromReserve == double.parse("15.513558001418126905"));
    assert(swapInfo.toPrice == double.parse("0.00006737083475303625426381299875812279"));
  });
}*/
