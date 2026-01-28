import 'package:hive/hive.dart';

/// Types of smart actions that can be detected
enum SmartActionType {
  calendar,
  email,
  todo,
  note,
  message,
}

extension SmartActionTypeExtension on SmartActionType {
  String get displayName {
    switch (this) {
      case SmartActionType.calendar:
        return 'Calendar Event';
      case SmartActionType.email:
        return 'Email';
      case SmartActionType.todo:
        return 'Task';
      case SmartActionType.note:
        return 'Note';
      case SmartActionType.message:
        return 'Message';
    }
  }

  String get emoji {
    switch (this) {
      case SmartActionType.calendar:
        return '📅';
      case SmartActionType.email:
        return '✉️';
      case SmartActionType.todo:
        return '✅';
      case SmartActionType.note:
        return '📝';
      case SmartActionType.message:
        return '💬';
    }
  }
}

/// Represents a smart action extracted from voice
class SmartAction {
  final SmartActionType type;
  final String title;
  final String? description;
  final DateTime? datetime;
  final String? location;
  final List<String>? attendees;
  final String? recipient;
  final String? subject;
  final String? body;
  final String? priority;
  final String? platform; // Slack, Discord, WhatsApp, etc.
  final String formattedText; // Pre-formatted for export

  SmartAction({
    required this.type,
    required this.title,
    this.description,
    this.datetime,
    this.location,
    this.attendees,
    this.recipient,
    this.subject,
    this.body,
    this.priority,
    this.platform,
    required this.formattedText,
  });

  factory SmartAction.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = SmartActionType.values.firstWhere(
      (e) => e.toString().split('.').last == typeStr,
      orElse: () => SmartActionType.note,
    );

    return SmartAction(
      type: type,
      title: json['title'] as String,
      description: json['description'] as String?,
      datetime: json['datetime'] != null
          ? DateTime.parse(json['datetime'] as String)
          : null,
      location: json['location'] as String?,
      attendees: (json['attendees'] as List?)?.cast<String>(),
      recipient: json['recipient'] as String?,
      subject: json['subject'] as String?,
      body: json['body'] as String?,
      priority: json['priority'] as String?,
      platform: json['platform'] as String?,
      formattedText: json['formatted'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'datetime': datetime?.toIso8601String(),
      'location': location,
      'attendees': attendees,
      'recipient': recipient,
      'subject': subject,
      'body': body,
      'priority': priority,
      'platform': platform,
      'formatted': formattedText,
    };
  }
}

/// Response from smart actions extraction
class SmartActionsResponse {
  final List<SmartAction> actions;
  final String? originalText;

  SmartActionsResponse({
    required this.actions,
    this.originalText,
  });

  factory SmartActionsResponse.fromJson(Map<String, dynamic> json) {
    final actionsList = json['actions'] as List;
    return SmartActionsResponse(
      actions: actionsList.map((a) => SmartAction.fromJson(a)).toList(),
      originalText: json['original_text'] as String?,
    );
  }
}
