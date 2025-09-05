import 'dart:async';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // iOS initialization settings
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    // Linux initialization settings
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    // All platforms initialization settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      linux: initializationSettingsLinux,
    );

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  // Callback for iOS notifications
  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    // Handle iOS notification tap
  }

  // Callback for notification tap
  void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      // Handle notification payload
    }
  }

  // Show a simple notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? channelId = 'default_channel',
    String? channelName = 'Default Channel',
    String? channelDescription = 'Default notification channel',
  }) async {
    // Android notification details
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId ?? 'default_channel',
      channelName ?? 'Default Channel',
      channelDescription: channelDescription ?? 'Default notification channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    // iOS notification details
    const DarwinNotificationDetails iOSNotificationDetails =
        DarwinNotificationDetails();

    // Linux notification details
    const LinuxNotificationDetails linuxNotificationDetails =
        LinuxNotificationDetails();

    // All platforms notification details
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
      linux: linuxNotificationDetails,
    );

    // Show the notification
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Schedule a notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // Android notification details
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Notifications scheduled for later',
      importance: Importance.max,
      priority: Priority.high,
    );

    // iOS notification details
    const DarwinNotificationDetails iOSNotificationDetails =
        DarwinNotificationDetails();

    // All platforms notification details
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    // Schedule the notification
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Show a booking reminder notification
  Future<void> showBookingReminderNotification({
    required int bookingId,
    required String serviceName,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    await showNotification(
      id: bookingId,
      title: 'Booking Reminder',
      body:
          'Your $serviceName booking is scheduled for ${_formatTime(scheduledTime)}. Don\'t forget to prepare!',
      payload: payload ?? 'booking_reminder_$bookingId',
      channelId: 'booking_reminders',
      channelName: 'Booking Reminders',
      channelDescription: 'Reminders for upcoming bookings',
    );
  }

  // Show a booking confirmation notification
  Future<void> showBookingConfirmationNotification({
    required int bookingId,
    required String serviceName,
    required String providerName,
    String? payload,
  }) async {
    await showNotification(
      id: bookingId + 1000000, // Different ID to avoid conflicts
      title: 'Booking Confirmed',
      body: 'Your $serviceName booking with $providerName has been confirmed!',
      payload: payload ?? 'booking_confirmation_$bookingId',
      channelId: 'booking_confirmations',
      channelName: 'Booking Confirmations',
      channelDescription: 'Confirmations for completed bookings',
    );
  }

  // Show a payment notification
  Future<void> showPaymentNotification({
    required int transactionId,
    required double amount,
    required String status,
    String? payload,
  }) async {
    await showNotification(
      id: transactionId,
      title: 'Payment ${status.capitalize()}',
      body: 'Your payment of ₹${amount.toStringAsFixed(2)} has been $status.',
      payload: payload ?? 'payment_$status _$transactionId',
      channelId: 'payments',
      channelName: 'Payments',
      channelDescription: 'Payment-related notifications',
    );
  }

  // Show a chat message notification
  Future<void> showChatMessageNotification({
    required int chatId,
    required String senderName,
    required String message,
    String? payload,
  }) async {
    await showNotification(
      id: chatId,
      title: senderName,
      body: message,
      payload: payload ?? 'chat_message_$chatId',
      channelId: 'chat_messages',
      channelName: 'Chat Messages',
      channelDescription: 'Messages from service providers',
    );
  }

  // Show a promotional notification
  Future<void> showPromotionalNotification({
    required int promoId,
    required String title,
    required String description,
    String? payload,
  }) async {
    await showNotification(
      id: promoId + 2000000, // Different ID range to avoid conflicts
      title: title,
      body: description,
      payload: payload ?? 'promotion_$promoId',
      channelId: 'promotions',
      channelName: 'Promotions',
      channelDescription: 'Special offers and promotions',
    );
  }

  // Show a review reminder notification
  Future<void> showReviewReminderNotification({
    required int bookingId,
    required String serviceName,
    String? payload,
  }) async {
    await showNotification(
      id: bookingId + 3000000, // Different ID range to avoid conflicts
      title: 'Leave a Review',
      body: 'How was your $serviceName experience? Share your feedback!',
      payload: payload ?? 'review_reminder_$bookingId',
      channelId: 'reviews',
      channelName: 'Reviews',
      channelDescription: 'Review reminders',
    );
  }

  // Show a wallet update notification
  Future<void> showWalletUpdateNotification({
    required int transactionId,
    required double amount,
    required String type, // 'credit' or 'debit'
    String? payload,
  }) async {
    await showNotification(
      id: transactionId + 4000000, // Different ID range to avoid conflicts
      title: type == 'credit' ? 'Money Added' : 'Money Deducted',
      body:
          '₹${amount.toStringAsFixed(2)} has been ${type == 'credit' ? 'added to' : 'deducted from'} your wallet.',
      payload: payload ?? 'wallet_update_$transactionId',
      channelId: 'wallet_updates',
      channelName: 'Wallet Updates',
      channelDescription: 'Wallet balance updates',
    );
  }

  // Cancel a notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    return await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
        true;
  }

  // Request notification permissions
  Future<bool> requestPermissions() async {
    // Android doesn't require permission requests
    if (await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
        true) {
      return true;
    }

    // Linux permissions not supported in this version
    return false;
  }

  // Get pending notification count
  Future<int> getPendingNotificationCount() async {
    return 0; // Not supported in this version
  }

  // Format time for display
  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  // Generate a random notification for testing
  Future<void> showRandomTestNotification() async {
    final titles = [
      'New Message',
      'Booking Update',
      'Special Offer',
      'Payment Received',
      'Reminder',
      'Important Update',
      'New Feature',
      'Weekly Summary'
    ];

    final bodies = [
      'You have a new message from your service provider.',
      'Your booking status has been updated.',
      'Check out our exclusive offer just for you!',
      '₹${(100 + Random().nextInt(1000)).toDouble().toStringAsFixed(2)} has been credited to your wallet.',
      'Don\'t forget your upcoming appointment.',
      'Important update about our services.',
      'Try our new feature now available.',
      'Here\'s your weekly service summary.'
    ];

    final randomIndex = Random().nextInt(titles.length);

    await showNotification(
      id: Random().nextInt(1000000),
      title: titles[randomIndex],
      body: bodies[randomIndex],
      channelId: 'test_notifications',
      channelName: 'Test Notifications',
      channelDescription: 'Test notifications for development',
    );
  }
}

// Extension to capitalize strings
extension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
