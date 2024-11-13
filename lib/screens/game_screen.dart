import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/dice_widget.dart';
import '../widgets/game_board.dart';
import '../models/player.dart';
import './score_screen.dart';
import '../models/websocket.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late WebSocketClient _webSocketClient;

  final List<int?> board = List.filled(16, null); 
    bool isCreator = true; // Par défaut, supposons que c'est le créateur; à ajuster selon votre logique
  int de1 = 0;
  int de2 = 0;
  int playerCount = 1; 
  bool diceRolled = false; 
  bool isFirstMove = true;
  bool moveUsed = false; 
  List<bool> zonesVisited = [];
  List<bool> seriesVisited = [];
 
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
  _webSocketClient = WebSocketClient();
  _webSocketClient.connect(); // Lance la connexion WebSocket
}
@override
void dispose() {
  _webSocketClient.socket?.close(); // Utilisez le getter 'socket' pour accéder à _socket
  super.dispose();
}

  void rollDice() {
  if (!moveUsed && diceRolled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vous devez jouer ce tour avant de relancer les dés !'))
    );
    return;
  }

  setState(() {
   
    final random = Random();
    de1 = random.nextInt(6) + 1;
    de2 = random.nextInt(6) + 1;
    diceRolled = true; 
    moveUsed = false; 
  });
}
void endGame() {
 
  if (players.isNotEmpty) {
    players[0].score = score;
    players[1].score = score ~/ 2;
  } else {
    print("Erreur : liste de joueurs vide.");
  }

 
  print("Score Joueur 1: ${players.isNotEmpty ? players[0].score : 'Pas de joueur'}");
  print("Score Joueur 2: ${players.length > 1 ? players[1].score : 'Pas de joueur'}");

  Navigator.pushNamed(
    context,
    '/score',
    arguments: {'players': players, 'roomCode': ModalRoute.of(context)?.settings.arguments},
  );
}


 void onCircleTap(int index) async {
 
  if (!diceRolled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veuillez lancer les dés avant de jouer !'))
    );
    return;
  }

  if (isFirstMove) {
    isFirstMove = false;
  } else {
     if (!AdjacencyChecker.isAdjacent(board, index)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vous devez choisir une case adjacente !'))
      );
      return;
    }

   if (moveUsed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vous ne pouvez jouer qu\'une seule case par lancer de dés !'))
      );
      return;
    }
  }

  if (de1 == 0 && de2 == 0) {
    board[index] = 0; 
    diceRolled = false;
    setState(() {});
    return;
  }

 
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

if (result != null) {
    setState(() {
      board[index] = result;
      diceRolled = false;  
      moveUsed = true;     
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
      
      List<int> zone = getConnectedValues(i, board[i]!, zonesVisited);

      if (zone.length > 1) {
        int zoneValue = board[i]!;
        int scoreZone = zoneValue + (zone.length - 1);
        zoneScore += scoreZone;
        print('Zone trouvée avec valeur $zoneValue et taille ${zone.length} - Score de cette zone: $scoreZone');
      } else {
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
  final List<int> directions = [-1, 1, -cols, cols]; 

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
  final List<int> directions = [-1, 1, -cols, cols]; 
  int currentValue = board[index]!;  
  final queue = [index];  

  while (queue.isNotEmpty) {
    int current = queue.removeLast();
    if (seriesVisited[current] || board[current] == null) continue;

    if (series.isNotEmpty && (board[current]! - currentValue).abs() != 1) break;

    seriesVisited[current] = true;
    series.add(current);
    currentValue = board[current]!;
    
    for (var dir in directions) {
      int adj = current + dir;
      bool inBounds = adj >= 0 && adj < board.length;
      bool sameRow = (current ~/ cols) == (adj ~/ cols);

      if (inBounds && board[adj] != null && (board[adj]! - currentValue).abs() == 1 && (sameRow || dir.abs() == cols)) {
        queue.add(adj);
      }
    }
  }

  if (series.isEmpty) {
    series.add(index);
  }

  print('Série adjacente pour la valeur ${board[index]}: $series');
  return series;
}


bool isPartOfZoneOrSeries(int index) {
  bool isInZone = zonesVisited[index] && !isSingleTileZone(index);

  bool isInSeries = seriesVisited[index] && !isSingleTileSeries(index);

  if (!isInSeries) {
    List<int> series = getSeries(index, seriesVisited);
    if (series.length > 1) {
      for (var idx in series) {
        seriesVisited[idx] = true;
      }
      isInSeries = true;
    }
  }

  bool isPart = isInZone || isInSeries;
  
  print('Case $index : Est seule en zone = ${isSingleTileZone(index)}, Est seule en série = ${isSingleTileSeries(index)}, Incluse = $isPart');

  return isPart;
}
bool isSingleTileSeries(int index) {
  List<bool> tempVisited = List.from(seriesVisited);
  int seriesScore = getSeriesScore(index, tempVisited);
  
 if (board[index]! <= seriesScore) {
    print('Case $index - Est seule dans la série ? false (fait partie d\'une série avec score $seriesScore)');
    return false;
  }

  print('Case $index - Est seule dans la série ? true');
  return true;
}
int getSeriesScore(int index, List<bool> seriesVisited) {
  final series = getSeries(index, seriesVisited);
  int seriesMaxValue = series.map((i) => board[i]!).reduce((a, b) => a > b ? a : b);
  return seriesMaxValue + series.length - 1;  
}










bool isSingleTileZone(int index) {
  List<bool> tempVisited = List.from(zonesVisited);
  List<int> zone = getConnectedValues(index, board[index]!, tempVisited);

  return zone.length == 1;
}
 

  @override
  Widget build(BuildContext context) {
    
    final String roomCode = ModalRoute.of(context)?.settings.arguments as String? ?? 'Sans Code';

    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu en cours - Salle: $roomCode'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
             Text(
            'Score actuel : $score', 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Joueurs connectés : $playerCount/2',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          DiceWidget(
            de1: de1,
            de2: de2,
            onRoll: rollDice,
          ),

 SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (isCreator) {
                _webSocketClient.rollDice(roomCode);
              } else {
                print('Seul le créateur peut lancer les dés.');
              }
            },
            child: Text('Lancer les dés'),
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
 
    players[0].score = calculateScore();
    players[1].score = score ~/ 2;       
    
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


class AdjacencyChecker {
  static bool isAdjacent(List<int?> board, int index) {
    final rows = 4;
    final cols = 4;

    List<int> adjacentPositions = [
      index - 1,   
      index + 1,   
      index - cols, 
      index + cols  
    ];

   
    return adjacentPositions.any((pos) {
      bool inBounds = pos >= 0 && pos < board.length;
      bool sameRow = (pos ~/ cols) == (index ~/ cols);
      return inBounds && board[pos] != null && (sameRow || pos % cols == index % cols);
    });
  }
}
