import 'package:ax_dapp/pages/pool/models/PoolEvent.dart';
import 'package:ax_dapp/pages/pool/models/PoolState.dart';
import 'package:ax_dapp/repositories/usecases/GetPairInfoUseCase.dart';
import 'package:ax_dapp/service/Controller/Pool/PoolController.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PoolBloc extends Bloc<PoolEvent, PoolState> {
  final GetPairInfoUseCase _repo;
  final WalletController _walletController;
  final PoolController _poolController;

  PoolBloc(this._repo, this._walletController, this._poolController) : super(PoolState()) {
    on<Token0SelectionChanged>(_mapToken0SelectionChangedEventToState);
    on<Token1SelectionChanged>(_mapToken1SelectionChangedEventToState);
    on<MaxToken0InputButtonClicked>(_mapMaxToken0InputButtonClickedEventToState);
    on<MaxToken1InputButtonClicked>(_mapMaxToken1InputButtonClickedEventToState);
    on<Token0InputChanged>(_mapToken0InputChangedEventToState);
    on<Token1InputChanged>(_mapToken1InputChangedEventToState);
    on<AddLiquidityButtonClicked>(_mapAddLiquidityButtonClickedEventToState);
  }

  get initialState => PoolState();

  void _mapToken0SelectionChangedEventToState(
      Token0SelectionChanged event, Emitter<PoolState> emit) {}

  void _mapToken1SelectionChangedEventToState(
      Token1SelectionChanged event, Emitter<PoolState> emit) {}

  void _mapMaxToken0InputButtonClickedEventToState(
      MaxToken0InputButtonClicked event, Emitter<PoolState> emit) {}

  void _mapMaxToken1InputButtonClickedEventToState(
      MaxToken1InputButtonClicked event, Emitter<PoolState> emit) {}

  void _mapToken0InputChangedEventToState(
      Token0InputChanged event, Emitter<PoolState> emit) {}

  void _mapToken1InputChangedEventToState(
      Token1InputChanged event, Emitter<PoolState> emit) {}

  void _mapAddLiquidityButtonClickedEventToState(
      AddLiquidityButtonClicked event, Emitter<PoolState> emit) {}
}
