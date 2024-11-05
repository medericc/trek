import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController roomCodeController = TextEditingController();
  String? generatedRoomCode; // Stocke le code généré

  // Générer un code de salle aléatoire
  String generateRoomCode() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(5, (index) => chars[random.nextInt(chars.length)]).join();
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
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Générer un code de salle et l'afficher
                setState(() {
                  generatedRoomCode = generateRoomCode();
                });
              },
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
                  // Naviguer vers GameScreen avec le code de salle
                  Navigator.pushNamed(context, '/game', arguments: generatedRoomCode);
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
              onPressed: () {
                // Rejoindre la partie avec le code de salle entré
                final roomCode = roomCodeController.text;
                Navigator.pushNamed(context, '/game', arguments: roomCode);
              },
              child: Text('Rejoindre une Partie'),
            ),
          ],
        ),
      ),
    );
  }
}
