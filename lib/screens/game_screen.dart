import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/dice_widget.dart';
import '../widgets/game_board.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<int?> board = List.filled(16, null); // Plateau de jeu 4x4
  int de1 = 0;
  int de2 = 0;
  int playerCount = 1; // Nombre de joueurs connectés (initialement 1 pour le créateur)
  bool diceRolled = false; // Indicateur de lancer de dés
  bool isFirstMove = true;
  bool moveUsed = false; // Empêche plusieurs coups sur un même lancer

  // Compteurs pour chaque opération
  int additionCount = 0;
  int subtractionCount = 0;
  int multiplicationCount = 0;
  int maxCount = 0;
  int minCount = 0;

  @override
  void initState() {
    super.initState();
    // Simuler l'ajout d'un autre joueur après un délai pour tester (à remplacer par la vraie logique réseau)
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        playerCount = 2; // Simule un 2ème joueur qui rejoint la salle
      });
    });
  }

  void rollDice() {
    setState(() {
      // Lancer les dés en générant des valeurs aléatoires entre 1 et 6
      final random = Random();
      de1 = random.nextInt(6) + 1;
      de2 = random.nextInt(6) + 1;
      diceRolled = true; // Dés ont été lancés
      moveUsed = false;  // Réinitialiser le statut du mouvement après le lancer
    });
  }

 void onCircleTap(int index) async {
  // Vérifier si les dés ont été lancés
  if (!diceRolled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veuillez lancer les dés avant de jouer !'))
    );
    return;
  }

  // Si le premier coup est libre, permettre la sélection d'une case sans vérification
  if (isFirstMove) {
    isFirstMove = false; // Désactiver cette condition pour les prochains tours
  } else {
    // Vérifier si la case sélectionnée est adjacente à une autre case remplie
    if (!AdjacencyChecker.isAdjacent(board, index)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vous devez choisir une case adjacente !'))
      );
      return;
    }

    // Vérifier que l'utilisateur n'a pas déjà utilisé son mouvement
    if (moveUsed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vous ne pouvez jouer qu\'une seule case par lancer de dés !'))
      );
      return;
    }
  }

  // Gérer le cas où de1 et de2 sont tous deux 0, permettant ainsi un "coup zéro"
  if (de1 == 0 && de2 == 0) {
    board[index] = 0; // Remplir la case avec un 0
    diceRolled = false;
    setState(() {}); // Mettre à jour l'interface
    return;
  }

  // Afficher une boîte de dialogue pour choisir l’opération
  final result = await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('Choisissez une opération'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: (additionCount < 4 && (de1 + de2) <= 12)
                ? () {
                    setState(() => additionCount++);
                    Navigator.pop(context, de1 + de2);
                  }
                : null,
            child: Text(
              'Addition: ${de1 + de2}',
              style: TextStyle(
                color: (de1 + de2) > 12 || additionCount >= 4
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: (subtractionCount < 4 && (de1 - de2).abs() <= 12)
                ? () {
                    setState(() => subtractionCount++);
                    Navigator.pop(context, (de1 - de2).abs());
                  }
                : null,
            child: Text(
              'Différence: ${(de1 - de2).abs()}',
              style: TextStyle(
                color: (de1 - de2).abs() > 12 || subtractionCount >= 4
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: (multiplicationCount < 4 && (de1 * de2) <= 12)
                ? () {
                    setState(() => multiplicationCount++);
                    Navigator.pop(context, de1 * de2);
                  }
                : null,
            child: Text(
              'Multiplication: ${de1 * de2}',
              style: TextStyle(
                color: (de1 * de2) > 12 || multiplicationCount >= 4
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: (maxCount < 4 && max(de1, de2) <= 12)
                ? () {
                    setState(() => maxCount++);
                    Navigator.pop(context, max(de1, de2));
                  }
                : null,
            child: Text(
              'Plus haut: ${max(de1, de2)}',
              style: TextStyle(
                color: max(de1, de2) > 12 || maxCount >= 4
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: (minCount < 4 && min(de1, de2) <= 12)
                ? () {
                    setState(() => minCount++);
                    Navigator.pop(context, min(de1, de2));
                  }
                : null,
            child: Text(
              'Plus bas: ${min(de1, de2)}',
              style: TextStyle(
                color: min(de1, de2) > 12 || minCount >= 4
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ),
        ],
      );
    },
  );

  // Mettre à jour la case sélectionnée avec le résultat de l’opération choisie
  if (result != null) {
    setState(() {
      board[index] = result;
      diceRolled = false;  // Désactiver les dés pour éviter un autre coup sans relancer
      moveUsed = true;     // Empêcher un autre coup jusqu'à ce que les dés soient relancés
    });
  }
}

  @override
  Widget build(BuildContext context) {
    // Récupérer le code de salle depuis les arguments
    final String roomCode = ModalRoute.of(context)?.settings.arguments as String? ?? 'Sans Code';

    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu en cours - Salle: $roomCode'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Joueurs connectés : $playerCount/2',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          DiceWidget(
            de1: de1,
            de2: de2,
            onRoll: rollDice,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GameBoard(
                board: board,
                onCircleTap: onCircleTap,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: playerCount == 2 ? () {
                // Naviguer vers l'écran de score pour terminer la partie
                Navigator.pushNamed(context, '/score', arguments: roomCode);
              } : null,
              child: Text('Terminer la Partie'),
            ),
          ),
        ],
      ),
    );
  }
}

// Classe pour vérifier l'adjacence
class AdjacencyChecker {
  static bool isAdjacent(List<int?> board, int index) {
    final rows = 4;
    final cols = 4;

    List<int> adjacentPositions = [
      index - 1,   // Gauche
      index + 1,   // Droite
      index - cols, // Haut
      index + cols  // Bas
    ];

    // Vérifie si une position adjacente est déjà occupée
    return adjacentPositions.any((pos) {
      bool inBounds = pos >= 0 && pos < board.length;
      bool sameRow = (pos ~/ cols) == (index ~/ cols);
      return inBounds && board[pos] != null && (sameRow || pos % cols == index % cols);
    });
  }
}
