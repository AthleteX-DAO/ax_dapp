import 'package:flutter/material.dart';

/// Service for retrieving athlete images from external APIs with fallback support
class AthleteImageService {
  /// Get ESPN headshot URL for an athlete
  /// 
  /// ESPN provides headshots for:
  /// - NBA: https://a.espncdn.com/combiner/i?img=/i/headshots/nba/players/full/{playerId}.png
  /// - NFL: https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/{playerId}.png
  /// - MLB: https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/{playerId}.png
  /// - NHL: https://a.espncdn.com/combiner/i?img=/i/headshots/nhl/players/full/{playerId}.png
  static String getEspnHeadshotUrl(int athleteId, String sport) {
    final sportCode = _getSportCode(sport);
    return 'https://a.espncdn.com/combiner/i?img=/i/headshots/$sportCode/players/full/$athleteId.png&w=350&h=254';
  }

  /// Get sport code for ESPN API
  static String _getSportCode(String sport) {
    switch (sport.toLowerCase()) {
      case 'basketball':
      case 'nba':
        return 'nba';
      case 'football':
      case 'nfl':
        return 'nfl';
      case 'baseball':
      case 'mlb':
        return 'mlb';
      case 'hockey':
      case 'nhl':
        return 'nhl';
      case 'soccer':
      case 'mls':
        return 'soccer';
      default:
        return 'nba'; // Default to NBA
    }
  }

  /// Generate a fallback avatar with team colors and athlete initials
  static Widget generateFallbackAvatar({
    required String athleteName,
    required String team,
    required double size,
  }) {
    final initials = _getInitials(athleteName);
    final teamColor = _getTeamColor(team);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            teamColor,
            teamColor.withOpacity(0.7),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            fontFamily: 'Open Sans',
          ),
        ),
      ),
    );
  }

  /// Extract initials from athlete name
  static String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '??';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Get team color (simplified mapping)
  static Color _getTeamColor(String team) {
    final teamLower = team.toLowerCase();
    
    // NBA Teams
    if (teamLower.contains('lakers')) return const Color(0xFF552583);
    if (teamLower.contains('warriors')) return const Color(0xFF1D428A);
    if (teamLower.contains('celtics')) return const Color(0xFF007A33);
    if (teamLower.contains('bulls')) return const Color(0xFFCE1141);
    if (teamLower.contains('heat')) return const Color(0xFF98002E);
    if (teamLower.contains('knicks')) return const Color(0xFF006BB6);
    if (teamLower.contains('nets')) return const Color(0xFF000000);
    if (teamLower.contains('76ers') || teamLower.contains('sixers')) {
      return const Color(0xFF006BB6);
    }
    
    // NFL Teams
    if (teamLower.contains('chiefs')) return const Color(0xFFE31837);
    if (teamLower.contains('patriots')) return const Color(0xFF002244);
    if (teamLower.contains('packers')) return const Color(0xFF203731);
    if (teamLower.contains('cowboys')) return const Color(0xFF041E42);
    if (teamLower.contains('49ers')) return const Color(0xFFAA0000);
    
    // MLB Teams
    if (teamLower.contains('yankees')) return const Color(0xFF003087);
    if (teamLower.contains('red sox')) return const Color(0xFFBD3039);
    if (teamLower.contains('dodgers')) return const Color(0xFF005A9C);
    
    // Default gold color for unknown teams
    return const Color(0xFFFFD700);
  }

  /// Widget that displays athlete image with automatic fallback
  static Widget athleteImage({
    required int athleteId,
    required String athleteName,
    required String sport,
    required String team,
    required double size,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.network(
      getEspnHeadshotUrl(athleteId, sport),
      width: size,
      height: size,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return generateFallbackAvatar(
          athleteName: athleteName,
          team: team,
          size: size,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[800],
          ),
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFFD700),
              ),
            ),
          ),
        );
      },
    );
  }
}
