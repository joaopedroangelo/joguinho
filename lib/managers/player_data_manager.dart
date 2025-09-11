import 'package:shared_preferences/shared_preferences.dart';

class PlayerPreferences {
  static const String _playerNameKey = 'playerName';
  static const String _playerBirthYearKey = 'playerBirthYear';
  static const String _playerAgeKey = 'playerAge';
  static const String _playerInitialsKey = 'playerInitials';

  static Future<void> savePlayerData({
    required String name,
    required int birthYear,
    required int age,
    required String initials,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_playerNameKey, name);
    await prefs.setInt(_playerBirthYearKey, birthYear);
    await prefs.setInt(_playerAgeKey, age);
    await prefs.setString(_playerInitialsKey, initials);
  }

  static Future<Map<String, dynamic>> getPlayerData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_playerNameKey) ?? '',
      'birthYear': prefs.getInt(_playerBirthYearKey) ?? 0,
      'age': prefs.getInt(_playerAgeKey) ?? 0,
      'initials': prefs.getString(_playerInitialsKey) ?? '🙂',
    };
  }

  static Future<void> clearPlayerData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_playerNameKey);
    await prefs.remove(_playerBirthYearKey);
    await prefs.remove(_playerAgeKey);
    await prefs.remove(_playerInitialsKey);
  }
}
