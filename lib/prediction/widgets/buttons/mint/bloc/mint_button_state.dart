part of 'mint_button_bloc.dart';

class MintButtonState extends Equatable {
  const MintButtonState({
    this.status = BlocStatus.initial,
  });

  final BlocStatus status;

  @override
  List<Object?> get props => [status];
}