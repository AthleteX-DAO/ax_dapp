part of 'predict_page_bloc.dart';

abstract class PredictPageEvent extends Equatable {
  const PredictPageEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends PredictPageEvent {
  const WatchAppDataChangesStarted();
}
