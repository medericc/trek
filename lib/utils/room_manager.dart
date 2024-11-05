import 'dart:math';

class RoomManager {
  static final Map<String, List<String>> rooms = {};

  // Méthode pour créer une salle et générer un code unique
  static String createRoom(String playerName) {
    String code = _generateRoomCode();
    rooms[code] = [playerName];
    return code;
  }

  // Méthode pour rejoindre une salle existante
  static bool joinRoom(String code, String playerName) {
    if (rooms.containsKey(code)) {
      rooms[code]?.add(playerName);
      return true;
    }
    return false;
  }

  // Générer un code de salle aléatoire
  static String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
