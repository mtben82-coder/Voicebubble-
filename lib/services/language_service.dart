import 'package:shared_preferences/shared_preferences.dart';
import '../constants/languages.dart';

class LanguageService {
  static const String _selectedLanguageKey = 'selected_language';
  static const String _favoriteLanguagesKey = 'favorite_languages';

  /// Get selected language code (default: English)
  static Future<String> getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedLanguageKey) ?? 'en';
  }

  /// Save selected language
  static Future<void> saveSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLanguageKey, languageCode);
  }

  /// Get favorite language codes
  static Future<List<String>> getFavoriteLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteLanguagesKey) ?? [];
  }

  /// Toggle favorite status for a language
  static Future<void> toggleFavorite(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteLanguages();
    
    if (favorites.contains(languageCode)) {
      favorites.remove(languageCode);
    } else {
      favorites.add(languageCode);
    }
    
    await prefs.setStringList(_favoriteLanguagesKey, favorites);
  }

  /// Check if language is favorited
  static Future<bool> isFavorite(String languageCode) async {
    final favorites = await getFavoriteLanguages();
    return favorites.contains(languageCode);
  }
}
