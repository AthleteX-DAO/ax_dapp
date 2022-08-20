import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';

class RemoveLiquidityState extends Equatable {
  const RemoveLiquidityState({
    required this.tokenOneRemoveAmount,
    required this.tokenTwoRemoveAmount,
    required this.lpTokenPairBalance,
    required this.shareOfPool,
    required this.percentRemoval,
    required this.lpTokenOneAmount,
    required this.lpTokenTwoAmount,
    required this.tokenOneAddress,
    required this.tokenTwoAddress,
    required this.lpTokenPairAddress,
    required this.status,
  });

  factory RemoveLiquidityState.initial() {
    return const RemoveLiquidityState(
      tokenOneRemoveAmount: 0,
      tokenTwoRemoveAmount: 0,
      lpTokenPairBalance: '',
      shareOfPool: '',
      percentRemoval: 0,
      lpTokenOneAmount: '',
      lpTokenTwoAmount: '',
      tokenOneAddress: '',
      tokenTwoAddress: '',
      lpTokenPairAddress: '',
      status: BlocStatus.initial,
    );
  }

  final double tokenOneRemoveAmount;
  final double tokenTwoRemoveAmount;
  final String lpTokenPairBalance;
  final String shareOfPool;
  final double percentRemoval;
  final String lpTokenOneAmount;
  final String lpTokenTwoAmount;
  final String tokenOneAddress;
  final String tokenTwoAddress;
  final String lpTokenPairAddress;
  final BlocStatus status;

  @override
  List<Object> get props {
    return [
      tokenOneRemoveAmount,
      tokenTwoRemoveAmount,
      lpTokenPairBalance,
      shareOfPool,
      percentRemoval,
      status,
    ];
  }

  RemoveLiquidityState copyWith({
    double? tokenOneRemoveAmount,
    double? tokenTwoRemoveAmount,
    String? lpTokenPairBalance,
    String? shareOfPool,
    double? percentRemoval,
    String? lpTokenOneAmount,
    String? lpTokenTwoAmount,
    String? tokenOneAddress,
    String? tokenTwoAddress,
    String? lpTokenPairAddress,
    BlocStatus? status,
  }) {
    return RemoveLiquidityState(
      tokenOneRemoveAmount: tokenOneRemoveAmount ?? this.tokenOneRemoveAmount,
      tokenTwoRemoveAmount: tokenTwoRemoveAmount ?? this.tokenTwoRemoveAmount,
      lpTokenPairBalance: lpTokenPairBalance ?? this.lpTokenPairBalance,
      shareOfPool: shareOfPool ?? this.shareOfPool,
      percentRemoval: percentRemoval ?? this.percentRemoval,
      lpTokenOneAmount: lpTokenOneAmount ?? this.lpTokenOneAmount,
      lpTokenTwoAmount: lpTokenTwoAmount ?? this.lpTokenTwoAmount,
      tokenOneAddress: tokenOneAddress ?? this.tokenOneAddress,
      tokenTwoAddress: tokenTwoAddress ?? this.tokenTwoAddress,
      lpTokenPairAddress: lpTokenPairAddress ?? this.lpTokenPairAddress,
      status: status ?? this.status,
    );
  }
}
