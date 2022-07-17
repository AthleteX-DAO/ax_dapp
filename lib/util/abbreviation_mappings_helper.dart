const Map<String, String> _mlbAthleteMappingPosition = {
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

const Map<String, String> _nflAthleteMappingPosition = {
  'C': 'Center',
  'RB': 'Running Back',
  'QB': 'Quarterback',
  'HB': 'Halfback',
  'WR': 'Wide Receiver',
  'DE': 'Defensive End'
};

const Map<String, String> _mlbAthleteMappingTeamNickname = {
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

const Map<String, String> _mlbAthleteMappingTeamCity = {
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

const Map<String, String> _nflAthleteMappingTeamNickName = {
  'TB': 'Buccaneers',
  'KC': 'Chiefs',
  'JAX': 'Jaguars',
  'GB': 'Packers',
  'BUF': 'Bills',
  'ATL': 'Falcons'
};

const Map<String, String> _nflAthleteMappingTeamCity = {
  'TB': 'Tampa Bay',
  'KC': 'Kansas City',
  'JAX': 'Jacksonville',
  'GB': 'Green Bay',
  'BUF': 'Buffalo',
  'ATL': 'Atlanta'
};

String retrieveFullMLBAthletePosition(String currentMLBAthletePositon) {
  if (_mlbAthleteMappingPosition.containsKey(currentMLBAthletePositon)) {
    return _mlbAthleteMappingPosition[currentMLBAthletePositon]!;
  }
  return 'No Position Found';
}

String retrieveFullNFLAthletePosition(String currentNFLAthletePosition) {
  if (_nflAthleteMappingPosition.containsKey(currentNFLAthletePosition)) {
    return _nflAthleteMappingPosition[currentNFLAthletePosition]!;
  }
  return 'No Position Found';
}

String retrieveNFLTeamNickName(String currentNFLAthleteShortName) {
  if (_nflAthleteMappingTeamNickName.containsKey(currentNFLAthleteShortName)) {
    return _nflAthleteMappingTeamNickName[currentNFLAthleteShortName]!;
  }
  return 'N/A';
}

String retrieveNFLTeamCityName(String currentNFLAthleteTeamShortName) {
  if (_nflAthleteMappingTeamCity.containsKey(currentNFLAthleteTeamShortName)) {
    return _nflAthleteMappingTeamCity[currentNFLAthleteTeamShortName]!;
  }
  return 'N/A';
}

String retrieveTeamNickname(String curMLBAthleteTeamShortname) {
  if (_mlbAthleteMappingTeamNickname.containsKey(curMLBAthleteTeamShortname)) {
    return _mlbAthleteMappingTeamNickname[curMLBAthleteTeamShortname]!;
  } else {
    return 'N/A';
  }
}

String retrieveTeamCityName(String curMLBAthleteTeamShortname) {
  if (_mlbAthleteMappingTeamCity.containsKey(curMLBAthleteTeamShortname)) {
    return _mlbAthleteMappingTeamCity[curMLBAthleteTeamShortname]!;
  } else {
    return 'N/A';
  }
}
