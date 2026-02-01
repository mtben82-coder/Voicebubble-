import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/version_snapshot.dart';
import '../models/recording_item.dart';

class VersionHistoryService {
  static const String _boxName = 'version_history';
  static const int maxVersionsPerNote = 100;

  Future<Box<VersionSnapshot>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<VersionSnapshot>(_boxName);
    }
    return Hive.box<VersionSnapshot>(_boxName);
  }

  // Save a new version
  Future<void> saveVersion(RecordingItem note, String label) async {
    try {
      final box = await _getBox();
      final uuid = const Uuid();
      
      final snapshot = VersionSnapshot(
        id: uuid.v4(),
        noteId: note.id,
        content: note.finalText,
        formattedContent: note.formattedContent,
        timestamp: DateTime.now(),
        label: label,
      );

      await box.put(snapshot.id, snapshot);

      // Cleanup old versions if exceeding max
      await _cleanupOldVersions(note.id);
    } catch (e) {
      print('❌ Error saving version: $e');
    }
  }

  // Get all versions for a note
  Future<List<VersionSnapshot>> getVersions(String noteId) async {
    try {
      final box = await _getBox();
      final allVersions = box.values.where((v) => v.noteId == noteId).toList();
      
      // Sort by timestamp, newest first
      allVersions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return allVersions;
    } catch (e) {
      print('❌ Error getting versions: $e');
      return [];
    }
  }

  // Get a specific version
  Future<VersionSnapshot?> getVersion(String versionId) async {
    try {
      final box = await _getBox();
      return box.get(versionId);
    } catch (e) {
      print('❌ Error getting version: $e');
      return null;
    }
  }

  // Delete a version
  Future<void> deleteVersion(String versionId) async {
    try {
      final box = await _getBox();
      await box.delete(versionId);
    } catch (e) {
      print('❌ Error deleting version: $e');
    }
  }

  // Delete all versions for a note
  Future<void> deleteAllVersions(String noteId) async {
    try {
      final box = await _getBox();
      final versions = await getVersions(noteId);
      
      for (var version in versions) {
        await box.delete(version.id);
      }
    } catch (e) {
      print('❌ Error deleting all versions: $e');
    }
  }

  // Cleanup old versions if exceeding max
  Future<void> _cleanupOldVersions(String noteId) async {
    try {
      final versions = await getVersions(noteId);
      
      if (versions.length > maxVersionsPerNote) {
        final box = await _getBox();
        // Keep newest maxVersionsPerNote, delete rest
        final toDelete = versions.sublist(maxVersionsPerNote);
        
        for (var version in toDelete) {
          await box.delete(version.id);
        }
      }
    } catch (e) {
      print('❌ Error cleaning up versions: $e');
    }
  }

  // Get version count for a note
  Future<int> getVersionCount(String noteId) async {
    final versions = await getVersions(noteId);
    return versions.length;
  }

  // Get latest version
  Future<VersionSnapshot?> getLatestVersion(String noteId) async {
    final versions = await getVersions(noteId);
    return versions.isNotEmpty ? versions.first : null;
  }
}
