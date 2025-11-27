import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/archived_item.dart';

class StorageService {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _archivedItemsBoxName = 'archived_items';
  
  /// Initialize Hive and register adapters
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register Hive type adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ArchivedItemAdapter());
    }
  }
  
  /// Check if onboarding has been completed
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }
  
  /// Mark onboarding as complete
  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }
  
  /// Get archived items box
  static Future<Box<ArchivedItem>> getArchivedItemsBox() async {
    if (!Hive.isBoxOpen(_archivedItemsBoxName)) {
      return await Hive.openBox<ArchivedItem>(_archivedItemsBoxName);
    }
    return Hive.box<ArchivedItem>(_archivedItemsBoxName);
  }
  
  /// Clear all app data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    if (Hive.isBoxOpen(_archivedItemsBoxName)) {
      final box = Hive.box<ArchivedItem>(_archivedItemsBoxName);
      await box.clear();
    }
  }
}

