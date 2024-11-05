class AdjacencyChecker {
  static bool isAdjacent(List<int?> board, int position) {
    final rows = 4;
    final cols = 4;

    // Obtenir les positions adjacentes
    List<int> adjacentPositions = [
      position - 1,   // Gauche
      position + 1,   // Droite
      position - cols, // Haut
      position + cols  // Bas
    ];

    // Filtrer pour rester dans les limites de la grille
    adjacentPositions = adjacentPositions.where((pos) {
      bool inBounds = pos >= 0 && pos < board.length;
      bool sameRow = (pos ~/ cols) == (position ~/ cols) || pos ~/ cols == position ~/ cols - 1 || pos ~/ cols == position ~/ cols + 1;
      return inBounds && sameRow;
    }).toList();

    // Vérifier si au moins une position adjacente est remplie
    return adjacentPositions.any((pos) => board[pos] != null);
  }
}
