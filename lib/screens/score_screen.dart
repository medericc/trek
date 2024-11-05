import 'package:flutter/material.dart';
import '../models/player.dart';
import '../widgets/score_display.dart';

class ScoreScreen extends StatelessWidget {
  final List<Player> players;

  ScoreScreen({required this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats de la Partie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Classement Final',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ScoreDisplay(players: players), // Affiche les scores de chaque joueur
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Retour à l'écran d'accueil
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
              child: Text('Retour à l\'Accueil'),
            ),
          ],
        ),
      ),
    );
  }
}
