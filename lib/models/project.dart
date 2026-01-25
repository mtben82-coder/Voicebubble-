import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 2)
class Project {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> itemIds; // RecordingItem IDs

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  String? description;

  @HiveField(6)
  int? colorIndex; // Index for predefined colors (0-5)

  Project({
    required this.id,
    required this.name,
    required this.itemIds,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.colorIndex,
  });

  // Helper getter for formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return 'Created today';
    } else if (difference.inDays == 1) {
      return 'Created yesterday';
    } else if (difference.inDays < 7) {
      return 'Created ${difference.inDays} days ago';
    } else {
      return 'Created ${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  // Helper getter for item count
  int get itemCount => itemIds.length;

  // Copy with method
  Project copyWith({
    String? id,
    String? name,
    List<String>? itemIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    int? colorIndex,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      itemIds: itemIds ?? List.from(this.itemIds),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }
}
