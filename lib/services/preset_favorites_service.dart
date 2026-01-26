import 'package:shared_preferences/shared_preferences.dart';

class PresetFavoritesService {
  static const String _favoritesKey = 'favorite_preset_ids';
  
  /// Get list of favorite preset IDs
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }
  
  /// Save list of favorite preset IDs
  Future<void> saveFavorites(List<String> presetIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, presetIds);
  }
  
  /// Toggle favorite status for a preset
  Future<void> toggleFavorite(String presetId) async {
    final favorites = await getFavorites();
    
    if (favorites.contains(presetId)) {
      favorites.remove(presetId);
    } else {
      favorites.add(presetId);
    }
    
    await saveFavorites(favorites);
  }
  
  /// Check if a preset is favorited
  Future<bool> isFavorite(String presetId) async {
    final favorites = await getFavorites();
    return favorites.contains(presetId);
  }
}
