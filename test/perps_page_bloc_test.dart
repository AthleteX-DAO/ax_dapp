import 'package:ax_dapp/perps/bloc/perps_page_bloc.dart';
import 'package:ax_dapp/service/controller/perps/perps_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubPerpsRepository extends PerpsRepository {
  _StubPerpsRepository() : super(web3Client: throw UnimplementedError());

  @override
  Future<PerpsMarketData> getMarketData(String symbol) async => PerpsMarketData(
        symbol: symbol,
        price: BigInt.zero,
        fundingRate: BigInt.zero,
        openInterest: BigInt.zero,
        skew: BigInt.zero,
        makerFee: BigInt.zero,
        takerFee: BigInt.zero,
        timestamp: DateTime.now(),
      );
}

void main() {
  test('PerpsPageBloc has initial state', () {
    final bloc = PerpsPageBloc(perpsRepository: _StubPerpsRepository());
    expect(bloc.state, const PerpsPageInitial());
    bloc.close();
  });
}
