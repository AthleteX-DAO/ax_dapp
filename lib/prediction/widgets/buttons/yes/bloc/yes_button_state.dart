part of 'yes_button_bloc.dart';

class YesButtonState extends Equatable {
  const YesButtonState({
    this.status = BlocStatus.initial,
  });

  final BlocStatus status;

  @override
  List<Object?> get props => [status];
}
