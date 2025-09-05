import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  // Handle exceptions
  void handleException(Object exception, StackTrace stackTrace,
      {String? context}) {
    // Log the exception
    _logger.e(
      'Exception occurred${context != null ? ' in $context' : ''}',
      error: exception,
      stackTrace: stackTrace,
    );

    // In production, you might want to send this to a crash reporting service
    // like Sentry, Crashlytics, etc.
    if (kReleaseMode) {
      // Send to remote error tracking service
      _sendToErrorTrackingService(exception, stackTrace, context: context);
    }
  }

  // Handle errors
  void handleError(Error error, {String? context}) {
    // Log the error
    _logger.e(
      'Error occurred${context != null ? ' in $context' : ''}',
      error: error,
      stackTrace: error.stackTrace ?? StackTrace.current,
    );

    // In production, you might want to send this to a crash reporting service
    if (kReleaseMode) {
      // Send to remote error tracking service
      _sendToErrorTrackingService(error, error.stackTrace ?? StackTrace.current,
          context: context);
    }
  }

  // Handle HTTP errors
  void handleHttpError(
    Object error,
    StackTrace stackTrace, {
    String? endpoint,
    int? statusCode,
    String? responseBody,
    String? context,
  }) {
    // Log the HTTP error
    _logger.e(
      'HTTP Error${context != null ? ' in $context' : ''}${endpoint != null ? ' at $endpoint' : ''}',
      error: {
        'status_code': statusCode,
        'response_body': responseBody,
        'error': error.toString(),
      },
      stackTrace: stackTrace,
    );

    // In production, send to remote error tracking service
    if (kReleaseMode) {
      _sendToErrorTrackingService(
        error,
        stackTrace,
        context: context,
        additionalData: {
          'endpoint': endpoint,
          'status_code': statusCode,
          'response_body': responseBody,
        },
      );
    }
  }

  // Handle network errors
  void handleNetworkError(
    Object error,
    StackTrace stackTrace, {
    String? context,
    String? url,
  }) {
    // Log the network error
    _logger.e(
      'Network Error${context != null ? ' in $context' : ''}${url != null ? ' for $url' : ''}',
      error: error,
      stackTrace: stackTrace,
    );

    // In production, send to remote error tracking service
    if (kReleaseMode) {
      _sendToErrorTrackingService(
        error,
        stackTrace,
        context: context,
        additionalData: {
          'url': url,
        },
      );
    }
  }

  // Handle database errors
  void handleDatabaseError(
    Object error,
    StackTrace stackTrace, {
    String? context,
    String? operation,
    String? tableName,
  }) {
    // Log the database error
    _logger.e(
      'Database Error${context != null ? ' in $context' : ''}${operation != null ? ' during $operation' : ''}',
      error: {
        'operation': operation,
        'table_name': tableName,
        'error': error.toString(),
      },
      stackTrace: stackTrace,
    );

    // In production, send to remote error tracking service
    if (kReleaseMode) {
      _sendToErrorTrackingService(
        error,
        stackTrace,
        context: context,
        additionalData: {
          'operation': operation,
          'table_name': tableName,
        },
      );
    }
  }

  // Handle timeout errors
  void handleTimeoutError(
    TimeoutException exception, {
    String? context,
    Duration? timeout,
  }) {
    // Log the timeout error
    _logger.w(
      'Timeout Error${context != null ? ' in $context' : ''}: ${exception.message}',
      error: {
        'timeout': timeout?.inMilliseconds,
      },
    );

    // In production, you might want to track timeouts separately
    if (kReleaseMode) {
      _sendToErrorTrackingService(
        exception,
        StackTrace.current,
        context: context,
        additionalData: {
          'timeout': timeout?.inMilliseconds,
          'message': exception.message,
        },
        isError: false, // Treat timeouts as warnings, not errors
      );
    }
  }

  // Handle platform errors
  void handlePlatformError(
    PlatformException exception, {
    String? context,
    String? operation,
  }) {
    // Log the platform error
    _logger.e(
      'Platform Error${context != null ? ' in $context' : ''}${operation != null ? ' during $operation' : ''}',
      error: {
        'code': exception.code,
        'message': exception.message,
        'details': exception.details,
      },
    );

    // In production, send to remote error tracking service
    if (kReleaseMode) {
      _sendToErrorTrackingService(
        exception,
        StackTrace.current,
        context: context,
        additionalData: {
          'code': exception.code,
          'message': exception.message,
          'details': exception.details,
          'operation': operation,
        },
      );
    }
  }

  // Handle custom app errors
  void handleAppError(
    AppError error, {
    String? context,
  }) {
    // Log the custom app error
    _logger.e(
      'App Error${context != null ? ' in $context' : ''}',
      error: {
        'error_code': error.errorCode,
        'message': error.message,
        'details': error.details,
      },
    );

    // In production, send to remote error tracking service
    if (kReleaseMode) {
      _sendToErrorTrackingService(
        error,
        StackTrace.current,
        context: context,
        additionalData: {
          'error_code': error.errorCode,
          'message': error.message,
          'details': error.details,
        },
      );
    }
  }

  // Send error to remote tracking service
  Future<void> _sendToErrorTrackingService(
    Object error,
    StackTrace stackTrace, {
    String? context,
    Map<String, dynamic>? additionalData,
    bool isError = true,
  }) async {
    try {
      // In a real app, this would send to a service like Sentry, Crashlytics, etc.
      // For example, with Sentry:
      /*
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setContexts('additional_data', additionalData ?? {});
          scope.setContexts('context', {'context': context});
          scope.setLevel(isError ? SentryLevel.error : SentryLevel.warning);
        },
      );
      */

      // For now, we'll just log that we would send to a service
      _logger.i(
        'Would send error to remote tracking service (disabled in demo): $error',
        error: {
          'context': context,
          'additional_data': additionalData,
          'is_error': isError,
        },
      );
    } catch (e) {
      // If sending to error tracking service fails, log it but don't crash
      _logger.w(
        'Failed to send error to remote tracking service',
        error: e,
      );
    }
  }

  // Log info messages
  void logInfo(String message, [Object? object]) {
    _logger.i(message, error: object);
  }

  // Log warning messages
  void logWarning(String message, [Object? object]) {
    _logger.w(message, error: object);
  }

  // Log debug messages (only in debug mode)
  void logDebug(String message, [Object? object]) {
    if (kDebugMode) {
      _logger.d(message, error: object);
    }
  }

  // Record performance metrics
  void recordPerformanceMetric(
    String metricName,
    Duration duration, {
    Map<String, dynamic>? metadata,
  }) {
    // Log performance metrics
    _logger.i(
      'Performance Metric: $metricName',
      error: {
        'duration_ms': duration.inMilliseconds,
        'duration_us': duration.inMicroseconds,
        ...?metadata,
      },
    );

    // In production, you might want to send performance metrics to analytics
    if (kReleaseMode) {
      // Send to analytics service
      // _analyticsService.trackAppPerformance(
      //   metric: metricName,
      //   value: duration.inMilliseconds.toDouble(),
      //   category: 'performance',
      // );
    }
  }

  // Record user action
  void recordUserAction(
    String action,
    String category, {
    Map<String, dynamic>? metadata,
  }) {
    // Log user action
    _logger.i(
      'User Action: $action',
      error: {
        'category': category,
        ...?metadata,
      },
    );

    // In production, you might want to send user actions to analytics
    if (kReleaseMode) {
      // Send to analytics service
      // _analyticsService.trackUserEngagement(
      //   userId: _currentUser?.id ?? 'anonymous',
      //   action: action,
      //   metadata: {
      //     'category': category,
      //     ...?metadata,
      //   },
      // );
    }
  }

  // Handle fatal errors
  void handleFatalError(
    Object error,
    StackTrace stackTrace, {
    String? context,
  }) {
    // Log the fatal error
    _logger.f(
      'FATAL ERROR${context != null ? ' in $context' : ''}',
      error: error,
      stackTrace: stackTrace,
    );

    // In production, immediately send to error tracking service
    if (kReleaseMode) {
      _sendToErrorTrackingService(
        error,
        stackTrace,
        context: context,
        isError: true,
      );
    }

    // In a real app, you might want to show a fatal error screen
    // and possibly restart the app or exit gracefully
  }

  // Get logger instance for custom logging
  Logger get logger => _logger;
}

