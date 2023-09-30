class Market {
  Market({
    required this.status,
    required this.marketHash,
    required this.outcomeOneName,
    required this.outcomeTwoName,
    required this.outcomeVoidName,
    required this.teamOneName,
    required this.teamTwoName,
    required this.participantOneId,
    required this.participantTwoId,
    required this.marketType,
    required this.gameTime,
    required this.line,
    required this.teamOneScore,
    required this.teamTwoScore,
    required this.sportXeventId,
    required this.liveEnabled,
    required this.mainLine,
    required this.sportLabel,
    required this.sportId,
    required this.leagueId,
    required this.homeTeamFirst,
    required this.leagueLabel,
    required this.group1,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      status: json['status'] as String,
      marketHash: json['marketHash'] as String,
      outcomeOneName: json['outcomeOneName'] as String,
      outcomeTwoName: json['outcomeTwoName'] as String,
      outcomeVoidName: json['outcomeVoidName'] as String,
      teamOneName: json['teamOneName'] as String,
      teamTwoName: json['teamTwoName'] as String,
      participantOneId: json['participantOneId'] as int,
      participantTwoId: json['participantTwoId'] as int,
      marketType: json['marketType'] as int,
      gameTime: json['gameTime'] as int,
      line: json['line'] as double,
      teamOneScore: json['teamOneScore'] as int,
      teamTwoScore: json['teamTwoScore'] as int,
      sportXeventId: json['sportXeventId'] as String,
      liveEnabled: json['liveEnabled'] as bool,
      mainLine: json['mainLine'] as bool,
      sportLabel: json['sportLabel'] as String,
      sportId: json['sportId'] as int,
      leagueId: json['leagueId'] as int,
      homeTeamFirst: json['homeTeamFirst'] as bool,
      leagueLabel: json['leagueLabel'] as String,
      group1: json['group1'] as String,
    );
  }

  final String status;
  final String marketHash;
  final String outcomeOneName;
  final String outcomeTwoName;
  final String outcomeVoidName;
  final String teamOneName;
  final String teamTwoName;
  final int participantOneId;
  final int participantTwoId;
  final int marketType;
  final int gameTime;
  final double line;
  final int teamOneScore;
  final int teamTwoScore;
  final String sportXeventId;
  final bool liveEnabled;
  final bool mainLine;
  final String sportLabel;
  final int sportId;
  final int leagueId;
  final bool homeTeamFirst;
  final String leagueLabel;
  final String group1;
}
