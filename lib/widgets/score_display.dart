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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scores des joueurs',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        ...players.asMap().entries.map((entry) => Column(
              children: [
                _buildPlayerScore(entry.value),
                if (entry.key < players.length - 1)
                  Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
              ],
            )),
      ],
    );
  }

  // Widget pour afficher le score d’un joueur
  Widget _buildPlayerScore(Player player) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            player.name,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '${player.score}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}
