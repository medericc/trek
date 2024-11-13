import 'dart:convert'; 
import 'dart:io'; 
import 'dart:math';
import './websocket_message.dart';

// Classe représentant une salle de jeu.
class GameRoom {
  final String code;
  WebSocket? creator; // WebSocket du créateur de la salle.
  List<WebSocket> players = []; // Liste des joueurs dans la salle.

  GameRoom(this.code, this.creator) {
    players.add(creator!); // Le créateur est automatiquement ajouté à la liste des joueurs.
  }

  // Ajouter un joueur à la salle.
  void addPlayer(WebSocket player) {
    if (!players.contains(player)) {
      players.add(player);
    }
  }

  // Envoi d'un message à tous les joueurs de la salle.
  void sendToAll(String type, Map<String, dynamic> data) {
    var message = WebSocketMessage(type: type, data: data).toJson();
    players.forEach((player) {
      player.add(message);
    });
  }
}

void main() async {
  // Lancer le serveur HTTP et WebSocket sur l'adresse 127.0.0.1:4040.
  var server = await HttpServer.bind('127.0.0.1', 4040);
  print('Serveur WebSocket démarré sur ws://127.0.0.1:4040');

  // Stocker les salles de jeu par leur code.
  Map<String, GameRoom> rooms = {}; 

  // Ecouter les requêtes entrantes.
  await for (var request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      var socket = await WebSocketTransformer.upgrade(request);
      
      socket.listen((message) {
        // Décoder le message JSON reçu.
        var decodedMessage = jsonDecode(message) as Map<String, dynamic>;
        var msg = WebSocketMessage.fromJson(decodedMessage);

        switch (msg.type) {
          // Créer une salle de jeu.
          case 'createRoom':
            _handleCreateRoom(socket, rooms, msg);
            break;

          // Rejoindre une salle de jeu.
          case 'joinRoom':
            _handleJoinRoom(socket, rooms, msg);
            break;

          // Lancer les dés (seulement par le créateur de la salle).
          case 'rollDice':
            _handleRollDice(socket, rooms, msg);
            break;

          // Message de type inconnu.
          default:
            socket.add(WebSocketMessage(type: 'error', data: {'message': 'Type de message inconnu'}).toJson());
        }
      });
    }
  }
}

// Fonction pour gérer la création d'une salle.
void _handleCreateRoom(WebSocket socket, Map<String, GameRoom> rooms, WebSocketMessage msg) {
  var roomCode = msg.data['code'];
  
  if (rooms.containsKey(roomCode)) {
    // La salle existe déjà.
    socket.add(WebSocketMessage(type: 'error', data: {'message': 'Le code de la salle est déjà pris'}).toJson());
  } else {
    // Créer une nouvelle salle.
    rooms[roomCode] = GameRoom(roomCode, socket);
    socket.add(WebSocketMessage(type: 'roomCreated', data: {'code': roomCode}).toJson());
  }
}

// Fonction pour gérer le fait qu'un joueur rejoint une salle.
void _handleJoinRoom(WebSocket socket, Map<String, GameRoom> rooms, WebSocketMessage msg) {
  var roomCode = msg.data['code'];
  var room = rooms[roomCode];
  
  if (room != null) {
    room.addPlayer(socket);
    room.sendToAll('playerJoined', {'code': roomCode});
  } else {
    // La salle n'existe pas.
    socket.add(WebSocketMessage(type: 'error', data: {'message': 'Salle introuvable'}).toJson());
  }
}

// Fonction pour gérer le lancement des dés par le créateur de la salle.
void _handleRollDice(WebSocket socket, Map<String, GameRoom> rooms, WebSocketMessage msg) {
  var roomCode = msg.data['code'];
  var room = rooms[roomCode];
  
  if (room != null && socket == room.creator) {
    // Le créateur de la salle lance les dés.
    var rollResult = Random().nextInt(6) + 1;
    room.sendToAll('diceRolled', {'result': rollResult});
  } else {
    // Erreur si ce n'est pas le créateur qui tente de lancer les dés.
    socket.add(WebSocketMessage(type: 'error', data: {'message': 'Vous ne pouvez pas lancer les dés'}).toJson());
  }
}
