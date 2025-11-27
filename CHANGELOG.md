# Changelog

All notable changes to VoiceBubble will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-27

### Added
- Initial release of VoiceBubble
- Voice-to-text recording with real-time transcription
- AI-powered text rewriting with GPT-4o-mini
- 40+ writing style presets across 8 categories
- Android floating overlay for system-wide access
- Beautiful onboarding flow with 3 screens
- Light and dark theme support with smooth transitions
- Vault/Archive feature to save recordings
- Comprehensive settings page with full customization
- Professional Terms & Conditions page
- Detailed Privacy Policy page
- Help & Support page with FAQ
- Google Sign-In placeholder (UI ready)
- Apple Sign-In placeholder (UI ready)
- Microphone permission handling
- Overlay permission handling (Android)
- Local storage with Hive
- Theme persistence
- GitHub Actions CI/CD workflows for Android and iOS
- Complete Android configuration with permissions
- Complete iOS configuration with permissions
- ProGuard rules for Android release builds

### Features by Category

#### Core Functionality
- Real-time speech-to-text using OpenAI Whisper
- AI text rewriting with multiple styles
- Recording screen with visual feedback
- Preset selection with categorized organization
- Result screen with copy-to-clipboard

#### Writing Presets
- General: Magic, Slightly, Significantly
- Text Editing: Structured, Shorter, List
- Content Creation: X Post, X Thread, Facebook, LinkedIn, Instagram, Video Script, Short Video Script, Newsletter, Outline
- Journaling: Journal Entry, Gratitude Journal
- Emails: Casual Email, Formal Email
- Summary: Short Summary, Detailed Summary, Meeting Takeaways
- Writing Styles: Business, Formal, Casual, Friendly, Clear & Concise
- Holiday Greetings: Funny & Lighthearted, Friendly & Warm, Simple & Professional

#### Android Features
- Floating overlay bubble (shows when keyboard is open)
- System-wide voice recording overlay
- Inline preset selection in overlay
- Direct text generation from overlay

#### UI/UX
- Stunning gradient backgrounds for onboarding
- Smooth animations and transitions
- Beautiful light and dark themes
- Responsive design for all screen sizes
- Haptic feedback ready
- Professional iconography

#### Data & Storage
- Local storage with Hive
- Archived items with timestamps
- Theme preference persistence
- Onboarding completion tracking

#### Settings & Configuration
- Account management UI
- Upgrade to Pro placeholder
- Language selection (UI ready)
- Dark mode toggle
- Notification settings
- Overlay settings (show/hide, position)
- Voice language settings
- Help & Support access
- Terms & Conditions
- Privacy Policy
- Version display
- Clear cache option
- Reset settings option
- Sign out functionality

### Technical
- Flutter 3.24.0 support
- Dart 3.9.2 support
- Android API 24+ (Android 7.0+)
- iOS 12.0+
- Provider state management
- Dio for HTTP requests
- Speech-to-text integration
- Permission handler
- Google Fonts integration
- SVG support
- Shimmer effects ready

### CI/CD
- Android APK build workflow
- iOS IPA build workflow
- Automated testing
- Code analysis
- Artifact uploads
- Release automation ready

### Documentation
- Comprehensive README with setup instructions
- Contributing guidelines
- Code of conduct
- API integration guide
- Build instructions for Android and iOS
- Signing configuration guide
- Environment variable setup guide

## [Unreleased]

### Planned Features
- Real Google Sign-In integration
- Real Apple Sign-In integration
- Cloud sync for archived items
- Custom preset creation
- Voice language selection
- Offline mode
- Export archived items
- Share functionality
- Pro subscription integration
- More language support
- Voice command shortcuts
- Widget support
- Watch app (iOS/Android)

