import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/archived_item.dart';
import '../models/recording_item.dart';
import '../models/preset.dart';
import '../constants/languages.dart';
import '../services/subscription_service.dart';

class AppStateProvider extends ChangeNotifier {
  String _transcription = '';
  String _rewrittenText = '';
  Preset? _selectedPreset;
  Language _selectedLanguage = AppLanguages.defaultLanguage;
  bool _isRecording = false;
  bool _isProcessing = false;
  List<ArchivedItem> _archivedItems = [];
  List<RecordingItem> _recordingItems = [];
  bool _isPremium = false;
  DateTime? _subscriptionExpiry;
  String? _subscriptionType; // 'monthly' or 'yearly'
  
  // Getters
  String get transcription => _transcription;
  String get rewrittenText => _rewrittenText;
  Preset? get selectedPreset => _selectedPreset;
  Language get selectedLanguage => _selectedLanguage;
  bool get isRecording => _isRecording;
  bool get isProcessing => _isProcessing;
  List<ArchivedItem> get archivedItems => _archivedItems;
  List<RecordingItem> get recordingItems => _recordingItems;
  bool get isPremium => _isPremium;
  DateTime? get subscriptionExpiry => _subscriptionExpiry;
  String? get subscriptionType => _subscriptionType;
  
  // Initialize and load archived items from Hive
  Future<void> initialize() async {
    await _loadArchivedItems();
    await _loadRecordingItems();
    await checkSubscriptionStatus();
  }
  
  /// Check and update subscription status from Firebase
  Future<void> checkSubscriptionStatus() async {
    try {
      final subscriptionService = SubscriptionService();
      final hasActive = await subscriptionService.hasActiveSubscription();
      _isPremium = hasActive;
      
      debugPrint('📊 Subscription status checked: isPremium = $_isPremium');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error checking subscription status: $e');
    }
  }
  
  void setSubscriptionStatus({
    required bool isPremium,
    DateTime? expiry,
    String? type,
  }) {
    _isPremium = isPremium;
    _subscriptionExpiry = expiry;
    _subscriptionType = type;
    debugPrint('💎 Subscription updated: isPremium=$isPremium, type=$type, expiry=$expiry');
    notifyListeners();
  }
  
  Future<void> _loadArchivedItems() async {
    final box = await Hive.openBox<ArchivedItem>('archived_items');
    _archivedItems = box.values.toList();
    _archivedItems.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }
  
  Future<void> _loadRecordingItems() async {
    final box = await Hive.openBox<RecordingItem>('recording_items');
    _recordingItems = box.values.toList();
    _recordingItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }
  
  void setTranscription(String text) {
    _transcription = text;
    notifyListeners();
  }
  
  void setRewrittenText(String text) {
    _rewrittenText = text;
    notifyListeners();
  }
  
  void setSelectedPreset(Preset? preset) {
    _selectedPreset = preset;
    notifyListeners();
  }
  
  void setSelectedLanguage(Language language) {
    _selectedLanguage = language;
    notifyListeners();
  }
  
  void setRecording(bool value) {
    _isRecording = value;
    notifyListeners();
  }
  
  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }
  
  Future<void> saveToArchive(ArchivedItem item) async {
    final box = await Hive.openBox<ArchivedItem>('archived_items');
    await box.add(item);
    await _loadArchivedItems();
  }
  
  // NEW: Save recording with new model (preferred method)
  Future<void> saveRecording(RecordingItem item) async {
    final box = await Hive.openBox<RecordingItem>('recording_items');
    await box.add(item);
    await _loadRecordingItems();
    
    // Also save to old format for backward compatibility
    final archivedItem = ArchivedItem(
      id: item.id,
      presetName: item.presetUsed,
      originalText: item.rawTranscript,
      rewrittenText: item.finalText,
      timestamp: item.createdAt,
    );
    await saveToArchive(archivedItem);
    
    debugPrint('💾 Recording saved to both stores');
  }
  
  // Update an existing recording
  Future<void> updateRecording(RecordingItem item) async {
    final box = await Hive.openBox<RecordingItem>('recording_items');
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.id == item.id,
      orElse: () => null,
    );
    if (key != null) {
      await box.put(key, item);
      await _loadRecordingItems();
      debugPrint('📝 Recording updated: ${item.id}');
    }
  }
  
  Future<void> deleteFromArchive(String id) async {
    final box = await Hive.openBox<ArchivedItem>('archived_items');
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.id == id,
      orElse: () => null,
    );
    if (key != null) {
      await box.delete(key);
      await _loadArchivedItems();
    }
  }
  
  Future<void> deleteRecording(String id) async {
    final box = await Hive.openBox<RecordingItem>('recording_items');
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.id == id,
      orElse: () => null,
    );
    if (key != null) {
      await box.delete(key);
      await _loadRecordingItems();
      debugPrint('🗑️ Recording deleted: $id');
    }
  }
  
  Future<void> clearArchive() async {
    final box = await Hive.openBox<ArchivedItem>('archived_items');
    await box.clear();
    _archivedItems = [];
    
    final recordingBox = await Hive.openBox<RecordingItem>('recording_items');
    await recordingBox.clear();
    _recordingItems = [];
    
    notifyListeners();
  }
  
  void reset() {
    _transcription = '';
    _rewrittenText = '';
    _selectedPreset = null;
    _isRecording = false;
    _isProcessing = false;
    notifyListeners();
  }
}

