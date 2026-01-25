enum OutcomeType {
  message,  // Emails, texts, replies
  content,  // Social posts, captions
  task,     // To-dos, action items
  idea,     // Brain dumps, creative
  note      // Meetings, summaries
}

// Helper extension for display names and colors
extension OutcomeTypeExtension on OutcomeType {
  String get displayName {
    switch (this) {
      case OutcomeType.message:
        return 'Message';
      case OutcomeType.content:
        return 'Content';
      case OutcomeType.task:
        return 'Task';
      case OutcomeType.idea:
        return 'Idea';
      case OutcomeType.note:
        return 'Note';
    }
  }

  String get emoji {
    switch (this) {
      case OutcomeType.message:
        return '📧';
      case OutcomeType.content:
        return '📣';
      case OutcomeType.task:
        return '✅';
      case OutcomeType.idea:
        return '🧠';
      case OutcomeType.note:
        return '🧾';
    }
  }

  // Convert enum to string for Hive storage
  String toStorageString() {
    return toString().split('.').last;
  }

  // Parse string back to enum
  static OutcomeType fromString(String value) {
    return OutcomeType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => OutcomeType.note,
    );
  }
}
