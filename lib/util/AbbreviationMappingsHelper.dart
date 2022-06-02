// ignore_for_file: non_constant_identifier_names

Map<String, String> _MLBAthleteMappingPosition = {
  'RF': 'Right Fielder',
  'SS': 'Short Stop',
  '1B': 'First Baseman',
  '2B': 'Second Baseman',
  '3B': 'Third Baseman',
  'CF': 'Center Fielder',
  'LF': 'Left Fielder',
  'RP': 'Relief Pitcher',
  'SP': 'Starting Pitcher',
  'C': 'Catcher',
  'DH': 'Designated Hitter',
};

Map<String, String> _MLBAthleteMappingTeamNickname = {
  'ARI': 'Diamondbacks',
  'ATL': 'Braves',
  'BAL': 'Orioles',
  'BOS': 'Red Sox',
  'CHC': 'Cubs',
  'CHW': 'White Sox',
  'CIN': 'Reds',
  'CLE': 'Guardians',
  'COL': 'Rockies',
  'DET': 'Tigers',
  'HOU': 'Astros',
  'KC': 'Royals',
  'LAA': 'Angels',
  'LAD': 'Dodgers',
  'MIA': 'Marlins',
  'MIL': 'Brewers',
  'MIN': 'Twins',
  'NYM': 'Mets',
  'NYY': 'Yankees',
  'OAK': 'Athletics',
  'PHI': 'Phillies',
  'PIT': 'Pirates',
  'SD': 'Padres',
  'SEA': 'Mariners',
  'SF': 'Giants',
  'STL': 'Cardinals',
  'TB': 'Rays',
  'TEX': 'Rangers',
  'TOR': 'Blue Jays',
  'WSH': 'Nationals',
};

Map<String, String> _MLBAthleteMappingTeamCity = {
  'ARI': 'Arizona',
  'ATL': 'Atlanta',
  'BAL': 'Baltimore',
  'BOS': 'Boston',
  'CHC': 'Chicago',
  'CHW': 'Chicago',
  'CIN': 'Cincinnati',
  'CLE': 'Cleveland',
  'COL': 'Colorado',
  'DET': 'Detroit',
  'HOU': 'Houston',
  'KC': 'Kansas City',
  'LAA': 'Los Angeles',
  'LAD': 'Los Angeles',
  'MIA': 'Miami',
  'MIL': 'Milwaukee',
  'MIN': 'Minnesota',
  'NYM': 'New York',
  'NYY': 'New York',
  'OAK': 'Oakland',
  'PHI': 'Philadelphia',
  'PIT': 'Pittsburgh',
  'SD': 'San Diego',
  'SEA': 'Seattle',
  'SF': 'St. Louis',
  'STL': 'Seattle',
  'TB': 'Tampa Bay',
  'TEX': 'Texas',
  'TOR': 'Toronto',
  'WSH': 'Washington',
};

String retrieveFullMLBAthletePosition(String currentMLBAthletePositon) {
  if (_MLBAthleteMappingPosition.containsKey(currentMLBAthletePositon)) {
    return _MLBAthleteMappingPosition[currentMLBAthletePositon]!;
  }
  return "No Position Found";
}

String retrieveTeamNickname(String curMLBAthleteTeamShortname) {
  if (_MLBAthleteMappingTeamNickname.containsKey(curMLBAthleteTeamShortname)) {
    return _MLBAthleteMappingTeamNickname[curMLBAthleteTeamShortname]!;
  } else {
    return "N/A";
  }
}

String retrieveTeamCityName(String curMLBAthleteTeamShortname) {
  if (_MLBAthleteMappingTeamCity.containsKey(curMLBAthleteTeamShortname)) {
    return _MLBAthleteMappingTeamCity[curMLBAthleteTeamShortname]!;
  } else {
    return "N/A";
  }
}
