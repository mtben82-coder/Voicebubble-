# Contributing to VoiceBubble

Thank you for considering contributing to VoiceBubble! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- Clear, descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Device/OS information
- App version

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- Clear, descriptive title
- Detailed description of the proposed functionality
- Rationale for the enhancement
- Possible implementation approach

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests and ensure they pass
5. Run `flutter analyze` and fix any issues
6. Format your code: `flutter format .`
7. Commit your changes with clear messages
8. Push to your fork
9. Open a Pull Request

#### PR Guidelines

- Follow the existing code style
- Write clear commit messages
- Update documentation as needed
- Add tests for new features
- Ensure all tests pass
- Keep PRs focused on a single feature/fix

## Development Setup

1. Install Flutter SDK 3.24.0+
2. Clone the repository
3. Run `flutter pub get`
4. Run `flutter pub run build_runner build`
5. Set up your OpenAI API key in `.env`
6. Run the app: `flutter run`

## Coding Standards

### Dart Style Guide

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

### Code Organization

- Keep files focused and single-purpose
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use const constructors where possible

### Widget Guidelines

- Prefer StatelessWidget when possible
- Extract reusable widgets into separate files
- Use meaningful widget names
- Keep build methods clean and readable

### State Management

- Use Provider for app-wide state
- Keep state close to where it's used
- Don't expose internal state unnecessarily

## Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Ensure all tests pass before submitting PR
- Maintain or improve code coverage

## Documentation

- Update README.md for new features
- Add inline documentation for public APIs
- Update CHANGELOG.md with your changes
- Include code examples where helpful

## Commit Message Guidelines

Format: `type(scope): subject`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Examples:
```
feat(recording): add pause/resume functionality
fix(overlay): resolve crash on Android 11
docs(readme): update installation instructions
```

## Release Process

1. Update version in `pubspec.yaml`
2. Update CHANGELOG.md
3. Create a git tag: `git tag -a v1.0.0 -m "Release v1.0.0"`
4. Push tag: `git push origin v1.0.0`
5. GitHub Actions will build and create release

## Questions?

Feel free to open an issue for questions or discussions.

Thank you for contributing! 🎉

