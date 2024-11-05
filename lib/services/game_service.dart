import 'dart:convert';
import 'package:trek_12_game/utils/dice_roller.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../models/player.dart';
import '../models/game_state.dart';
import '../models/websocket_message.dart';

class GameService {
  late WebSocketChannel _socket;  // WebSocket pour les communications en temps réel
  final GameState gameState;      // L'état de la partie pour accéder aux joueurs, plateau, etc.
        // L'état de la partie pour accéder aux joueurs, plateau, etc.

  GameService(this.gameState);

  // Connexion au serveur WebSocket
  Future<void> connect(String url) async {
    _socket = WebSocketChannel.connect(Uri.parse(url));
    _socket.stream.listen(_onMessageReceived, onDone: _onDisconnected, onError: _onError);
  }

  // Envoyer un message WebSocket
  void _sendMessage(WebSocketMessage message) {
    _socket.sink.add(jsonEncode(message.toJson()));
  }

  // Fonction pour gérer les messages reçus
  void _onMessageReceived(dynamic data) {
    final message = WebSocketMessage.fromJson(jsonDecode(data));
    switch (message.type) {
      case 'rollDice':
        _handleRollDice(message.data);
        break;
      case 'updateBoard':
        _handleUpdateBoard(message.data);
        break;
      case 'endGame':
        _handleEndGame(message.data);
        break;
      // Autres types de messages si besoin
    }
  }

  // Gestion du message pour lancer les dés
  void _handleRollDice(Map<String, dynamic> data) {
    int de1 = data['de1'];
    int de2 = data['de2'];
    // Logique pour afficher le lancer de dés dans l'interface
    print("Lancer des dés : $de1 et $de2");
  }

  // Gestion du message pour mettre à jour le plateau
  void _handleUpdateBoard(Map<String, dynamic> data) {
    int position = data['position'];
    int number = data['number'];
    gameState.placeNumber(position, number);
  }

  // Gestion du message pour la fin de la partie
  void _handleEndGame(Map<String, dynamic> data) {
    print("Partie terminée ! Résultats finaux.");
    // Logique pour afficher les résultats dans l'interface
  }

  // Déconnecter le WebSocket proprement
 void disconnect() {
  _socket.sink.close(status.goingAway); // Vous pouvez utiliser un code de statut comme 'goingAway'
}

  // Gestion des erreurs de connexion
  void _onError(error) {
    print("Erreur WebSocket : $error");
  }

  // Fonction appelée quand le WebSocket est déconnecté
  void _onDisconnected() {
    print("Déconnecté du serveur.");
  }

  // Lancer les dés et envoyer le résultat aux autres joueurs
void rollDice() {
  // Utiliser la classe DiceRoller pour obtenir les valeurs des dés
  List<int> diceResults = DiceRoller.rollDice();
  int de1 = diceResults[0];
  int de2 = diceResults[1];

  _sendMessage(WebSocketMessage(
    type: 'rollDice',
    data: {'de1': de1, 'de2': de2},
  ));
}

  // Placer un nombre dans un cercle et envoyer la mise à jour aux autres joueurs
  void placeNumber(int position, int number) {
    if (gameState.placeNumber(position, number)) {
      _sendMessage(WebSocketMessage(
        type: 'updateBoard',
        data: {'position': position, 'number': number},
      ));
    }
  }
}
