import 'package:flutter/material.dart';

/// Language model for output language selection
class Language {
  final String code;
  final String name;
  final String nativeName;
  final IconData flag; // Using emoji-style representation

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

/// Supported output languages for GPT-4o Mini
/// Research: GPT-4 and GPT-4o Mini support 50+ languages with high quality
/// Listed here are the most commonly requested languages for text output
class AppLanguages {
  static const List<Language> all = [
    // Most popular
    Language(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: Icons.language,
    ),
    Language(
      code: 'es',
      name: 'Spanish',
      nativeName: 'Español',
      flag: Icons.language,
    ),
    Language(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      flag: Icons.language,
    ),
    Language(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
      flag: Icons.language,
    ),
    Language(
      code: 'it',
      name: 'Italian',
      nativeName: 'Italiano',
      flag: Icons.language,
    ),
    Language(
      code: 'pt',
      name: 'Portuguese',
      nativeName: 'Português',
      flag: Icons.language,
    ),
    Language(
      code: 'ru',
      name: 'Russian',
      nativeName: 'Русский',
      flag: Icons.language,
    ),
    Language(
      code: 'zh',
      name: 'Chinese (Simplified)',
      nativeName: '简体中文',
      flag: Icons.language,
    ),
    Language(
      code: 'zh-TW',
      name: 'Chinese (Traditional)',
      nativeName: '繁體中文',
      flag: Icons.language,
    ),
    Language(
      code: 'ja',
      name: 'Japanese',
      nativeName: '日本語',
      flag: Icons.language,
    ),
    Language(
      code: 'ko',
      name: 'Korean',
      nativeName: '한국어',
      flag: Icons.language,
    ),
    Language(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      flag: Icons.language,
    ),
    Language(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      flag: Icons.language,
    ),
    Language(
      code: 'nl',
      name: 'Dutch',
      nativeName: 'Nederlands',
      flag: Icons.language,
    ),
    Language(
      code: 'pl',
      name: 'Polish',
      nativeName: 'Polski',
      flag: Icons.language,
    ),
    Language(
      code: 'tr',
      name: 'Turkish',
      nativeName: 'Türkçe',
      flag: Icons.language,
    ),
    Language(
      code: 'sv',
      name: 'Swedish',
      nativeName: 'Svenska',
      flag: Icons.language,
    ),
    Language(
      code: 'da',
      name: 'Danish',
      nativeName: 'Dansk',
      flag: Icons.language,
    ),
    Language(
      code: 'no',
      name: 'Norwegian',
      nativeName: 'Norsk',
      flag: Icons.language,
    ),
    Language(
      code: 'fi',
      name: 'Finnish',
      nativeName: 'Suomi',
      flag: Icons.language,
    ),
    Language(
      code: 'el',
      name: 'Greek',
      nativeName: 'Ελληνικά',
      flag: Icons.language,
    ),
    Language(
      code: 'he',
      name: 'Hebrew',
      nativeName: 'עברית',
      flag: Icons.language,
    ),
    Language(
      code: 'th',
      name: 'Thai',
      nativeName: 'ไทย',
      flag: Icons.language,
    ),
    Language(
      code: 'vi',
      name: 'Vietnamese',
      nativeName: 'Tiếng Việt',
      flag: Icons.language,
    ),
    Language(
      code: 'id',
      name: 'Indonesian',
      nativeName: 'Bahasa Indonesia',
      flag: Icons.language,
    ),
    Language(
      code: 'ms',
      name: 'Malay',
      nativeName: 'Bahasa Melayu',
      flag: Icons.language,
    ),
    Language(
      code: 'uk',
      name: 'Ukrainian',
      nativeName: 'Українська',
      flag: Icons.language,
    ),
    Language(
      code: 'cs',
      name: 'Czech',
      nativeName: 'Čeština',
      flag: Icons.language,
    ),
    Language(
      code: 'ro',
      name: 'Romanian',
      nativeName: 'Română',
      flag: Icons.language,
    ),
    Language(
      code: 'hu',
      name: 'Hungarian',
      nativeName: 'Magyar',
      flag: Icons.language,
    ),
  ];

  /// Get language by code
  static Language? getByCode(String code) {
    try {
      return all.firstWhere((lang) => lang.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Default language (English)
  static const Language defaultLanguage = Language(
    code: 'en',
    name: 'English',
    nativeName: 'English',
    flag: Icons.language,
  );
}

