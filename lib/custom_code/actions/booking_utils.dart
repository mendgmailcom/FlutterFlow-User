import 'dart:async';
import 'dart:math';

class BookingUtils {
  // Simulate creating a booking
  static Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate successful booking creation
    final bookingId = 'booking_${Random().nextInt(100000)}';
    
    return {
      'success': true,
      'bookingId': bookingId,
      'bookingData': {
        ...bookingData,
        'id': bookingId,
        'status': 'confirmed',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      }
    };
  }

  // Simulate updating a booking
  static Future<Map<String, dynamic>> updateBooking(String bookingId, Map<String, dynamic> updateData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate successful booking update
    return {
      'success': true,
      'bookingId': bookingId,
      'bookingData': {
        'id': bookingId,
        ...updateData,
        'updatedAt': DateTime.now().toIso8601String(),
      }
    };
  }

  // Simulate cancelling a booking
  static Future<Map<String, dynamic>> cancelBooking(String bookingId, String reason) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate successful booking cancellation
    return {
      'success': true,
      'bookingId': bookingId,
      'message': 'Booking cancelled successfully',
      'refundStatus': 'processing',
    };
  }

  // Simulate rescheduling a booking
  static Future<Map<String, dynamic>> rescheduleBooking(String bookingId, DateTime newDateTime) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate successful booking rescheduling
    return {
      'success': true,
      'bookingId': bookingId,
      'newDateTime': newDateTime.toIso8601String(),
      'message': 'Booking rescheduled successfully',
    };
  }

  // Get available time slots for a service
  static Future<List<Map<String, dynamic>>> getAvailableTimeSlots(DateTime date) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate available time slots (9 AM to 6 PM with 1-hour intervals)
    final List<Map<String, dynamic>> slots = [];
    for (int hour = 9; hour <= 18; hour++) {
      // Randomly make some slots unavailable for demo
      if (Random().nextBool() || Random().nextBool()) {
        slots.add({
          'time': '${hour.toString().padLeft(2, '0')}:00',
          'isAvailable': true,
        });
        // Add half-hour slot if not at the end
        if (hour < 18) {
          slots.add({
            'time': '${hour.toString().padLeft(2, '0')}:30',
            'isAvailable': Random().nextBool(), // Random availability for half-hour slots
          });
        }
      }
    }
    
    return slots;
  }

  // Get booking details
  static Future<Map<String, dynamic>> getBookingDetails(String bookingId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Simulate booking details
    return {
      'id': bookingId,
      'serviceId': 'service_${Random().nextInt(100)}',
      'serviceName': 'Professional Cleaning Service',
      'providerId': 'provider_${Random().nextInt(100)}',
      'providerName': 'Clean & Shine Services',
      'scheduledDate': DateTime.now().add(Duration(days: Random().nextInt(7))).toIso8601String(),
      'scheduledTime': '${(9 + Random().nextInt(9)).toString().padLeft(2, '0')}:${Random().nextBool() ? '00' : '30'}',
      'serviceAddress': '123 Main Street, New York, NY 10001',
      'status': ['confirmed', 'completed', 'pending', 'cancelled'][Random().nextInt(4)],
      'totalAmount': (500 + Random().nextInt(2000)).toDouble(),
      'paymentMethod': ['Credit Card', 'Debit Card', 'Wallet', 'Cash'][Random().nextInt(4)],
      'paymentStatus': ['paid', 'pending', 'refunded'][Random().nextInt(3)],
      'specialInstructions': 'Please bring your own cleaning supplies if possible.',
      'addons': [
        {
          'id': 'addon_1',
          'name': 'Deep Cleaning',
          'price': 299.0,
        },
        {
          'id': 'addon_2',
          'name': 'Window Cleaning',
          'price': 199.0,
        }
      ],
      'createdAt': DateTime.now().subtract(Duration(days: Random().nextInt(7))).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  // Get user bookings
  static Future<List<Map<String, dynamic>>> getUserBookings({String? status, int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate mock bookings
    final List<Map<String, dynamic>> bookings = [];
    final int count = min(limit, 10); // Max 10 for demo
    
    for (int i = 0; i < count; i++) {
      final statuses = ['confirmed', 'completed', 'pending', 'cancelled'];
      final status = statuses[Random().nextInt(statuses.length)];
      
      bookings.add({
        'id': 'booking_$i',
        'serviceId': 'service_$i',
        'serviceName': 'Service ${i + 1}',
        'providerId': 'provider_$i',
        'providerName': 'Provider ${i + 1}',
        'scheduledDate': DateTime.now().add(Duration(days: i)).toIso8601String(),
        'scheduledTime': '${(9 + i % 9).toString().padLeft(2, '0')}:${i % 2 == 0 ? '00' : '30'}',
        'serviceAddress': '$i Main Street, New York, NY 1000$i',
        'status': status,
        'totalAmount': (500 + i * 100).toDouble(),
        'paymentMethod': ['Credit Card', 'Debit Card', 'Wallet', 'Cash'][i % 4],
        'paymentStatus': ['paid', 'pending', 'refunded'][i % 3],
        'createdAt': DateTime.now().subtract(Duration(days: i)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }
    
    // Filter by status if provided
    if (status != null) {
      return bookings.where((booking) => booking['status'] == status).toList();
    }
    
    return bookings;
  }

  // Add review for completed booking
  static Future<Map<String, dynamic>> addReview(String bookingId, int rating, String review) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate successful review submission
    return {
      'success': true,
      'reviewId': 'review_${Random().nextInt(10000)}',
      'message': 'Review submitted successfully',
    };
  }

  // Get booking status updates
  static Stream<Map<String, dynamic>> getBookingStatusStream(String bookingId) {
    return Stream.periodic(const Duration(seconds: 10), (count) {
      final statuses = ['confirmed', 'in_progress', 'completed', 'cancelled'];
      final status = statuses[min(count, statuses.length - 1)];
      
      return {
        'bookingId': bookingId,
        'status': status,
        'timestamp': DateTime.now().toIso8601String(),
        'message': 'Booking status updated to $status',
      };
    });
  }
}