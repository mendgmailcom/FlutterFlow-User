import 'dart:async';
import 'dart:math';
import '../../custom_code/models/index.dart' as models;

class BookingRepository {
  // In a real app, this would connect to an API
  // For demo, we'll simulate API calls with delays

  // Create a new booking
  Future<models.BookingModel> createBooking(
      Map<String, dynamic> bookingData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate a mock booking
    final bookingId = 'booking_${Random().nextInt(100000)}';
    final now = DateTime.now();

    return models.BookingModel(
      id: bookingId,
      serviceId: bookingData['serviceId'] as String? ?? 'service_1',
      serviceName:
          bookingData['serviceName'] as String? ?? 'Professional Service',
      providerId: bookingData['providerId'] as String? ?? 'provider_1',
      providerName:
          bookingData['providerName'] as String? ?? 'Service Provider',
      scheduledDate: DateTime.parse(bookingData['scheduledDate'] as String? ??
          now.add(Duration(days: Random().nextInt(7))).toIso8601String()),
      scheduledTime: bookingData['scheduledTime'] as String? ??
          '${(9 + Random().nextInt(8)).toString().padLeft(2, '0')}:${Random().nextBool() ? '00' : '30'}',
      serviceAddress: bookingData['serviceAddress'] as String? ??
          '123 Main Street, New York, NY 10001',
      status: 'confirmed',
      totalAmount:
          (bookingData['totalAmount'] as num? ?? (500 + Random().nextInt(2000)))
              .toDouble(),
      paymentMethod: bookingData['paymentMethod'] as String? ??
          ['Credit Card', 'Debit Card', 'Wallet', 'Cash'][Random().nextInt(4)],
      paymentStatus: 'paid',
      addons: List<models.AddonModel>.from(
          (bookingData['addons'] as List<dynamic>? ?? []).map((addon) =>
              models.AddonModel.fromJson(addon as Map<String, dynamic>))),
      specialInstructions: bookingData['specialInstructions'] as String?,
      notes: bookingData['notes'] as String?,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Get booking by ID
  Future<models.BookingModel?> getBookingById(String bookingId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate a mock booking
    final now = DateTime.now();
    final scheduledDate = now.add(Duration(days: Random().nextInt(14)));

    return models.BookingModel(
      id: bookingId,
      serviceId: 'service_${Random().nextInt(100)}',
      serviceName: 'Professional Cleaning Service',
      providerId: 'provider_${Random().nextInt(50)}',
      providerName: 'Clean & Shine Services',
      scheduledDate: scheduledDate,
      scheduledTime:
          '${(9 + Random().nextInt(8)).toString().padLeft(2, '0')}:${Random().nextBool() ? '00' : '30'}',
      serviceAddress: '456 Oak Avenue, New York, NY 10002',
      status: [
        'confirmed',
        'completed',
        'pending',
        'cancelled',
        'in_progress'
      ][Random().nextInt(5)],
      totalAmount: (800 + Random().nextInt(2500)).toDouble(),
      paymentMethod: [
        'Credit Card',
        'Debit Card',
        'Wallet',
        'Cash'
      ][Random().nextInt(4)],
      paymentStatus: ['paid', 'pending', 'refunded'][Random().nextInt(3)],
      addons: [
        models.AddonModel(
          id: 'addon_1',
          name: 'Deep Cleaning',
          description: 'Thorough cleaning including hard-to-reach areas',
          price: 299.0,
        ),
        models.AddonModel(
          id: 'addon_2',
          name: 'Window Cleaning',
          description: 'Spotless window and glass surface cleaning',
          price: 199.0,
        ),
      ],
      specialInstructions:
          'Please bring your own cleaning supplies if possible.',
      notes: 'Customer prefers morning appointments.',
      createdAt: now.subtract(Duration(days: Random().nextInt(7))),
      updatedAt: now,
    );
  }

  // Get user bookings
  Future<List<models.BookingModel>> getUserBookings(
      {String? status, int page = 1, int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Generate mock bookings
    final List<models.BookingModel> bookings = [];
    final int count = min(limit, 15);

    for (int i = 0; i < count; i++) {
      final bookingStatus = status ??
          [
            'confirmed',
            'completed',
            'pending',
            'cancelled',
            'in_progress'
          ][Random().nextInt(5)];
      final now = DateTime.now();
      final scheduledDate = now.add(Duration(days: i));

      bookings.add(models.BookingModel(
        id: 'booking_${(page - 1) * limit + i}',
        serviceId: 'service_$i',
        serviceName: 'Service ${(page - 1) * limit + i + 1}',
        providerId: 'provider_$i',
        providerName: 'Provider ${(page - 1) * limit + i + 1}',
        scheduledDate: scheduledDate,
        scheduledTime:
            '${(9 + i % 9).toString().padLeft(2, '0')}:${i % 2 == 0 ? '00' : '30'}',
        serviceAddress: '$i Main Street, New York, NY 1000${i % 10}',
        status: bookingStatus,
        totalAmount: (500 + i * 100).toDouble(),
        paymentMethod: ['Credit Card', 'Debit Card', 'Wallet', 'Cash'][i % 4],
        paymentStatus: ['paid', 'pending', 'refunded'][i % 3],
        addons: i % 3 == 0
            ? [
                models.AddonModel(
                  id: 'addon_${i}_1',
                  name: 'Special Addon',
                  description: 'Exclusive service addon',
                  price: (150 + Random().nextInt(300)).toDouble(),
                ),
              ]
            : [],
        specialInstructions:
            i % 4 == 0 ? 'Special instructions for booking $i' : null,
        notes: i % 5 == 0 ? 'Internal notes for booking $i' : null,
        createdAt: now.subtract(Duration(days: i)),
        updatedAt: now.subtract(Duration(hours: i)),
      ));
    }

    // Filter by status if provided
    if (status != null) {
      return bookings.where((booking) => booking.status == status).toList();
    }

    return bookings;
  }

  // Update booking status
  Future<models.BookingModel> updateBookingStatus(
      String bookingId, String newStatus) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Get current booking (in real app, this would fetch from API)
    final currentBooking = await getBookingById(bookingId);

    if (currentBooking == null) {
      throw Exception('Booking not found');
    }

    // Return updated booking
    return models.BookingModel(
      id: currentBooking.id,
      serviceId: currentBooking.serviceId,
      serviceName: currentBooking.serviceName,
      providerId: currentBooking.providerId,
      providerName: currentBooking.providerName,
      scheduledDate: currentBooking.scheduledDate,
      scheduledTime: currentBooking.scheduledTime,
      serviceAddress: currentBooking.serviceAddress,
      status: newStatus,
      totalAmount: currentBooking.totalAmount,
      paymentMethod: currentBooking.paymentMethod,
      paymentStatus: currentBooking.paymentStatus,
      addons: currentBooking.addons,
      specialInstructions: currentBooking.specialInstructions,
      notes: currentBooking.notes,
      createdAt: currentBooking.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Cancel booking
  Future<bool> cancelBooking(String bookingId, String reason) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would make an API call
    // For demo, we'll just return success
    return true;
  }

  // Reschedule booking
  Future<models.BookingModel> rescheduleBooking(
      String bookingId, DateTime newDate, String newTime) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Get current booking (in real app, this would fetch from API)
    final currentBooking = await getBookingById(bookingId);

    if (currentBooking == null) {
      throw Exception('Booking not found');
    }

    // Return rescheduled booking
    return models.BookingModel(
      id: currentBooking.id,
      serviceId: currentBooking.serviceId,
      serviceName: currentBooking.serviceName,
      providerId: currentBooking.providerId,
      providerName: currentBooking.providerName,
      scheduledDate: newDate,
      scheduledTime: newTime,
      serviceAddress: currentBooking.serviceAddress,
      status: 'confirmed', // Reset status to confirmed
      totalAmount: currentBooking.totalAmount,
      paymentMethod: currentBooking.paymentMethod,
      paymentStatus: currentBooking.paymentStatus,
      addons: currentBooking.addons,
      specialInstructions: currentBooking.specialInstructions,
      notes: currentBooking.notes,
      createdAt: currentBooking.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Add review to completed booking
  Future<bool> addReview(String bookingId, int rating, String review) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, this would make an API call
    // For demo, we'll just return success
    return true;
  }

  // Get booking status updates stream
  Stream<models.BookingStatusUpdate> getBookingStatusUpdates(String bookingId) {
    return Stream.periodic(const Duration(seconds: 30), (count) {
      final statuses = ['confirmed', 'in_progress', 'completed', 'cancelled'];
      final status = statuses[min(count, statuses.length - 1)];

      return models.BookingStatusUpdate(
        bookingId: bookingId,
        status: status,
        message: 'Booking status updated to $status',
        timestamp: DateTime.now(),
      );
    });
  }

  // Get upcoming bookings
  Future<List<models.BookingModel>> getUpcomingBookings(
      {int limit = 10}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Generate mock upcoming bookings
    final List<models.BookingModel> bookings = [];
    final now = DateTime.now();

    for (int i = 0; i < min(limit, 8); i++) {
      final scheduledDate = now.add(Duration(days: i + 1));

      bookings.add(models.BookingModel(
        id: 'upcoming_$i',
        serviceId: 'service_upcoming_$i',
        serviceName: 'Upcoming Service $i',
        providerId: 'provider_upcoming_$i',
        providerName: 'Upcoming Provider $i',
        scheduledDate: scheduledDate,
        scheduledTime:
            '${(9 + i % 6).toString().padLeft(2, '0')}:${i % 2 == 0 ? '00' : '30'}',
        serviceAddress: 'Upcoming Address $i, New York, NY',
        status: 'confirmed',
        totalAmount: (700 + Random().nextInt(2000)).toDouble(),
        paymentMethod: 'Credit Card',
        paymentStatus: 'paid',
        addons: [],
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ));
    }

    return bookings;
  }

  // Get past bookings
  Future<List<models.BookingModel>> getPastBookings({int limit = 10}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Generate mock past bookings
    final List<models.BookingModel> bookings = [];
    final now = DateTime.now();

    for (int i = 0; i < min(limit, 8); i++) {
      final scheduledDate = now.subtract(Duration(days: i + 1));

      bookings.add(models.BookingModel(
        id: 'past_$i',
        serviceId: 'service_past_$i',
        serviceName: 'Past Service $i',
        providerId: 'provider_past_$i',
        providerName: 'Past Provider $i',
        scheduledDate: scheduledDate,
        scheduledTime:
            '${(10 + i % 7).toString().padLeft(2, '0')}:${i % 2 == 0 ? '00' : '30'}',
        serviceAddress: 'Past Address $i, New York, NY',
        status: ['completed', 'cancelled'][Random().nextInt(2)],
        totalAmount: (600 + Random().nextInt(1800)).toDouble(),
        paymentMethod: ['Credit Card', 'Wallet'][Random().nextInt(2)],
        paymentStatus: 'paid',
        addons: i % 3 == 0
            ? [
                models.AddonModel(
                  id: 'addon_past_$i',
                  name: 'Past Addon',
                  description: 'Addon from past booking',
                  price: (100 + Random().nextInt(250)).toDouble(),
                ),
              ]
            : [],
        createdAt: scheduledDate.subtract(const Duration(days: 2)),
        updatedAt: scheduledDate.add(const Duration(hours: 2)),
      ));
    }

    return bookings;
  }
}
