class WebSocketMessage {
  final String type;       // Type de message : "rollDice", "updateBoard", "endGame", etc.
  final Map<String, dynamic> data;  // Données associées au message (peuvent varier selon le type)

  WebSocketMessage({
    required this.type,
    required this.data,
  });

  // Convertir en JSON pour l'envoi via WebSocket
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
    };
  }

  // Créer un message WebSocket à partir du JSON reçu
  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'],
      data: json['data'] as Map<String, dynamic>,
    );
  }
}
