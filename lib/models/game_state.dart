import 'player.dart';

class GameState {
  List<Player> players;             // Liste des joueurs
  List<int?> board;                 // Plateau avec les 16 cercles (null si non rempli)
  int currentPlayerIndex;           // Indice du joueur actuel dans la liste `players`
  int round;                        // Numéro du tour actuel

  GameState({
    required this.players,
    this.currentPlayerIndex = 0,
    this.round = 1,
  }) : board = List.filled(16, null);  // Initialisation du plateau avec 16 cases vides

  // Passer au joueur suivant
  void nextPlayer() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
  }

  // Placer un nombre dans un cercle donné
  bool placeNumber(int position, int number) {
    if (position < 0 || position >= 16 || board[position] != null) return false;
    board[position] = number;
    return true;
  }

  // Obtenir le joueur actuel
  Player get currentPlayer => players[currentPlayerIndex];

  // Vérifier la fin de la partie
  bool isGameOver() {
    return board.every((cell) => cell != null);
  }

  // Calculer les scores finaux (exemple basique)
  void calculateScores() {
    for (var player in players) {
      player.addScore(board.where((cell) => cell != null).length);
    }
  }
}
