class UserTeam{
  const UserTeam({
    required this.address,
    required this.roster,
    required this.teamPerformance,
  });
  final String address;
  final Map<String,double> roster;
  final double teamPerformance;
}
