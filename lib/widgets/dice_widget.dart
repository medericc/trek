import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  final int de1;
  final int de2;
  final VoidCallback onRoll; // Callback pour relancer les dés

  DiceWidget({
    required this.de1,
    required this.de2,
    required this.onRoll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Lancer des dés',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDie(de1), // Affiche le premier dé
            SizedBox(width: 10),
            _buildDie(de2), // Affiche le second dé
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: onRoll, // Bouton pour lancer les dés
          child: Text('Lancer les dés'),
        ),
      ],
    );
  }

  // Widget pour afficher un seul dé avec la valeur indiquée
  Widget _buildDie(int value) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$value',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
