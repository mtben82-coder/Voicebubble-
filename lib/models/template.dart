import '../models/recording_item.dart';
import 'package:uuid/uuid.dart';

enum TemplateCategory {
  productivity,
  business,
  personal,
  creative,
  health,
}

extension TemplateCategoryExtension on TemplateCategory {
  String get displayName {
    switch (this) {
      case TemplateCategory.productivity:
        return 'Productivity';
      case TemplateCategory.business:
        return 'Business';
      case TemplateCategory.personal:
        return 'Personal';
      case TemplateCategory.creative:
        return 'Creative';
      case TemplateCategory.health:
        return 'Health';
    }
  }

  String get emoji {
    switch (this) {
      case TemplateCategory.productivity:
        return '📋';
      case TemplateCategory.business:
        return '💼';
      case TemplateCategory.personal:
        return '📝';
      case TemplateCategory.creative:
        return '🎨';
      case TemplateCategory.health:
        return '💪';
    }
  }
}

class Template {
  final String id;
  final String name;
  final String description;
  final TemplateCategory category;
  final String icon;
  final String content;
  final String? formattedContent; // Quill Delta JSON
  final String? backgroundId; // Optional background preset

  const Template({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.content,
    this.formattedContent,
    this.backgroundId,
  });

  // Convert template to RecordingItem
  RecordingItem toRecordingItem() {
    final uuid = const Uuid();
    return RecordingItem(
      id: uuid.v4(),
      rawTranscript: 'Created from template: $name',
      finalText: content,
      formattedContent: formattedContent,
      presetUsed: 'Template',
      presetId: 'template',
      outcomes: [],
      createdAt: DateTime.now(),
      editHistory: ['Created from template'],
      contentType: 'text',
      customTitle: name,
      background: backgroundId, // ✨ Added background support ✨
    );
  }
}
