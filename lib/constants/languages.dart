/// Language model for output language selection
class Language {
  final String code;
  final String name;
  final String nativeName;
  final String flagEmoji;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
  });
}

/// Supported output languages for Whisper & GPT-4o Mini
/// Both support 100+ languages with high quality
class AppLanguages {
  static const List<Language> all = [
    // A
    Language(code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flagEmoji: '🇿🇦'),
    Language(code: 'sq', name: 'Albanian', nativeName: 'Shqip', flagEmoji: '🇦🇱'),
    Language(code: 'am', name: 'Amharic', nativeName: 'አማርኛ', flagEmoji: '🇪🇹'),
    Language(code: 'ar', name: 'Arabic', nativeName: 'العربية', flagEmoji: '🇸🇦'),
    Language(code: 'hy', name: 'Armenian', nativeName: 'Հայերեն', flagEmoji: '🇦🇲'),
    Language(code: 'az', name: 'Azerbaijani', nativeName: 'Azərbaycan', flagEmoji: '🇦🇿'),
    
    // B
    Language(code: 'eu', name: 'Basque', nativeName: 'Euskara', flagEmoji: '🇪🇸'),
    Language(code: 'be', name: 'Belarusian', nativeName: 'Беларуская', flagEmoji: '🇧🇾'),
    Language(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flagEmoji: '🇧🇩'),
    Language(code: 'bs', name: 'Bosnian', nativeName: 'Bosanski', flagEmoji: '🇧🇦'),
    Language(code: 'bg', name: 'Bulgarian', nativeName: 'Български', flagEmoji: '🇧🇬'),
    Language(code: 'my', name: 'Burmese', nativeName: 'မြန်မာ', flagEmoji: '🇲🇲'),
    
    // C
    Language(code: 'ca', name: 'Catalan', nativeName: 'Català', flagEmoji: '🇪🇸'),
    Language(code: 'zh', name: 'Chinese (Simplified)', nativeName: '简体中文', flagEmoji: '🇨🇳'),
    Language(code: 'zh-TW', name: 'Chinese (Traditional)', nativeName: '繁體中文', flagEmoji: '🇹🇼'),
    Language(code: 'hr', name: 'Croatian', nativeName: 'Hrvatski', flagEmoji: '🇭🇷'),
    Language(code: 'cs', name: 'Czech', nativeName: 'Čeština', flagEmoji: '🇨🇿'),
    
    // D
    Language(code: 'da', name: 'Danish', nativeName: 'Dansk', flagEmoji: '🇩🇰'),
    Language(code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flagEmoji: '🇳🇱'),
    
    // E
    Language(code: 'en', name: 'English', nativeName: 'English', flagEmoji: '🇬🇧'),
    Language(code: 'et', name: 'Estonian', nativeName: 'Eesti', flagEmoji: '🇪🇪'),
    
    // F
    Language(code: 'fi', name: 'Finnish', nativeName: 'Suomi', flagEmoji: '🇫🇮'),
    Language(code: 'fr', name: 'French', nativeName: 'Français', flagEmoji: '🇫🇷'),
    
    // G
    Language(code: 'gl', name: 'Galician', nativeName: 'Galego', flagEmoji: '🇪🇸'),
    Language(code: 'ka', name: 'Georgian', nativeName: 'ქართული', flagEmoji: '🇬🇪'),
    Language(code: 'de', name: 'German', nativeName: 'Deutsch', flagEmoji: '🇩🇪'),
    Language(code: 'el', name: 'Greek', nativeName: 'Ελληνικά', flagEmoji: '🇬🇷'),
    Language(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flagEmoji: '🇮🇳'),
    
    // H
    Language(code: 'ht', name: 'Haitian Creole', nativeName: 'Kreyòl', flagEmoji: '🇭🇹'),
    Language(code: 'ha', name: 'Hausa', nativeName: 'Hausa', flagEmoji: '🇳🇬'),
    Language(code: 'he', name: 'Hebrew', nativeName: 'עברית', flagEmoji: '🇮🇱'),
    Language(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flagEmoji: '🇮🇳'),
    Language(code: 'hu', name: 'Hungarian', nativeName: 'Magyar', flagEmoji: '🇭🇺'),
    
    // I
    Language(code: 'is', name: 'Icelandic', nativeName: 'Íslenska', flagEmoji: '🇮🇸'),
    Language(code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flagEmoji: '🇮🇩'),
    Language(code: 'ga', name: 'Irish', nativeName: 'Gaeilge', flagEmoji: '🇮🇪'),
    Language(code: 'it', name: 'Italian', nativeName: 'Italiano', flagEmoji: '🇮🇹'),
    
    // J
    Language(code: 'ja', name: 'Japanese', nativeName: '日本語', flagEmoji: '🇯🇵'),
    Language(code: 'jv', name: 'Javanese', nativeName: 'Basa Jawa', flagEmoji: '🇮🇩'),
    
    // K
    Language(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flagEmoji: '🇮🇳'),
    Language(code: 'kk', name: 'Kazakh', nativeName: 'Қазақ', flagEmoji: '🇰🇿'),
    Language(code: 'km', name: 'Khmer', nativeName: 'ភាសាខ្មែរ', flagEmoji: '🇰🇭'),
    Language(code: 'ko', name: 'Korean', nativeName: '한국어', flagEmoji: '🇰🇷'),
    Language(code: 'ku', name: 'Kurdish', nativeName: 'Kurdî', flagEmoji: '🇮🇶'),
    
    // L
    Language(code: 'lo', name: 'Lao', nativeName: 'ລາວ', flagEmoji: '🇱🇦'),
    Language(code: 'la', name: 'Latin', nativeName: 'Latina', flagEmoji: '🇻🇦'),
    Language(code: 'lv', name: 'Latvian', nativeName: 'Latviešu', flagEmoji: '🇱🇻'),
    Language(code: 'lt', name: 'Lithuanian', nativeName: 'Lietuvių', flagEmoji: '🇱🇹'),
    
    // M
    Language(code: 'mk', name: 'Macedonian', nativeName: 'Македонски', flagEmoji: '🇲🇰'),
    Language(code: 'mg', name: 'Malagasy', nativeName: 'Malagasy', flagEmoji: '🇲🇬'),
    Language(code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu', flagEmoji: '🇲🇾'),
    Language(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', flagEmoji: '🇮🇳'),
    Language(code: 'mt', name: 'Maltese', nativeName: 'Malti', flagEmoji: '🇲🇹'),
    Language(code: 'mi', name: 'Maori', nativeName: 'Māori', flagEmoji: '🇳🇿'),
    Language(code: 'mr', name: 'Marathi', nativeName: 'मराठी', flagEmoji: '🇮🇳'),
    Language(code: 'mn', name: 'Mongolian', nativeName: 'Монгол', flagEmoji: '🇲🇳'),
    
    // N
    Language(code: 'ne', name: 'Nepali', nativeName: 'नेपाली', flagEmoji: '🇳🇵'),
    Language(code: 'no', name: 'Norwegian', nativeName: 'Norsk', flagEmoji: '🇳🇴'),
    
    // P
    Language(code: 'ps', name: 'Pashto', nativeName: 'پښتو', flagEmoji: '🇦🇫'),
    Language(code: 'fa', name: 'Persian', nativeName: 'فارسی', flagEmoji: '🇮🇷'),
    Language(code: 'pl', name: 'Polish', nativeName: 'Polski', flagEmoji: '🇵🇱'),
    Language(code: 'pt', name: 'Portuguese', nativeName: 'Português', flagEmoji: '🇵🇹'),
    Language(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flagEmoji: '🇮🇳'),
    
    // R
    Language(code: 'ro', name: 'Romanian', nativeName: 'Română', flagEmoji: '🇷🇴'),
    Language(code: 'ru', name: 'Russian', nativeName: 'Русский', flagEmoji: '🇷🇺'),
    
    // S
    Language(code: 'sm', name: 'Samoan', nativeName: 'Gagana Samoa', flagEmoji: '🇼🇸'),
    Language(code: 'sr', name: 'Serbian', nativeName: 'Српски', flagEmoji: '🇷🇸'),
    Language(code: 'sn', name: 'Shona', nativeName: 'ChiShona', flagEmoji: '🇿🇼'),
    Language(code: 'sd', name: 'Sindhi', nativeName: 'سنڌي', flagEmoji: '🇵🇰'),
    Language(code: 'si', name: 'Sinhala', nativeName: 'සිංහල', flagEmoji: '🇱🇰'),
    Language(code: 'sk', name: 'Slovak', nativeName: 'Slovenčina', flagEmoji: '🇸🇰'),
    Language(code: 'sl', name: 'Slovenian', nativeName: 'Slovenščina', flagEmoji: '🇸🇮'),
    Language(code: 'so', name: 'Somali', nativeName: 'Soomaali', flagEmoji: '🇸🇴'),
    Language(code: 'es', name: 'Spanish', nativeName: 'Español', flagEmoji: '🇪🇸'),
    Language(code: 'su', name: 'Sundanese', nativeName: 'Basa Sunda', flagEmoji: '🇮🇩'),
    Language(code: 'sw', name: 'Swahili', nativeName: 'Kiswahili', flagEmoji: '🇰🇪'),
    Language(code: 'sv', name: 'Swedish', nativeName: 'Svenska', flagEmoji: '🇸🇪'),
    
    // T
    Language(code: 'tg', name: 'Tajik', nativeName: 'Тоҷикӣ', flagEmoji: '🇹🇯'),
    Language(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flagEmoji: '🇮🇳'),
    Language(code: 'tt', name: 'Tatar', nativeName: 'Татар', flagEmoji: '🇷🇺'),
    Language(code: 'te', name: 'Telugu', nativeName: 'తెలుగు', flagEmoji: '🇮🇳'),
    Language(code: 'th', name: 'Thai', nativeName: 'ไทย', flagEmoji: '🇹🇭'),
    Language(code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flagEmoji: '🇹🇷'),
    Language(code: 'tk', name: 'Turkmen', nativeName: 'Türkmençe', flagEmoji: '🇹🇲'),
    
    // U
    Language(code: 'uk', name: 'Ukrainian', nativeName: 'Українська', flagEmoji: '🇺🇦'),
    Language(code: 'ur', name: 'Urdu', nativeName: 'اردو', flagEmoji: '🇵🇰'),
    Language(code: 'ug', name: 'Uyghur', nativeName: 'ئۇيغۇرچە', flagEmoji: '🇨🇳'),
    Language(code: 'uz', name: 'Uzbek', nativeName: 'Oʻzbek', flagEmoji: '🇺🇿'),
    
    // V
    Language(code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flagEmoji: '🇻🇳'),
    
    // W
    Language(code: 'cy', name: 'Welsh', nativeName: 'Cymraeg', flagEmoji: '🏴'),
    
    // X
    Language(code: 'xh', name: 'Xhosa', nativeName: 'isiXhosa', flagEmoji: '🇿🇦'),
    
    // Y
    Language(code: 'yi', name: 'Yiddish', nativeName: 'ייִדיש', flagEmoji: '🇮🇱'),
    Language(code: 'yo', name: 'Yoruba', nativeName: 'Yorùbá', flagEmoji: '🇳🇬'),
    
    // Z
    Language(code: 'zu', name: 'Zulu', nativeName: 'isiZulu', flagEmoji: '🇿🇦'),
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
    flagEmoji: '🇬🇧',
  );
}
