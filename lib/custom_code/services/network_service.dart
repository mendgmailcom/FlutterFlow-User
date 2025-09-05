import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import '../services/error_handler.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  late Dio _dio;
  late Dio _authDio;
  String? _authToken;
  final Connectivity _connectivity = Connectivity();

  // Initialize the network service
  Future<void> initialize() async {
    // Initialize Dio instances
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.handyhelp.app/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));

    // Initialize authenticated Dio instance
    _authDio = Dio(BaseOptions(
      baseUrl: 'https://api.handyhelp.app/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors to auth Dio
    _authDio.interceptors.add(InterceptorsWrapper(
      onRequest: _onAuthRequest,
      onResponse: _onResponse,
      onError: _onAuthError,
    ));

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ));

      _authDio.interceptors.add(LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ));
    }
  }

  // Request interceptor
  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ErrorHandler()
        .logDebug('Network Request: ${options.method} ${options.uri}');
    handler.next(options);
  }

  // Authenticated request interceptor
  void _onAuthRequest(
      RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token to headers
    if (_authToken != null) {
      options.headers['Authorization'] = 'Bearer $_authToken';
    }
    ErrorHandler().logDebug(
        'Authenticated Network Request: ${options.method} ${options.uri}');
    handler.next(options);
  }

  // Response interceptor
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    ErrorHandler().logDebug(
        'Network Response: ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  // Error interceptor
  void _onError(DioException error, ErrorInterceptorHandler handler) {
    ErrorHandler().handleHttpError(
      error,
      error.stackTrace,
      endpoint: error.requestOptions.uri.toString(),
      statusCode: error.response?.statusCode,
      responseBody: error.response?.data?.toString(),
      context: 'Network request failed',
    );
    handler.next(error);
  }

  // Authenticated error interceptor
  void _onAuthError(DioException error, ErrorInterceptorHandler handler) {
    ErrorHandler().handleHttpError(
      error,
      error.stackTrace,
      endpoint: error.requestOptions.uri.toString(),
      statusCode: error.response?.statusCode,
      responseBody: error.response?.data?.toString(),
      context: 'Authenticated network request failed',
    );

    // If unauthorized, clear auth token
    if (error.response?.statusCode == 401) {
      _authToken = null;
      // Notify app to redirect to login (TODO: implement)
    }

    handler.next(error);
  }

  // Set authentication token
  void setAuthToken(String? token) {
    _authToken = token;
  }

  // Clear authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  // Check internet connectivity
  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Check if connected to WiFi
  Future<bool> isConnectedToWiFi() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.wifi;
  }

  // Check if connected to mobile data
  Future<bool> isConnectedToMobileData() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile;
  }

  // Get connectivity stream
  Stream<ConnectivityResult> get connectivityStream {
    return _connectivity.onConnectivityChanged;
  }

  // Make GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (!await isConnected()) {
      throw DioException(
        error: 'No internet connection',
        requestOptions: RequestOptions(path: path),
      );
    }

    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options?.copyWith(headers: {
        ...?headers,
        ...?options.headers,
      }),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // Make POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (!await isConnected()) {
      throw DioException(
        error: 'No internet connection',
        requestOptions: RequestOptions(path: path),
      );
    }

    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options?.copyWith(headers: {
        ...?headers,
        ...?options.headers,
      }),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // Make PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (!await isConnected()) {
      throw DioException(
        error: 'No internet connection',
        requestOptions: RequestOptions(path: path),
      );
    }

    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options?.copyWith(headers: {
        ...?headers,
        ...?options.headers,
      }),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // Make DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!await isConnected()) {
      throw DioException(
        error: 'No internet connection',
        requestOptions: RequestOptions(path: path),
      );
    }

    return await _dio.delete<T>(
      path,
      queryParameters: queryParameters,
      options: options?.copyWith(headers: {
        ...?headers,
        ...?options.headers,
      }),
      cancelToken: cancelToken,
    );
  }

  // Make authenticated GET request
  Future<Response<T>> authGet<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (!await isConnected()) {
      throw DioException(
        error: 'No internet connection',
        requestOptions: RequestOptions(path: path),
      );
    }

    if (_authToken == null) {
      throw DioException(
        error: 'No authentication token',
        requestOptions: RequestOptions(path: path),
      );
    }

    return await _authDio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options?.copyWith(headers: {
        ...?headers,
        ...?options.headers,
      }),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // Make authenticated POST request
  Future<Response<T>> authPost<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (!await isConnected()) {
      throw DioException(
        error: 'No internet connection',
        requestOptions: RequestOptions(path: path),
      );
    }

    if (_authToken == null) {
      throw DioException(
        error: 'No authentication token',
        requestOptions: RequestOptions(path: path),
      );
    }

    return await _authDio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options?.copyWith(headers: {
        ...?headers,
        ...?options.headers,
      }),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // Make authenticated PUT request
  Future<Response<T>> authPut<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (!await isConnected()) {
      throw DioException(
        error: 'No internet connection',
        requestOptions: RequestOptions(path: path),
      );
    }

    if (_authToken == null) {
      throw DioException(
        error: 'No authentication token',
        requestOptions: RequestOptions(path: path),
      );
    }

    return await _authDio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options?.copyWith(headers: {
        ...?headers,
        ...?options.headers,
      }),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // Make authenticated DELETE request
  Future<Response<T>> authDelete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!await isConnected()) {
      throw DioException(
        error: 'No internet connection',
        requestOptions: RequestOptions(path: path),
      );
    }

    if (_authToken == null) {
      throw DioException(
        error: 'No authentication token',
        requestOptions: RequestOptions(path: path),
      );
    }

    return await _authDio.delete<T>(
      path,
      queryParameters: queryParameters,
      options: options?.copyWith(headers: {
        ...?headers,
        ...?options.headers,
      }),
      cancelToken: cancelToken,
    );
  }

  // Upload file
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    if (!await isConnected()) {
      throw DioException(
        error: 'No internet connection',
        requestOptions: RequestOptions(path: path),
      );
    }

    final formData = FormData();

    // Add file
    formData.files.add(MapEntry(
      'file',
      MultipartFile.fromFileSync(filePath),
    ));

    // Add additional data
    if (data != null) {
      formData.fields.addAll(data.entries.map((entry) => MapEntry(
            entry.key,
            entry.value.toString(),
          )));
    }

    return await _dio.post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: options?.copyWith(
        headers: {
          'Content-Type': 'multipart/form-data',
          ...?headers,
          ...?options.headers,
        },
      ),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  // Download file
  Future<Response> downloadFile(
    String url,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (!await isConnected()) {
      throw DioException(
        error: 'No internet connection',
        requestOptions: RequestOptions(path: url),
      );
    }

    return await _dio.download(
      url,
      savePath,
      queryParameters: queryParameters,
      options: options?.copyWith(headers: {
        ...?headers,
        ...?options.headers,
      }),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      deleteOnError: true,
    );
  }

  // Retry mechanism for failed requests
  Future<Response<T>> retry<T>(
    Future<Response<T>> Function() request, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    DioException? lastError;

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await request();
      } on DioException catch (e) {
        lastError = e;

        // Don't retry on client errors (4xx) or if it's the last attempt
        if (attempt == maxRetries ||
            (e.response?.statusCode != null &&
                e.response!.statusCode! >= 400 &&
                e.response!.statusCode! < 500)) {
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(delay * pow(2.0, attempt).toInt());
      }
    }

    // If we get here, all retries failed
    throw lastError!;
  }

  // Batch requests
  Future<List<Response>> batch(
      List<Future<Response> Function()> requests) async {
    return await Future.wait(requests.map((request) => request()));
  }

  // Cancel request
  void cancelRequest(CancelToken token) {
    token.cancel();
  }

  // Create cancel token
  CancelToken createCancelToken() {
    return CancelToken();
  }

  // Get Dio instance for custom requests
  Dio get dio => _dio;

  // Get authenticated Dio instance for custom requests
  Dio get authDio => _authDio;

  // Mock network requests for testing
  Future<Map<String, dynamic>> mockNetworkRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? requestData,
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    // Simulate network delay
    await Future.delayed(delay);

    // Generate mock response based on endpoint
    if (endpoint.contains('/services')) {
      return {
        'success': true,
        'data': List.generate(10 + Random().nextInt(10), (index) {
          return {
            'id': 'service_$index',
            'name': 'Service ${index + 1}',
            'description': 'Professional service description',
            'price': (500 + Random().nextInt(2000)).toDouble(),
            'rating': 4.0 + Random().nextDouble(),
            'category': 'category_${Random().nextInt(5) + 1}',
          };
        }),
        'meta': {
          'page': 1,
          'limit': 20,
          'total': 50,
        }
      };
    } else if (endpoint.contains('/providers')) {
      return {
        'success': true,
        'data': List.generate(8 + Random().nextInt(8), (index) {
          return {
            'id': 'provider_$index',
            'businessName': 'Provider ${index + 1}',
            'ownerName': 'Owner ${index + 1}',
            'description': 'Professional provider description',
            'rating': 4.2 + Random().nextDouble(),
            'isVerified': Random().nextBool(),
          };
        }),
        'meta': {
          'page': 1,
          'limit': 20,
          'total': 40,
        }
      };
    } else if (endpoint.contains('/bookings')) {
      return {
        'success': true,
        'data': List.generate(5 + Random().nextInt(10), (index) {
          final status = [
            'confirmed',
            'completed',
            'pending',
            'cancelled'
          ][Random().nextInt(4)];
          return {
            'id': 'booking_$index',
            'serviceId': 'service_${Random().nextInt(20)}',
            'serviceName': 'Service ${Random().nextInt(20) + 1}',
            'providerId': 'provider_${Random().nextInt(15)}',
            'providerName': 'Provider ${Random().nextInt(15) + 1}',
            'scheduledDate': DateTime.now()
                .add(Duration(days: Random().nextInt(14)))
                .toIso8601String(),
            'scheduledTime':
                '${(9 + Random().nextInt(8)).toString().padLeft(2, '0')}:${Random().nextBool() ? '00' : '30'}',
            'status': status,
            'totalAmount': (500 + Random().nextInt(3000)).toDouble(),
          };
        }),
        'meta': {
          'page': 1,
          'limit': 20,
          'total': 30,
        }
      };
    } else {
      return {
        'success': true,
        'data': {
          'message': 'Mock response for $endpoint',
          'method': method,
          'requestData': requestData,
        }
      };
    }
  }

  // Simulate network outage
  Future<void> simulateNetworkOutage(
      {Duration duration = const Duration(seconds: 5)}) async {
    ErrorHandler().logWarning(
        'Simulating network outage for ${duration.inSeconds} seconds');

    // This would typically disable network functionality temporarily
    // For demo purposes, we'll just wait
    await Future.delayed(duration);

    ErrorHandler().logInfo('Network outage simulation ended');
  }

  // Get network information
  Future<Map<String, dynamic>> getNetworkInfo() async {
    final connectivityResult = await _connectivity.checkConnectivity();

    return {
      'connectivity': connectivityResult.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
