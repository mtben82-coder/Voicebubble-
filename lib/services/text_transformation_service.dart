import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_config.dart';

// ============================================================
//        TEXT TRANSFORMATION SERVICE
// ============================================================
//
// Elite AI-powered text transformation engine.
// Handles all text enhancement operations with context awareness.
//
// ============================================================

enum AIAction {
  rewrite,
  expand,
  shorten,
  makeProfessional,
  makeCasual,
  translate,
  summarize,
  fixGrammar,
  makeCreative,
  makePersuasive,
}

class TextTransformationResult {
  final String transformedText;
  final String originalText;
  final AIAction action;
  final Duration processingTime;
  final bool success;
  final String? error;

  const TextTransformationResult({
    required this.transformedText,
    required this.originalText,
    required this.action,
    required this.processingTime,
    required this.success,
    this.error,
  });
}

class TextTransformationService {
  static const String _baseUrl = AppConfig.baseUrl;
  
  // Elite AI prompts for each transformation type
  static const Map<AIAction, String> _prompts = {
    AIAction.rewrite: '''You are an elite writing assistant. Rewrite the given text to be clearer, more engaging, and better structured while preserving the original meaning and tone. Make it flow naturally and be more compelling to read.''',
    
    AIAction.expand: '''You are an expert content developer. Expand the given text by adding relevant details, examples, explanations, and context. Make it more comprehensive and informative while maintaining the original style and purpose.''',
    
    AIAction.shorten: '''You are a master editor. Condense the given text to its essential points while preserving all key information and maintaining clarity. Remove redundancy and make every word count.''',
    
    AIAction.makeProfessional: '''You are a business communication expert. Transform the given text into professional, formal language suitable for business contexts. Use sophisticated vocabulary, proper structure, and maintain authority while being clear and respectful.''',
    
    AIAction.makeCasual: '''You are a conversational writing expert. Transform the given text into casual, friendly language that feels natural and approachable. Use conversational tone, contractions, and relatable expressions while keeping the core message intact.''',
    
    AIAction.fixGrammar: '''You are an elite grammar and style expert. Correct all grammatical errors, improve sentence structure, fix punctuation, and enhance readability while preserving the original voice and meaning.''',
    
    AIAction.makeCreative: '''You are a creative writing genius. Transform the given text to be more imaginative, engaging, and memorable. Use vivid language, interesting metaphors, and creative expressions while maintaining the core message.''',
    
    AIAction.makePersuasive: '''You are a master of persuasion. Transform the given text to be more compelling and convincing. Use persuasive techniques, stronger language, and emotional appeals while maintaining credibility and authenticity.''',
    
    AIAction.summarize: '''You are an expert summarizer. Create a concise, well-structured summary that captures all the key points and essential information from the given text. Make it clear and easy to understand.''',
  };

  /// Transform text using AI with context awareness
  Future<TextTransformationResult> transformText({
    required String text,
    required AIAction action,
    String? context,
    String? targetLanguage,
  }) async {
    final startTime = DateTime.now();
    
    try {
      // Validate input
      if (text.trim().isEmpty) {
        throw Exception('Text cannot be empty');
      }

      // Special handling for translation
      if (action == AIAction.translate && targetLanguage != null) {
        return await _translateText(text, targetLanguage, startTime);
      }

      // Build the request payload
      final payload = {
        'text': text.trim(),
        'action': action.name,
        'context': context?.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Make API request
      final response = await http.post(
        Uri.parse('$_baseUrl/api/transform-text'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 30));

      // Handle response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final transformedText = data['transformedText'] as String;
        
        if (transformedText.trim().isEmpty) {
          throw Exception('AI returned empty response');
        }

        return TextTransformationResult(
          transformedText: transformedText.trim(),
          originalText: text,
          action: action,
          processingTime: DateTime.now().difference(startTime),
          success: true,
        );
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      return TextTransformationResult(
        transformedText: text, // Return original on error
        originalText: text,
        action: action,
        processingTime: DateTime.now().difference(startTime),
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Translate text to target language
  Future<TextTransformationResult> _translateText(
    String text,
    String targetLanguage,
    DateTime startTime,
  ) async {
    final payload = {
      'text': text.trim(),
      'targetLanguage': targetLanguage,
      'action': 'translate',
      'timestamp': DateTime.now().toIso8601String(),
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/api/translate-text'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TextTransformationResult(
        transformedText: data['translatedText'] as String,
        originalText: text,
        action: AIAction.translate,
        processingTime: DateTime.now().difference(startTime),
        success: true,
      );
    } else {
      throw Exception('Translation failed: ${response.statusCode}');
    }
  }

  /// Get available languages for translation
  Future<List<Map<String, String>>> getAvailableLanguages() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/languages'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.cast<Map<String, String>>();
      }
    } catch (e) {
      // Return default languages if API fails
    }

    // Fallback languages
    return [
      {'code': 'es', 'name': 'Spanish'},
      {'code': 'fr', 'name': 'French'},
      {'code': 'de', 'name': 'German'},
      {'code': 'it', 'name': 'Italian'},
      {'code': 'pt', 'name': 'Portuguese'},
      {'code': 'ru', 'name': 'Russian'},
      {'code': 'ja', 'name': 'Japanese'},
      {'code': 'ko', 'name': 'Korean'},
      {'code': 'zh', 'name': 'Chinese'},
      {'code': 'ar', 'name': 'Arabic'},
    ];
  }

  /// Get user-friendly action name
  static String getActionDisplayName(AIAction action) {
    switch (action) {
      case AIAction.rewrite:
        return 'Rewrite';
      case AIAction.expand:
        return 'Expand';
      case AIAction.shorten:
        return 'Shorten';
      case AIAction.makeProfessional:
        return 'Make Professional';
      case AIAction.makeCasual:
        return 'Make Casual';
      case AIAction.translate:
        return 'Translate';
      case AIAction.summarize:
        return 'Summarize';
      case AIAction.fixGrammar:
        return 'Fix Grammar';
      case AIAction.makeCreative:
        return 'Make Creative';
      case AIAction.makePersuasive:
        return 'Make Persuasive';
    }
  }

  /// Get action icon
  static String getActionIcon(AIAction action) {
    switch (action) {
      case AIAction.rewrite:
        return '✨';
      case AIAction.expand:
        return '📝';
      case AIAction.shorten:
        return '✂️';
      case AIAction.makeProfessional:
        return '🎯';
      case AIAction.makeCasual:
        return '😎';
      case AIAction.translate:
        return '🌍';
      case AIAction.summarize:
        return '📋';
      case AIAction.fixGrammar:
        return '✅';
      case AIAction.makeCreative:
        return '🎨';
      case AIAction.makePersuasive:
        return '💪';
    }
  }
}