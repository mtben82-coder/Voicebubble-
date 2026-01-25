import 'preset.dart';

/// Lightweight context class for continuation flow (not persisted to Hive)
class ContinueContext {
  final String? projectId;
  final String? projectName;
  final String? singleItemId;
  final List<String> contextTexts; // Max 3 items for token efficiency

  ContinueContext({
    this.projectId,
    this.projectName,
    this.singleItemId,
    required this.contextTexts,
  });

  /// Build context-aware prompt for AI
  String buildPrompt(String newTranscript, Preset preset) {
    if (contextTexts.isEmpty) {
      // No context, return standard prompt
      return newTranscript;
    }

    // Build context section
    final contextSection = contextTexts.join('\n---\n');

    return '''
Previous context:
---
$contextSection
---

New recording:
$newTranscript

Task: Integrate the new recording with the context above. ${preset.description}
Maintain consistency and natural flow.''';
  }

  /// Check if this is a project continuation
  bool get isProjectContinuation => projectId != null;

  /// Check if this is a single item continuation
  bool get isSingleItemContinuation => singleItemId != null;

  /// Get display text for banner
  String get displayText {
    if (isProjectContinuation) {
      return 'Continuing: ${projectName ?? "Project"}';
    } else if (isSingleItemContinuation) {
      return 'Continuing from previous';
    }
    return 'Continue';
  }

  /// Get context count text
  String get contextCountText {
    final count = contextTexts.length;
    if (count == 0) return 'No context';
    if (count == 1) return 'Building on 1 item';
    return 'Building on $count items';
  }
}
