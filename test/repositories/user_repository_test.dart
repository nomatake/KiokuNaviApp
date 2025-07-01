import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kioku_navi/repositories/user_repository.dart';
import 'package:kioku_navi/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>()])
import 'user_repository_test.mocks.dart';

void main() {
  group('UserRepository', () {
    late UserRepository userRepository;
    late MockFlutterSecureStorage mockStorage;
    
    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      userRepository = UserRepository(storage: mockStorage);
    });
    
    group('User Storage', () {
      test('should save user data', () async {
        // Given: A user object
        final user = User(
          id: 1,
          name: '山田太郎',
          type: UserType.student,
          studentId: 'STU001',
          grade: 5,
        );
        
        // When: Save user
        await userRepository.saveUser(user);
        
        // Then: User data is saved to secure storage
        verify(mockStorage.write(
          key: 'current_user',
          value: argThat(contains('"id":1'), named: 'value'),
        )).called(1);
      });
      
      test('should retrieve saved user', () async {
        // Given: User data in storage
        const userJson = '''
        {
          "id": 1,
          "name": "山田太郎",
          "type": "student",
          "student_id": "STU001",
          "grade": 5
        }
        ''';
        
        when(mockStorage.read(key: 'current_user'))
            .thenAnswer((_) async => userJson);
        
        // When: Get current user
        final user = await userRepository.getCurrentUser();
        
        // Then: User is retrieved correctly
        expect(user, isNotNull);
        expect(user!.id, equals(1));
        expect(user.name, equals('山田太郎'));
        expect(user.type, equals(UserType.student));
      });
      
      test('should return null when no user saved', () async {
        // Given: No user data in storage
        when(mockStorage.read(key: 'current_user'))
            .thenAnswer((_) async => null);
        
        // When: Get current user
        final user = await userRepository.getCurrentUser();
        
        // Then: Returns null
        expect(user, isNull);
      });
    });
    
    group('User Deletion', () {
      test('should clear user data', () async {
        // When: Clear user
        await userRepository.clearUser();
        
        // Then: User data is deleted from storage
        verify(mockStorage.delete(key: 'current_user')).called(1);
      });
    });
    
    group('User Stream', () {
      test('should emit user changes', () async {
        // Given: A user object
        final user = User(
          id: 1,
          name: '山田太郎',
          type: UserType.student,
          studentId: 'STU001',
          grade: 5,
        );
        
        // Setup: Mock storage write
        when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
            .thenAnswer((_) async => {});
        
        // Create a new repository to avoid initial null event
        final newRepository = UserRepository(storage: mockStorage);
        
        // When: Listen to stream first
        User? emittedUser;
        final subscription = newRepository.userStream.listen((event) {
          if (event != null) {
            emittedUser = event;
          }
        });
        
        // Save user
        await newRepository.saveUser(user);
        
        // Allow stream to emit
        await Future.delayed(Duration(milliseconds: 100));
        
        // Then: User is emitted to stream
        expect(emittedUser?.id, equals(user.id));
        
        // Cleanup
        await subscription.cancel();
        newRepository.dispose();
      });
    });
  });
}