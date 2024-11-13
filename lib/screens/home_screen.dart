import 'package:flutter/material.dart';
import 'dart:math';
import '../models/websocket.dart'; // Importez WebSocketClient ici

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController roomCodeController = TextEditingController();
  String? generatedRoomCode; // Stocke le code généré
  late WebSocketClient webSocketClient; // Initialisation du client WebSocket
  bool isConnecting = true; // Pour suivre l'état de connexion

  @override
  void initState() {
    super.initState();
    webSocketClient = WebSocketClient(); // Initialisez l'instance de WebSocketClient
    webSocketClient.connect().then((_) {
      setState(() {
        isConnecting = false; // Mise à jour de l'état une fois connecté
      });
      print("Connecté au serveur WebSocket");
    }).catchError((error) {
      print("Erreur de connexion : $error");
    });
  }

  // Libère la mémoire associée au TextEditingController
  @override
  void dispose() {
    roomCodeController.dispose();
    super.dispose();
  }

  // Générer un code de salle aléatoire
  String generateRoomCode() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(5, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // Méthode pour créer la salle et générer le code
// Méthode pour créer la salle et générer le code
void createRoom() {
  setState(() {
    generatedRoomCode = generateRoomCode();
  });
  print("Création de la salle avec le code : $generatedRoomCode");

  // Utilisez WebSocketClient pour créer la salle sans `.then`
  webSocketClient.createRoom(generatedRoomCode!);
}

// Méthode pour rejoindre une salle avec le code fourni
void joinRoom(String roomCode) {
  if (roomCode.isNotEmpty) {
    print("Tentative de rejoindre la salle avec le code : $roomCode");
    // Utilisez WebSocketClient pour rejoindre la salle sans `.then`
    webSocketClient.joinRoom(roomCode);
    Navigator.pushNamed(context, '/game', arguments: roomCode);
  } else {
    // Afficher une alerte si le code est vide
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Code de salle requis'),
        content: Text('Veuillez entrer un code de salle valide pour rejoindre une partie.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trek 12'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue dans Trek 12',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            if (isConnecting)
              CircularProgressIndicator() // Affiche un indicateur de chargement si en cours de connexion
            else
              Text('Connecté au serveur', style: TextStyle(color: Colors.green)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnecting ? null : createRoom, // Désactive le bouton si en cours de connexion
              child: Text('Créer une Partie'),
            ),
            if (generatedRoomCode != null) ...[
              SizedBox(height: 20),
              Text(
                'Code de la salle : $generatedRoomCode',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (generatedRoomCode != null) {
                    Navigator.pushNamed(context, '/game', arguments: generatedRoomCode);
                  }
                },
                child: Text('Lancer la Partie'),
              ),
            ],
            SizedBox(height: 20),
            TextField(
              controller: roomCodeController,
              decoration: InputDecoration(
                labelText: 'Entrer le Code de la salle',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnecting ? null : () => joinRoom(roomCodeController.text),
              child: Text('Rejoindre une Partie'),
            ),
          ],
        ),
      ),
    );
  }
}
