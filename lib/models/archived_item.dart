import 'package:hive/hive.dart';

part 'archived_item.g.dart';

@HiveType(typeId: 0)
class ArchivedItem {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String presetName;
  
  @HiveField(2)
  final String originalText;
  
  @HiveField(3)
  final String rewrittenText;
  
  @HiveField(4)
  final DateTime timestamp;

  ArchivedItem({
    required this.id,
    required this.presetName,
    required this.originalText,
    required this.rewrittenText,
    required this.timestamp,
  });
  
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays == 0) {
      return 'Today, ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

