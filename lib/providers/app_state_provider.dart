import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/archived_item.dart';
import '../models/preset.dart';
import '../constants/languages.dart';

class AppStateProvider extends ChangeNotifier {
  String _transcription = '';
  String _rewrittenText = '';
  Preset? _selectedPreset;
  Language _selectedLanguage = AppLanguages.defaultLanguage;
  bool _isRecording = false;
  bool _isProcessing = false;
  List<ArchivedItem> _archivedItems = [];
  
  // Getters
  String get transcription => _transcription;
  String get rewrittenText => _rewrittenText;
  Preset? get selectedPreset => _selectedPreset;
  Language get selectedLanguage => _selectedLanguage;
  bool get isRecording => _isRecording;
  bool get isProcessing => _isProcessing;
  List<ArchivedItem> get archivedItems => _archivedItems;
  
  // Initialize and load archived items from Hive
  Future<void> initialize() async {
    await _loadArchivedItems();
  }
  
  Future<void> _loadArchivedItems() async {
    final box = await Hive.openBox<ArchivedItem>('archived_items');
    _archivedItems = box.values.toList();
    _archivedItems.sort((a, b) => b.timestamp.compareTo(a.timestamp));
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
  
  Future<void> clearArchive() async {
    final box = await Hive.openBox<ArchivedItem>('archived_items');
    await box.clear();
    _archivedItems = [];
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

