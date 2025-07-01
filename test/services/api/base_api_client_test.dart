import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
import 'base_api_client_test.mocks.dart';

void main() {
  group('BaseApiClient', () {
    late BaseApiClient apiClient;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      // Mock the interceptors property to prevent errors
      when(mockDio.interceptors).thenReturn(Interceptors());
      apiClient = BaseApiClient(dio: mockDio);
    });

    group('GET requests', () {
      test('should make successful GET request with correct headers', () async {
        // Given: API endpoint and expected response
        const endpoint = '/api/test';
        final responseData = {'status': 'success'};
        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: endpoint),
        );

        when(mockDio.get(
          any,
          options: anyNamed('options'),
        )).thenAnswer((_) async => response);

        // When: Make GET request
        final result = await apiClient.get(endpoint);

        // Then: Verify correct request made
        expect(result, equals(responseData));
        verify(mockDio.get(
          endpoint,
          queryParameters: null,
          options: anyNamed('options'),
        )).called(1);
      });

      test('should throw ApiException on network error', () async {
        // Given: Network error
        const endpoint = '/api/test';
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: endpoint),
          type: DioExceptionType.connectionTimeout,
        ));

        // When/Then: Expect ApiException
        expect(
          () => apiClient.get(endpoint),
          throwsA(isA<ApiException>()),
        );
      });
    });

    group('POST requests', () {
      test('should make successful POST request with data', () async {
        // Given: Endpoint, request data, and response
        const endpoint = '/api/test';
        final requestData = {'name': 'Test'};
        final responseData = {'id': 1, 'name': 'Test'};
        final response = Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: endpoint),
        );

        when(mockDio.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => response);

        // When: Make POST request
        final result = await apiClient.post(endpoint, data: requestData);

        // Then: Verify correct request made
        expect(result, equals(responseData));
        verify(mockDio.post(
          endpoint,
          data: requestData,
          options: anyNamed('options'),
        )).called(1);
      });
    });

    group('Error handling', () {
      test('should handle 401 unauthorized error', () async {
        // Given: 401 response
        const endpoint = '/api/test';
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: endpoint),
          ),
          requestOptions: RequestOptions(path: endpoint),
        );

        when(mockDio.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
            .thenThrow(dioError);

        // When/Then: Expect UnauthorizedException
        expect(
          () => apiClient.get(endpoint),
          throwsA(isA<UnauthorizedException>()),
        );
      });

      test('should handle 404 not found error', () async {
        // Given: 404 response
        const endpoint = '/api/test';
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: endpoint),
          ),
          requestOptions: RequestOptions(path: endpoint),
        );

        when(mockDio.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
            .thenThrow(dioError);

        // When/Then: Expect NotFoundException
        expect(
          () => apiClient.get(endpoint),
          throwsA(isA<NotFoundException>()),
        );
      });
    });
  });
}