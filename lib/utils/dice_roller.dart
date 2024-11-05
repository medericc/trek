import 'dart:math';

class DiceRoller {
  static final _random = Random();

  // Fonction pour lancer les dés
  static List<int> rollDice() {
    int de1 = _random.nextInt(6);    // Valeur entre 0 et 5
    int de2 = _random.nextInt(6) + 1; // Valeur entre 1 et 6
    return [de1, de2];
  }
}
