  // websocket.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import './websocket_message.dart';

class WebSocketClient {
  WebSocket? _socket;

  // Getter pour accéder à _socket
  WebSocket? get socket => _socket;

  Future<void> connect() async {
    _socket = await WebSocket.connect('ws://127.0.0.1:4040');
    _socket!.listen((message) {
      var msg = WebSocketMessage.fromJson(jsonDecode(message));
      _handleMessage(msg);
    });
  }

  void close() {
    _socket?.close();
  }

  void _handleMessage(WebSocketMessage message) {
    // Gérer les messages entrants (e.g., diceRolled, playerJoined, error)
    switch (message.type) {
      case 'diceRolled':
        print("Résultat du dé : ${message.data['result']}");
        break;
      case 'playerJoined':
        print("Un autre joueur a rejoint la salle.");
        break;
      case 'roomCreated':
        print("Salle créée avec le code : ${message.data['code']}");
        break;
      case 'error':
        print("Erreur : ${message.data['message']}");
        break;
      // Gérer d'autres types de messages
    }
  }

  void createRoom(String code) {
    sendMessage(WebSocketMessage(type: 'createRoom', data: {'code': code}));
  }

  void joinRoom(String code) {
    sendMessage(WebSocketMessage(type: 'joinRoom', data: {'code': code}));
  }

  void rollDice(String roomCode) {
    sendMessage(WebSocketMessage(type: 'rollDice', data: {'code': roomCode}));
  }

  void sendMessage(WebSocketMessage message) {
    _socket?.add(jsonEncode(message.toJson()));
  }
} 