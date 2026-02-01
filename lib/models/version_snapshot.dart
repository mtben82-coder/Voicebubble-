import 'package:hive/hive.dart';

part 'version_snapshot.g.dart';

@HiveType(typeId: 5)
class VersionSnapshot {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String noteId;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String? formattedContent; // Quill Delta JSON

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String label; // "Auto-save", "Manual save", "Before export", etc.

  VersionSnapshot({
    required this.id,
    required this.noteId,
    required this.content,
    this.formattedContent,
    required this.timestamp,
    required this.label,
  });

  // Formatted date helper
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes != 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  // Preview of content (first 100 chars)
  String get contentPreview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 97)}...';
  }
}
