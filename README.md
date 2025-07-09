# KiokuNavi - Memory Navigation Learning App

A Flutter-based educational app designed to help students learn and retain knowledge through interactive quizzes and spaced repetition.

## Features

- **Multi-User Support**: Separate login for students and parents
- **Interactive Quizzes**: Multiple question formats (single choice, multiple choice, matching, sequence, numeric input)
- **Progress Tracking**: Track learning progress and quiz history
- **Offline Support**: Continue learning even without internet connection
- **Secure Authentication**: JWT-based authentication with automatic token refresh

## Getting Started

### Prerequisites

- Flutter SDK: ^3.5.0
- Dart SDK: ^3.5.0
- iOS: Deployment target 12.0+
- Android: Min SDK version 21

### Installation

1. Clone the repository:
```bash
git clone https://github.com/nomatake/KiokuNaviApp.git
cd KiokuNaviApp
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate mock files for testing:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Configure the API endpoint in `lib/utils/constants.dart`:
```dart
const String kBaseUrl = 'https://your-api-domain.com';
```

### Running the App

```bash
# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Run on specific device
flutter run -d device_id
```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/services/auth/login_service_test.dart
```

## Architecture

The app follows a clean architecture pattern with GetX for state management:

```
lib/
├── app/
│   ├── bindings/      # Dependency injection
│   ├── modules/       # Feature modules
│   └── routes/        # Navigation routes
├── controllers/       # GetX controllers
├── models/           # Data models
├── repositories/     # Data persistence
├── services/         # Business logic
│   ├── api/         # API clients
│   ├── auth/        # Authentication
│   └── quiz/        # Quiz functionality
├── widgets/          # Reusable widgets
└── utils/           # Utilities and constants
```

## Backend Integration

The app integrates with a Laravel backend API. See [Backend Integration Documentation](docs/BACKEND_INTEGRATION.md) for detailed information about:

- API endpoints
- Authentication flow
- Error handling
- Testing strategies

## Key Technologies

- **Flutter**: Cross-platform mobile framework
- **GetX**: State management and dependency injection
- **Dio**: HTTP client
- **Flutter Secure Storage**: Secure token storage
- **Mockito**: Unit testing framework

## Development Workflow

1. **Feature Development**: Create feature branches from `main`
2. **Testing**: Write tests using TDD approach
3. **Code Quality**: Run `flutter analyze` before committing
4. **Pull Requests**: Submit PRs for code review

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Testing Guidelines

- Follow TDD (Test-Driven Development) approach
- Write unit tests for all services and controllers
- Include integration tests for critical flows
- Maintain test coverage above 80%

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

## License

This project is proprietary software. All rights reserved.

## Support

For support and questions, please contact the development team.