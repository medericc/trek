import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/dice_widget.dart';
import '../widgets/game_board.dart';
import '../models/player.dart';
import './score_screen.dart';
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
  List<bool> zonesVisited = [];
  List<bool> seriesVisited = [];
  // Compteurs pour chaque opération
  int additionCount = 0;
  int subtractionCount = 0;
  int multiplicationCount = 0;
  int maxCount = 0;
  int minCount = 0;
  int score = 0;

   List<Player> players = [
  Player(id: "1", name: "Joueur 1", score: 0),
  Player(id: "2", name: "Joueur 2", score: 0),
];

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
void endGame() {
  // Vérifie d'abord que la liste n'est pas vide
  if (players.isNotEmpty) {
    players[0].score = score;
    players[1].score = score ~/ 2;
  } else {
    print("Erreur : liste de joueurs vide.");
  }

  // Vérifie les scores avant la navigation
  print("Score Joueur 1: ${players.isNotEmpty ? players[0].score : 'Pas de joueur'}");
  print("Score Joueur 2: ${players.length > 1 ? players[1].score : 'Pas de joueur'}");

  Navigator.pushNamed(
    context,
    '/score',
    arguments: {'players': players, 'roomCode': ModalRoute.of(context)?.settings.arguments},
  );
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
     calculateScore();});
  }
}
int calculateScore() {
  zonesVisited = List.filled(board.length, false);
  seriesVisited = List.filled(board.length, false);
  
  int zoneScore = calculateZones();
  print('Score des zones: $zoneScore');

  int seriesScore = calculateSeries();
  print('Score des séries: $seriesScore');

  int orphanPenalty = calculateOrphanPenalty();
  print('Pénalité pour cases orphelines: $orphanPenalty');

  int totalScore = zoneScore + seriesScore - orphanPenalty;
  
  setState(() {
    score = totalScore;
  });
  print('Score total après calcul: $totalScore');
  return totalScore;
}


int calculateZones() {
  int zoneScore = 0;

  for (int i = 0; i < board.length; i++) {
    if (board[i] != null && !zonesVisited[i]) {
      // Obtenir la zone connectée pour cette case
      List<int> zone = getConnectedValues(i, board[i]!, zonesVisited);

      if (zone.length > 1) {
        // Marquer la zone comme valide uniquement si elle a plus d'une case
        int zoneValue = board[i]!;
        int scoreZone = zoneValue + (zone.length - 1);
        zoneScore += scoreZone;
        print('Zone trouvée avec valeur $zoneValue et taille ${zone.length} - Score de cette zone: $scoreZone');
      } else {
        // Si la zone est une case seule, la démarquer pour qu'elle puisse être comptée comme orpheline
        zonesVisited[i] = false;
      }
    }
  }
  print('Score total des zones: $zoneScore');
  return zoneScore;
}

int calculateOrphanPenalty() {
  int orphanPenalty = 0;

  for (int i = 0; i < board.length; i++) {
    if (board[i] != null && !isPartOfZoneOrSeries(i)) {
      orphanPenalty += 3;
      print('Pénalité appliquée à la case $i avec valeur ${board[i]}');
    }
  }
  
  print('Pénalité totale pour cases orphelines: $orphanPenalty');
  return orphanPenalty;
}




List<int> getConnectedValues(int index, int value, List<bool> zonesVisited) {
  final rows = 4;
  final cols = 4;
  final List<int> zone = [];
  final List<int> directions = [-1, 1, -cols, cols]; // Gauche, Droite, Haut, Bas

  final queue = [index];
  while (queue.isNotEmpty) {
    int current = queue.removeLast();
    if (zonesVisited[current] || board[current] != value) continue;
    zonesVisited[current] = true;
    zone.add(current);

    for (var dir in directions) {
      int adj = current + dir;
      bool inBounds = adj >= 0 && adj < board.length;
      bool sameRow = (current ~/ cols) == (adj ~/ cols);
      if (inBounds && board[adj] == value && (sameRow || dir.abs() == cols)) {
        queue.add(adj);
      }
    }
  }
  print('Zone connectée pour la valeur $value : $zone');
  return zone;
}
int calculateSeries() {
  int seriesScore = 0;

  for (int i = 0; i < board.length; i++) {
    if (board[i] != null && !seriesVisited[i]) {
      List<int> series = getSeries(i, seriesVisited);

      if (series.length > 1) {
        int seriesValue = series.map((index) => board[index]!).reduce(max);
        int scoreSeries = seriesValue + (series.length - 1);
        seriesScore += scoreSeries;
        print('Série trouvée avec valeur max $seriesValue et taille ${series.length} - Score de cette série: $scoreSeries');
      } else {
        // Si la série a une seule case, la marquer comme non visitée pour la rendre éligible en tant qu'orpheline
        series.forEach((idx) => seriesVisited[idx] = false);
      }
    }
  }
  print('Score total des séries: $seriesScore');
  return seriesScore;
}







