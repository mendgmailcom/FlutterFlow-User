import 'dart:async';
import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Initialize analytics
  Future<void> initialize() async {
    // Set analytics collection enabled
    await _analytics.setAnalyticsCollectionEnabled(true);

    // Set user properties
    await setUserProperties({
      'app_version': '1.0.0',
      'platform': 'flutter',
    });
  }

  // Log screen view
  Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log user login
  Future<void> logLogin({String? method}) async {
    try {
      await _analytics.logLogin(loginMethod: method);
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log user signup
  Future<void> logSignUp({String? method}) async {
    try {
      await _analytics.logSignUp(signUpMethod: method ?? 'unknown');
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log search
  Future<void> logSearch({required String searchTerm}) async {
    try {
      await _analytics.logSearch(searchTerm: searchTerm);
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log view item (service or provider)
  Future<void> logViewItem({
    required String itemId,
    required String itemName,
    required String itemType,
    String? currency,
    double? value,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'view_item',
        parameters: {
          'item_id': itemId,
          'item_name': itemName,
          'content_type': itemType,
          if (currency != null) 'currency': currency,
          if (value != null) 'value': value,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log add to cart (booking creation)
  Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required String itemType,
    String? currency,
    double? value,
    int? quantity,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'add_to_cart',
        parameters: {
          'item_id': itemId,
          'item_name': itemName,
          'content_type': itemType,
          if (currency != null) 'currency': currency,
          if (value != null) 'value': value,
          if (quantity != null) 'quantity': quantity,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log begin checkout
  Future<void> logBeginCheckout({
    String? currency,
    double? value,
    List<AnalyticsEventItem>? items,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'begin_checkout',
        parameters: {
          if (currency != null) 'currency': currency,
          if (value != null) 'value': value,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log purchase
  Future<void> logPurchase({
    required String transactionId,
    required String currency,
    required double value,
    double? tax,
    double? shipping,
    List<AnalyticsEventItem>? items,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'purchase',
        parameters: {
          'transaction_id': transactionId,
          'currency': currency,
          'value': value,
          if (tax != null) 'tax': tax,
          if (shipping != null) 'shipping': shipping,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log booking creation
  Future<void> logBookingCreation({
    required String bookingId,
    required String serviceId,
    required String serviceName,
    required String providerId,
    required String providerName,
    required double amount,
    required String currency,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'booking_created',
        parameters: {
          'booking_id': bookingId,
          'service_id': serviceId,
          'service_name': serviceName,
          'provider_id': providerId,
          'provider_name': providerName,
          'amount': amount,
          'currency': currency,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log booking completion
  Future<void> logBookingCompletion({
    required String bookingId,
    required String serviceId,
    required String serviceName,
    required String providerId,
    required String providerName,
    required double amount,
    required String currency,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'booking_completed',
        parameters: {
          'booking_id': bookingId,
          'service_id': serviceId,
          'service_name': serviceName,
          'provider_id': providerId,
          'provider_name': providerName,
          'amount': amount,
          'currency': currency,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log booking cancellation
  Future<void> logBookingCancellation({
    required String bookingId,
    required String reason,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'booking_cancelled',
        parameters: {
          'booking_id': bookingId,
          'cancellation_reason': reason,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log service rating
  Future<void> logServiceRating({
    required String serviceId,
    required String serviceName,
    required String providerId,
    required String providerName,
    required double rating,
    String? review,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'service_rated',
        parameters: {
          'service_id': serviceId,
          'service_name': serviceName,
          'provider_id': providerId,
          'provider_name': providerName,
          'rating': rating,
          'review': review,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log chat initiation
  Future<void> logChatInitiation({
    required String chatId,
    required String bookingId,
    required String providerId,
    required String providerName,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'chat_started',
        parameters: {
          'chat_id': chatId,
          'booking_id': bookingId,
          'provider_id': providerId,
          'provider_name': providerName,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log payment initiation
  Future<void> logPaymentInitiation({
    required String paymentMethod,
    required double amount,
    required String currency,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'payment_started',
        parameters: {
          'payment_method': paymentMethod,
          'amount': amount,
          'currency': currency,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log payment completion
  Future<void> logPaymentCompletion({
    required String paymentMethod,
    required double amount,
    required String currency,
    required String transactionId,
    required String status,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'payment_completed',
        parameters: {
          'payment_method': paymentMethod,
          'amount': amount,
          'currency': currency,
          'transaction_id': transactionId,
          'status': status,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log wallet transaction
  Future<void> logWalletTransaction({
    required String transactionType,
    required double amount,
    required String currency,
    required String transactionId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'wallet_transaction',
        parameters: {
          'transaction_type': transactionType,
          'amount': amount,
          'currency': currency,
          'transaction_id': transactionId,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log user preference change
  Future<void> logPreferenceChange({
    required String preference,
    required String value,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'preference_changed',
        parameters: {
          'preference': preference,
          'value': value,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log app feature usage
  Future<void> logFeatureUsage({
    required String feature,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'feature_used',
        parameters: {
          'feature_name': feature,
          ...?parameters,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log error
  Future<void> logError({
    required String error,
    String? stackTrace,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'error_occurred',
        parameters: {
          'error_message': error,
          'stack_trace': stackTrace,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Set user ID
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Set user properties
  Future<void> setUserProperties(Map<String, String> properties) async {
    try {
      for (var entry in properties.entries) {
        await _analytics.setUserProperty(
          name: entry.key,
          value: entry.value,
        );
      }
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Set current screen
  Future<void> setCurrentScreen(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log custom event
  Future<void> logCustomEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log user session start
  Future<void> logSessionStart() async {
    try {
      await _analytics.logEvent(name: 'session_start');
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log user session end
  Future<void> logSessionEnd() async {
    try {
      await _analytics.logEvent(name: 'session_end');
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log app update
  Future<void> logAppUpdate({
    required String previousVersion,
    required String currentVersion,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'app_updated',
        parameters: {
          'previous_version': previousVersion,
          'current_version': currentVersion,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log referral
  Future<void> logReferral({
    required String referralSource,
    String? referralCode,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'user_referred',
        parameters: {
          'referral_source': referralSource,
          'referral_code': referralCode,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log social share
  Future<void> logSocialShare({
    required String contentType,
    required String itemId,
    required String method,
  }) async {
    try {
      await _analytics.logShare(
        contentType: contentType,
        itemId: itemId,
        method: method,
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log tutorial completion
  Future<void> logTutorialCompletion({
    String? tutorialName,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'tutorial_complete',
        parameters: {
          if (tutorialName != null) 'tutorial_name': tutorialName,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Log tutorial step
  Future<void> logTutorialStep({
    required int step,
    String? tutorialName,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'tutorial_begin',
        parameters: {
          'step': step,
          if (tutorialName != null) 'tutorial_name': tutorialName,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Get analytics instance
  FirebaseAnalytics get analytics => _analytics;

  // Generate mock analytics data for testing
  Future<Map<String, dynamic>> generateMockAnalyticsData() async {
    return {
      'total_users': 10000 + Random().nextInt(50000),
      'active_users': 5000 + Random().nextInt(25000),
      'bookings_completed': 20000 + Random().nextInt(80000),
      'total_revenue': (500000 + Random().nextInt(2000000)).toDouble(),
      'average_rating': 4.0 + Random().nextDouble(),
      'conversion_rate': 0.1 + Random().nextDouble() * 0.3,
      'retention_rate': 0.6 + Random().nextDouble() * 0.4,
      'top_services': [
        'Cleaning',
        'Plumbing',
        'Electrical',
        'Gardening',
        'Painting',
      ]..shuffle(),
      'top_providers': [
        'Clean & Shine',
        'Quick Fix Plumbing',
        'Electro Experts',
        'Green Thumb Gardening',
        'Perfect Painters',
      ]..shuffle(),
    };
  }

  // Track user engagement
  Future<void> trackUserEngagement({
    required String userId,
    required String action,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'user_engagement',
        parameters: {
          'user_id': userId,
          'action': action,
          'timestamp': DateTime.now().toIso8601String(),
          ...?metadata,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Track app performance
  Future<void> trackAppPerformance({
    required String metric,
    required double value,
    String? category,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'app_performance',
        parameters: {
          'metric': metric,
          'value': value,
          'category': category,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }

  // Track feature adoption
  Future<void> trackFeatureAdoption({
    required String feature,
    required bool adopted,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'feature_adoption',
        parameters: {
          'feature': feature,
          'adopted': adopted,
          'timestamp': DateTime.now().toIso8601String(),
          ...?metadata,
        },
      );
    } catch (e) {
      // Silently ignore analytics errors
    }
  }
}
