import 'package:flutter/material.dart';
import '../models/player.dart';
import '../widgets/score_display.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  final List<Player> players = args['players'] as List<Player>;

  // Vérifier que les scores sont corrects
  print("Scores reçus : ${players.map((p) => p.score).toList()}");

  return Scaffold(
    appBar: AppBar(title: Text('Résultats de la Partie')),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Classement Final', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          ScoreDisplay(players: players),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
            child: Text('Retour à l\'Accueil'),
          ),
        ],
      ),
    ),
  );
}

}