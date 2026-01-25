import 'package:hive_flutter/hive_flutter.dart';
import '../models/project.dart';
import '../models/recording_item.dart';
import '../models/continue_context.dart';

class ContinueService {
  static const String _projectsBoxName = 'projects';
  static const String _recordingItemsBoxName = 'recording_items';
  static const int maxContextItems = 3; // Limit for token efficiency

  /// Build context from a project (last 3 items)
  Future<ContinueContext> buildContextFromProject(String projectId) async {
    final projectBox = await Hive.openBox<Project>(_projectsBoxName);
    final project = projectBox.get(projectId);
    
    if (project == null) {
      throw Exception('Project not found: $projectId');
    }

    final recordingBox = await Hive.openBox<RecordingItem>(_recordingItemsBoxName);
    final allItems = recordingBox.values.toList();
    
    // Get items in this project, sorted by date (newest first)
    final projectItems = allItems
        .where((item) => project.itemIds.contains(item.id))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Take last 3 items (most recent context)
    final contextItems = projectItems.take(maxContextItems).toList();
    final contextTexts = contextItems.map((item) => item.finalText).toList();

    return ContinueContext(
      projectId: projectId,
      projectName: project.name,
      contextTexts: contextTexts,
    );
  }

  /// Build context from a single item
  Future<ContinueContext> buildContextFromItem(String itemId) async {
    final recordingBox = await Hive.openBox<RecordingItem>(_recordingItemsBoxName);
    
    RecordingItem? item;
    for (final key in recordingBox.keys) {
      final candidate = recordingBox.get(key);
      if (candidate?.id == itemId) {
        item = candidate;
        break;
      }
    }

    if (item == null) {
      throw Exception('Recording item not found: $itemId');
    }

    return ContinueContext(
      singleItemId: itemId,
      contextTexts: [item.finalText],
    );
  }

  /// Link items in continuation chain
  Future<void> linkContinuationChain({
    required String newItemId,
    required String? continuedFromId,
  }) async {
    if (continuedFromId == null) return;

    final recordingBox = await Hive.openBox<RecordingItem>(_recordingItemsBoxName);

    // Update the previous item's continuedInIds
    for (final key in recordingBox.keys) {
      final item = recordingBox.get(key);
      if (item?.id == continuedFromId) {
        final updatedItem = item!.copyWith(
          continuedInIds: [...item.continuedInIds, newItemId],
        );
        await recordingBox.put(key, updatedItem);
        break;
      }
    }
  }

  /// Get continuation chain for an item (all items that followed this one)
  Future<List<RecordingItem>> getContinuationChain(String itemId) async {
    final recordingBox = await Hive.openBox<RecordingItem>(_recordingItemsBoxName);
    final allItems = recordingBox.values.toList();

    RecordingItem? startItem;
    for (final item in allItems) {
      if (item.id == itemId) {
        startItem = item;
        break;
      }
    }

    if (startItem == null) return [];

    // Recursively get all items in the chain
    final chain = <RecordingItem>[];
    final queue = List<String>.from(startItem.continuedInIds);

    while (queue.isNotEmpty) {
      final nextId = queue.removeAt(0);
      final nextItem = allItems.firstWhere(
        (item) => item.id == nextId,
        orElse: () => allItems.first, // Safe fallback
      );
      
      if (nextItem.id == nextId) {
        chain.add(nextItem);
        queue.addAll(nextItem.continuedInIds);
      }
    }

    return chain;
  }
}