List<int> getSeries(int index, List<bool> seriesVisited) {
  final int rows = 4;
  final int cols = 4;
  final List<int> series = [];
  final List<int> directions = [-1, 1, -cols, cols]; // Left, Right, Up, Down
  int currentValue = board[index]!;  // Get the initial tile value
  final queue = [index];  // Start from the given index

  while (queue.isNotEmpty) {
    int current = queue.removeLast();
    // Skip if already visited or if it's an invalid tile
    if (seriesVisited[current] || board[current] == null) continue;

    // Check if this tile can be part of the series (value difference must be 1)
    if (series.isNotEmpty && (board[current]! - currentValue).abs() != 1) break;

    // Mark the tile as visited and add to series
    seriesVisited[current] = true;
    series.add(current);
    currentValue = board[current]!;  // Update the value for the next tile

    // Explore adjacent tiles in the 4 possible directions
    for (var dir in directions) {
      int adj = current + dir;
      bool inBounds = adj >= 0 && adj < board.length;
      bool sameRow = (current ~/ cols) == (adj ~/ cols);

      if (inBounds && board[adj] != null && (board[adj]! - currentValue).abs() == 1 && (sameRow || dir.abs() == cols)) {
        queue.add(adj);
      }
    }
  }

  // Ensure the series has at least the starting tile
  if (series.isEmpty) {
    series.add(index);
  }

  print('Série adjacente pour la valeur ${board[index]}: $series');
  return series;
}


bool isPartOfZoneOrSeries(int index) {
  // Vérifier si la case fait partie d'une zone
  bool isInZone = zonesVisited[index] && !isSingleTileZone(index);

  // Vérifier si la case fait partie d'une série
  bool isInSeries = seriesVisited[index] && !isSingleTileSeries(index);

  // Si la série est plus grande que 1, la case ne peut pas être orpheline
  if (!isInSeries) {
    List<int> series = getSeries(index, seriesVisited);
    if (series.length > 1) {
      // Si la série contient plusieurs cases, on la marque comme visitée
      for (var idx in series) {
        seriesVisited[idx] = true;  // Marquer toute la série comme visitée
      }
      isInSeries = true;  // La case fait bien partie d'une série
    }
  }

  bool isPart = isInZone || isInSeries;
  
  print('Case $index : Est seule en zone = ${isSingleTileZone(index)}, Est seule en série = ${isSingleTileSeries(index)}, Incluse = $isPart');

  return isPart;
}


bool isSingleTileSeries(int index) {
  List<bool> tempVisited = List.from(seriesVisited);
  List<int> series = getSeries(index, tempVisited);

  // Si la série contient plus d'une case, on la marque comme visitée
  if (series.length > 1) {
    // Marquer toute la série comme visitée
    for (var idx in series) {
      seriesVisited[idx] = true;
    }
    print('Case $index - Est seule dans la série ? false (fait partie d\'une série de taille ${series.length})');
    return false;
  }

  print('Case $index - Est seule dans la série ? true');
  return true;
}











// Determine if the tile is a single tile in a zone
bool isSingleTileZone(int index) {
  List<bool> tempVisited = List.from(zonesVisited);
  List<int> zone = getConnectedValues(index, board[index]!, tempVisited);

  return zone.length == 1;
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
            'Score actuel : $score', // Affichage du score
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
    // Mettre à jour les scores avant de naviguer
    players[0].score = calculateScore(); // ou score calculé pour Joueur 1
    players[1].score = score ~/ 2;       // ou un autre calcul pour Joueur 2
    
    Navigator.pushNamed(
      context,
      '/score',
      arguments: {
        'players': players, 
        'roomCode': roomCode
      },
    );
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
