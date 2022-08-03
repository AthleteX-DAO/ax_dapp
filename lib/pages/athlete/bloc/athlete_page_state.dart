part of 'athlete_page_bloc.dart';

class AthletePageState extends Equatable {
  const AthletePageState({
    this.status = BlocStatus.initial,
    this.aptTypeSelection = AptType.long,
    this.longApt = const Apt.empty(),
    this.shortApt = const Apt.empty(),
    this.stats = const [],
  });

  final BlocStatus status;
  final AptType aptTypeSelection;
  final Apt longApt;
  final Apt shortApt;
  final List<GraphData> stats;

  AthletePageState copyWith({
    BlocStatus? status,
    AptType? aptTypeSelection,
    Apt? longApt,
    Apt? shortApt,
    List<GraphData>? stats,
  }) {
    return AthletePageState(
      status: status ?? this.status,
      aptTypeSelection: aptTypeSelection ?? this.aptTypeSelection,
      longApt: longApt ?? this.longApt,
      shortApt: shortApt ?? this.shortApt,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
        status,
        aptTypeSelection,
        longApt,
        shortApt,
        stats,
      ];
}

extension BuyDialogStateX on AthletePageState {
  String get selectedAptAddress =>
      aptTypeSelection.isLong ? longApt.address : shortApt.address;
}
