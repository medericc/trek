import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  final List<int?> board; // Liste contenant les valeurs des 16 cercles (ou null si non remplis)
  final Function(int) onCircleTap; // Callback pour placer un nombre dans un cercle

  GameBoard({
    required this.board,
    required this.onCircleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: board.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 cercles par ligne pour former un 4x4
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onCircleTap(index), // Appel du callback lors d’un clic sur un cercle
          child: _buildCircle(board[index]), // Création du cercle
        );
      },
    );
  }

  // Widget pour créer chaque cercle en fonction de sa valeur
  Widget _buildCircle(int? value) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: value != null ? Colors.green : Colors.grey, // Vert si le cercle contient une valeur, gris sinon
      ),
      child: Text(
        value?.toString() ?? '', // Affiche la valeur du cercle ou rien s’il est vide
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
