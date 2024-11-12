import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  final List<int?> board;
  final Function(int) onCircleTap;

  GameBoard({required this.board, required this.onCircleTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Réduction de la taille des cercles en ajoutant un facteur de 0.8
        double circleSize = ((constraints.maxWidth - 32) / 4) * 0.4;

        return GridView.builder(
          itemCount: board.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => onCircleTap(index),
              child: _buildCircle(board[index], circleSize),
            );
          },
        );
      },
    );
  }

  // Création de chaque cercle avec une taille plus petite
  Widget _buildCircle(int? value, double size) {
    return Container(
      alignment: Alignment.center,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: value != null ? Colors.green : Colors.grey,
      ),
      child: Text(
        value?.toString() ?? '',
        style: TextStyle(fontSize: size * 0.35, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