// Custom app error class
class AppError implements Exception {
  final String errorCode;
  final String message;
  final dynamic details;
  final DateTime timestamp;

  AppError({
    required this.errorCode,
    required this.message,
    this.details,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    return 'AppError{errorCode: $errorCode, message: $message, details: $details, timestamp: $timestamp}';
  }
}

// Extension on Future to handle errors easily
extension FutureErrorHandler<T> on Future<T> {
  Future<T> handleError({
    Function(Object error, StackTrace stackTrace)? onError,
    String? context,
  }) {
    return catchError((error, stackTrace) {
      ErrorHandler().handleException(error, stackTrace, context: context);
      if (onError != null) {
        return onError(error, stackTrace);
      }
      // Re-throw the error so it can be handled upstream
      Error.throwWithStackTrace(error, stackTrace);
    });
  }
}

// Extension on Stream to handle errors easily
extension StreamErrorHandler<T> on Stream<T> {
  Stream<T> handleError({
    Function(Object error, StackTrace stackTrace)? onError,
    String? context,
  }) {
    return transform(
      StreamTransformer.fromHandlers(
        handleError: (error, stackTrace, sink) {
          ErrorHandler().handleException(error, stackTrace, context: context);
          if (onError != null) {
            onError(error, stackTrace);
          }
          // Close the sink to stop the stream
          sink.close();
        },
      ),
    );
  }
}

// Performance timer utility
class PerformanceTimer {
  final String _name;
  final Map<String, dynamic>? _metadata;
  late final DateTime _startTime;

  PerformanceTimer(this._name, [this._metadata]);

  void start() {
    _startTime = DateTime.now();
  }

  void stop() {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime);
    ErrorHandler().recordPerformanceMetric(
      _name,
      duration,
      metadata: _metadata,
    );
  }

  // Convenience method to time a function
  static Future<T> timeAsync<T>(
    Future<T> Function() function,
    String name, {
    Map<String, dynamic>? metadata,
  }) async {
    final timer = PerformanceTimer(name, metadata);
    timer.start();
    try {
      final result = await function();
      return result;
    } finally {
      timer.stop();
    }
  }

  // Convenience method to time a synchronous function
  static T timeSync<T>(
    T Function() function,
    String name, {
    Map<String, dynamic>? metadata,
  }) {
    final timer = PerformanceTimer(name, metadata);
    timer.start();
    try {
      final result = function();
      return result;
    } finally {
      timer.stop();
    }
  }
}
