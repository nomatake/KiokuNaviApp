# Backend Integration Documentation

## Overview

This document describes the backend integration architecture for the KiokuNavi app, including API services, authentication, and quiz functionality.

## Architecture

### Service Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                       Controllers                            │
│  AuthController        QuizController                        │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────┴────────────────────────────────────┐
│                       Services                               │
│  LoginService     QuestionService     AnswerValidator       │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────┴────────────────────────────────────┐
│                    Repositories                              │
│  UserRepository              QuizRepository                  │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────┴────────────────────────────────────┐
│                    API Services                              │
│  AuthApiImpl          QuizApiImpl         TokenManagerImpl   │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────┴────────────────────────────────────┐
│                   Base API Client                            │
│  BaseApiClient     AuthInterceptor                           │
└─────────────────────────────────────────────────────────────┘
```

## Key Components

### 1. Base API Infrastructure

#### BaseApiClient
- Centralized HTTP client using Dio
- Configurable timeouts and base URL
- Error handling and logging
- Support for GET, POST, PUT, DELETE operations

#### AuthInterceptor
- Automatic token injection for authenticated requests
- Token refresh on 401 errors
- Public endpoint bypass

### 2. Authentication System

#### TokenManager
- Secure token storage using FlutterSecureStorage
- Token caching for performance
- Automatic token refresh

#### LoginService
- Student and parent login support
- Login attempt tracking
- Account lockout mechanism
- Session restoration

#### AuthController
- GetX reactive state management
- User authentication state
- Error handling

### 3. Quiz Feature

#### QuestionService
- Question fetching by curriculum/concept
- Quiz generation with configuration
- Intelligent caching with expiration

#### QuizRepository
- Quiz session persistence
- History tracking (max 50 sessions)
- User statistics calculation

#### QuizController
- Quiz session management
- Progress tracking
- Answer validation
- Session restoration

#### AnswerValidator
- Support for all question formats:
  - Single choice
  - Multiple choice
  - Numeric input
  - Sequence
  - Matching

## Configuration

### Environment Setup

1. Update the base URL in `lib/utils/constants.dart`:
```dart
const String kBaseUrl = 'https://your-api-domain.com';
```

2. Configure GetX bindings in `lib/app/bindings/service_binding.dart`

3. Add the service binding to your main app:
```dart
GetMaterialApp(
  initialBinding: ServiceBinding(),
  // ... other configurations
)
```

## API Endpoints

### Authentication
- `POST /api/auth/student/login` - Student login
- `POST /api/auth/parent/login` - Parent login
- `POST /api/auth/logout` - Logout
- `GET /api/auth/user` - Get current user

### Quiz
- `GET /api/questions/curriculum/{id}` - Get questions by curriculum
- `GET /api/questions/concept/{id}` - Get questions by concept
- `POST /api/quiz/generate` - Generate quiz
- `POST /api/quiz/answer` - Submit answer
- `GET /api/quiz/history` - Get quiz history

## Error Handling

The system includes comprehensive error handling:

1. **Network Errors**: Connection timeouts, no internet
2. **Authentication Errors**: Invalid credentials, token expiration
3. **Validation Errors**: Invalid input data
4. **Server Errors**: 500 errors with proper messaging

## Testing

### Unit Tests
All components have comprehensive unit tests using Mockito:
- Service tests
- Repository tests
- Controller tests
- Validator tests

### Integration Tests
Integration tests verify the complete flow:
- Authentication flow
- Quiz session flow
- Error handling scenarios

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/auth/login_service_test.dart

# Run with coverage
flutter test --coverage
```

## Security Considerations

1. **Token Storage**: All tokens stored in FlutterSecureStorage
2. **Public Endpoints**: Defined list of endpoints that don't require auth
3. **Token Refresh**: Automatic refresh before expiration
4. **Sensitive Data**: No logging of passwords or tokens

## Performance Optimizations

1. **Caching**: Question data cached for 1 hour
2. **Token Caching**: In-memory token cache to reduce storage reads
3. **Batch Operations**: Multiple API calls can be batched
4. **Lazy Loading**: Services loaded only when needed via GetX

## Troubleshooting

### Common Issues

1. **401 Unauthorized**
   - Check if token is expired
   - Verify token is being sent in headers
   - Check if endpoint requires authentication

2. **Network Timeout**
   - Increase timeout in BaseApiClient
   - Check network connectivity
   - Verify API server is running

3. **Mock Errors in Tests**
   - Ensure all methods are properly mocked
   - Check for GetX lifecycle method stubs
   - Verify mock return values

## Future Enhancements

1. **Offline Support**: Cache data for offline access
2. **Real-time Updates**: WebSocket support for live quiz sessions
3. **Analytics**: Track user behavior and quiz performance
4. **Push Notifications**: Quiz reminders and achievements