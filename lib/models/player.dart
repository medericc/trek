class Player {
  final String id;               // ID unique du joueur
  final String name;             // Nom du joueur
  int score;   
   int crossCount = 0;                  // Score actuel du joueur
  int additionsLeft = 4;         // Nombre d'additions restantes
  int subtractionsLeft = 4;      // Nombre de soustractions restantes
  int multiplicationsLeft = 4;   // Nombre de multiplications restantes
  int maxDiceLeft = 4;           // Nombre d'utilisations du plus grand dé restantes
  int minDiceLeft = 4;           // Nombre d'utilisations du plus petit dé restantes

  Player({
    required this.id,
    required this.name,
    this.score = 0,
  });

  // Méthode pour réinitialiser les calculs restants
  void resetCalculations() {
    additionsLeft = 4;
    subtractionsLeft = 4;
    multiplicationsLeft = 4;
    maxDiceLeft = 4;
    minDiceLeft = 4;
  }

  // Méthode pour ajouter des points au score
  void addScore(int points) {
    score += points;
  }

  // Méthode pour utiliser un calcul (décrémente le compteur)
  bool useCalculation(String type) {
    switch (type) {
      case 'addition':
        if (additionsLeft > 0) {
          additionsLeft--;
          return true;
        }
        break;
      case 'subtraction':
        if (subtractionsLeft > 0) {
          subtractionsLeft--;
          return true;
        }
        break;
      case 'multiplication':
        if (multiplicationsLeft > 0) {
          multiplicationsLeft--;
          return true;
        }
        break;
      case 'maxDice':
        if (maxDiceLeft > 0) {
          maxDiceLeft--;
          return true;
        }
        break;
      case 'minDice':
        if (minDiceLeft > 0) {
          minDiceLeft--;
          return true;
        }
        break;
    }
    return false;
  }
}
