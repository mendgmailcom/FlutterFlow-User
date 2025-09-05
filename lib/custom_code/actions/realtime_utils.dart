import 'dart:async';
import 'dart:math';

class RealtimeUtils {
  // Simulate real-time data fetching
  static Stream<List<Map<String, dynamic>>> getServicesStream() {
    return Stream.periodic(const Duration(seconds: 5), (count) {
      return List.generate(5, (index) {
        return {
          'id': 'service_${count * 5 + index}',
          'title': 'Service ${count * 5 + index + 1}',
          'description':
              'Professional service description for service ${count * 5 + index + 1}',
          'price': '₹${(500 + Random().nextInt(2000)).toString()}',
          'rating': 4.0 + Random().nextDouble() * 1.0,
          'imageUrl':
              'https://picsum.photos/400/300?random=${count * 5 + index}',
          'isFeatured': index == 0,
        };
      });
    });
  }

  // Simulate real-time booking updates
  static Stream<List<Map<String, dynamic>>> getBookingsStream() {
    return Stream.periodic(const Duration(seconds: 10), (count) {
      return List.generate(3, (index) {
        final statuses = ['confirmed', 'completed', 'pending', 'cancelled'];
        final status = statuses[Random().nextInt(statuses.length)];

        return {
          'id': 'booking_${count * 3 + index}',
          'serviceName': 'Service ${count * 3 + index + 1}',
          'providerName': 'Provider ${count * 3 + index + 1}',
          'date':
              '${1 + Random().nextInt(30)}/${1 + Random().nextInt(12)}/2023',
          'time':
              '${8 + Random().nextInt(10)}:${Random().nextBool() ? '00' : '30'}',
          'status': status,
          'amount': '₹${(500 + Random().nextInt(3000)).toString()}',
        };
      });
    });
  }

  // Simulate real-time chat messages
  static Stream<Map<String, dynamic>> getChatMessagesStream() {
    return Stream.periodic(const Duration(seconds: 3), (count) {
      final isSentByMe = Random().nextBool();
      return {
        'id': 'message_$count',
        'message': isSentByMe
            ? [
                'Hello!',
                'How are you?',
                'Can you help me?',
                'Thanks!',
                'See you soon!'
              ][Random().nextInt(5)]
            : [
                'Hi there!',
                'Sure, I can help.',
                'What do you need?',
                'You\'re welcome!',
                'Bye!'
              ][Random().nextInt(5)],
        'timestamp': DateTime.now().toString(),
        'isSentByMe': isSentByMe,
        'senderName': isSentByMe ? null : 'Service Provider',
      };
    });
  }

  // Simulate real-time wallet updates
  static Stream<Map<String, dynamic>> getWalletUpdatesStream() {
    return Stream.periodic(const Duration(seconds: 15), (count) {
      return {
        'balance': '₹${(1000 + Random().nextInt(5000)).toString()}',
        'transactions': List.generate(5, (index) {
          final isCredit = Random().nextBool();
          return {
            'id': 'transaction_$index',
            'title': isCredit ? 'Payment Received' : 'Service Payment',
            'date':
                '${1 + Random().nextInt(30)}/${1 + Random().nextInt(12)}/2023',
            'amount': '₹${(100 + Random().nextInt(2000)).toString()}',
            'isCredit': isCredit,
          };
        }),
      };
    });
  }

  // Simulate real-time provider updates
  static Stream<List<Map<String, dynamic>>> getProvidersStream() {
    return Stream.periodic(const Duration(seconds: 7), (count) {
      return List.generate(4, (index) {
        return {
          'id': 'provider_${count * 4 + index}',
          'name': 'Provider ${count * 4 + index + 1}',
          'serviceType': 'Cleaning Services',
          'rating': 4.0 + Random().nextDouble() * 1.0,
          'reviewCount': 50 + Random().nextInt(200),
          'isVerified': Random().nextBool(),
          'imageUrl':
              'https://picsum.photos/200/200?random=${100 + count * 4 + index}',
        };
      });
    });
  }

  // Simulate location updates
  static Stream<Map<String, double>> getLocationStream() {
    double lat = 40.7128;
    double lng = -74.0060;

    return Stream.periodic(const Duration(seconds: 30), (count) {
      // Simulate small movements
      lat += (Random().nextDouble() - 0.5) * 0.01;
      lng += (Random().nextDouble() - 0.5) * 0.01;

      return {
        'latitude': lat,
        'longitude': lng,
      };
    });
  }

  // Format currency
  static String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  // Format date
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Format time
  static String formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Format rating
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  // Calculate distance between two points (simplified)
  static double calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
