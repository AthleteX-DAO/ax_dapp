// ignore_for_file: prefer_asserts_with_message

import 'dart:convert';
import 'dart:io';

import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pair_info_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_pair_info_use_case_test.mocks.dart';

@GenerateMocks([SubGraphRepo])
void main() {
  test('Get Token Pair Info Successfully', () async {
    final subGraphRepo = MockSubGraphRepo();
    final file = File('test_resources/queries/aaron_judge_ax_pair_query.json');
    final sampleQueryJson = await file.readAsString();
    const tokenAddressA = '0x481bf3dbde952ce684dc500fd9edef88f6607a8c';
    const tokenAddressB = '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df';
    const fromTokenInput = 0.109;

    when(
      subGraphRepo.queryPairDataForTokenAddress(
        tokenAddressA.toLowerCase(),
        tokenAddressB.toLowerCase(),
      ),
    ).thenAnswer(
      (_) => Future.value(
        Either.left(json.decode(sampleQueryJson) as Map<String, dynamic>),
      ),
    );

    final useCase = GetPairInfoUseCase(subGraphRepo);
    final result = await useCase.fetchPairInfo(
      tokenA: tokenAddressA,
      tokenB: tokenAddressB,
      fromTokenInput: fromTokenInput,
    );

    assert(result.isLeft());
    final pairInfo = result.getLeft().toNullable()!.pairInfo;
    assert(pairInfo.id == '0x3f6d3b85ad9d950d8bff406ca54bcdfb0c932db4');
    assert(pairInfo.name == 'AJLT1010-AX');
    assert(pairInfo.reserve0 == '0.001045161352545184');
    assert(pairInfo.reserve1 == '15.513558001418126905');
    assert(pairInfo.token0Price == '0.00006737083475303625426381299875812279');
    assert(pairInfo.token1Price == '14843.21819175518254175374690008297');
    assert(pairInfo.token0.id == '0x481bf3dbde952ce684dc500fd9edef88f6607a8c');
    assert(pairInfo.token0.name == 'Aaron Judge Linear Long Token');
    assert(pairInfo.token1.id == '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df');
    assert(pairInfo.token1.name == 'AthleteX');
  });
}
