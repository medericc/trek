import '../models/player.dart';
import '../models/game_state.dart';

class ScoreCalculator {
  final GameState gameState;

  ScoreCalculator(this.gameState);

  // Calcul des scores finaux pour chaque joueur
  void calculateFinalScores() {
    for (var player in gameState.players) {
      int score = _calculateScoreForPlayer(player);
      player.addScore(score);
    }
  }

 // Calcul du score pour un joueur spécifique
int _calculateScoreForPlayer(Player player) {
  int score = 0;

  // Exemple : +1 point pour chaque cercle rempli
  for (var cell in gameState.board) {
    if (cell != null) score += 1;
  }

  // Exemple : -1 point pour chaque croix (cases où le joueur n'a pas pu jouer)
  // Convertit crossCount en int si nécessaire
  score -= player.crossCount.toInt();  // Si crossCount est un double

  return score;
}


  // Obtenir le classement des joueurs (trié par score)
  List<Player> getRanking() {
    List<Player> players = List.from(gameState.players);
    players.sort((a, b) => b.score.compareTo(a.score));  // Tri décroissant par score
    return players;
  }
}
