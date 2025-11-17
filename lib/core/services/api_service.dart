import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add interceptors for logging, token refresh, etc.
  static void setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add token to headers if needed
          // options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          _handleError(error);
          return handler.next(error);
        },
      ),
    );

    // Add logging interceptor
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  // GET request
  static Future<Response?> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    }
  }

  // POST request
  static Future<Response?> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    }
  }

  // PUT request
  static Future<Response?> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    }
  }

  // DELETE request
  static Future<Response?> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    }
  }

  // Upload file
  static Future<Response?> uploadFile(
    String endpoint,
    String filePath, {
    Map<String, dynamic>? data,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        ...?data,
      });

      final response = await _dio.post(endpoint, data: formData);
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    }
  }

  // Download file
  static Future<bool> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(url, savePath, onReceiveProgress: onReceiveProgress);
      return true;
    } on DioException catch (e) {
      _handleDioError(e);
      return false;
    }
  }

  // Error handling
  static void _handleError(DioException error) {
    String errorMessage;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleBadResponse(error.response);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;
      default:
        errorMessage = 'Network error occurred';
    }

    print('API Error: $errorMessage');
  }

  static String _handleBadResponse(Response? response) {
    if (response == null) return 'Unknown error';

    switch (response.statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Error ${response.statusCode}';
    }
  }

  static void _handleDioError(DioException e) {
    _handleError(e);
  }
}
