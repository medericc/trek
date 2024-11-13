// websocket_message.dart
class WebSocketMessage {
  final String type;  // Type de message : "rollDice", "updateBoard", "endGame", etc.
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
    // Assurez-vous que le type et les données existent dans le JSON
    if (!json.containsKey('type') || !json.containsKey('data')) {
      throw FormatException("Le message JSON est invalide : 'type' et 'data' sont requis.");
    }

    return WebSocketMessage(
      type: json['type'] as String,
      data: _parseData(json['data']),
    );
  }

  // Vérification et traitement des données associées au message
  static Map<String, dynamic> _parseData(dynamic data) {
    // Si les données sont nulles ou ne sont pas un Map, on lance une exception
    if (data == null || data is! Map<String, dynamic>) {
      throw FormatException("Les données doivent être un objet Map.");
    }

    return data;
  }
}
