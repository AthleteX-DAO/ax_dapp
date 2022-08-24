part of 'mint_dialog_bloc.dart';

class MintDialogState extends Equatable {
  const MintDialogState({
    required this.balance,
    required this.axAmount,
    required this.status,
    required this.message,
  });

  factory MintDialogState.initial() {
    return const MintDialogState(
      balance: 0,
      axAmount: 0,
      status: BlocStatus.initial,
      message: '',
    );
  }

  final double balance;
  final double axAmount;
  final BlocStatus status;
  final String message;

  @override
  List<Object> get props {
    return [
      balance,
      axAmount,
      status,
      message,
    ];
  }

  MintDialogState copyWith({
    double? balance,
    double? axAmount,
    BlocStatus? status,
    String? message,
  }) {
    return MintDialogState(
      balance: balance ?? this.balance,
      axAmount: axAmount ?? this.axAmount,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
