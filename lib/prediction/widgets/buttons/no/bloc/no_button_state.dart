part of 'no_button_bloc.dart';

class NoButtonState extends Equatable {
  const NoButtonState({
    this.status = BlocStatus.initial,
  });

  final BlocStatus status;

  @override
  List<Object?> get props => [status];
}
