import 'package:flutter/material.dart';
import '../models/player.dart';

class ScoreDisplay extends StatelessWidget {
  final List<Player> players;

  ScoreDisplay({
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Scores des joueurs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Column(
          children: players.map((player) => _buildPlayerScore(player)).toList(),
        ),
      ],
    );
  }

  // Widget pour afficher le score d’un joueur
  Widget _buildPlayerScore(Player player) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(player.name, style: TextStyle(fontSize: 18)),
          Text('${player.score}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
