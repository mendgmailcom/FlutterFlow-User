import 'dart:async';
import 'dart:math';
import '../../custom_code/models/index.dart' as models;

class UserRepository {
  // In a real app, this would connect to an API
  // For demo, we'll simulate API calls with delays
  
  // Get current user profile
  Future<models.UserModel> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate mock user profile
    return models.UserModel(
      id: 'user_${Random().nextInt(10000)}',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1${Random().nextInt(9000000000) + 1000000000}',
      avatar: 'https://picsum.photos/200/200?random=user',
      coverImage: 'https://picsum.photos/800/300?random=cover',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now(),
      addresses: [
        models.UserAddress(
          id: 'address_1',
          title: 'Home',
          addressLine1: '123 Main Street',
          addressLine2: 'Apartment 4B',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
          latitude: 40.7128 + Random().nextDouble() * 0.1 - 0.05,
          longitude: -74.0060 + Random().nextDouble() * 0.1 - 0.05,
          isDefault: true,
        ),
        models.UserAddress(
          id: 'address_2',
          title: 'Office',
          addressLine1: '456 Business Park',
          addressLine2: 'Suite 1200',
          city: 'New York',
          state: 'NY',
          zipCode: '10002',
          country: 'USA',
          latitude: 40.7589 + Random().nextDouble() * 0.1 - 0.05,
          longitude: -73.9851 + Random().nextDouble() * 0.1 - 0.05,
          isDefault: false,
        ),
      ],
      paymentMethods: [
        models.PaymentMethod(
          id: 'card_1',
          type: 'credit_card',
          name: 'Visa ending in 1234',
          last4: '1234',
          expiry: '${1 + Random().nextInt(12)}/25',
          isDefault: true,
        ),
        models.PaymentMethod(
          id: 'card_2',
          type: 'debit_card',
          name: 'Mastercard ending in 5678',
          last4: '5678',
          expiry: '${1 + Random().nextInt(12)}/24',
          isDefault: false,
        ),
        models.PaymentMethod(
          id: 'wallet_1',
          type: 'wallet',
          name: 'Google Pay',
          email: 'john.doe@gmail.com',
          isDefault: false,
        ),
      ],
      stats: models.UserProfileStats(
        totalBookings: 42,
        completedBookings: 38,
        cancelledBookings: 4,
        averageRating: 4.8,
        totalReviews: 35,
        totalSpent: 12500.0,
      ),
      preferences: models.UserPreferences(
        notificationsEnabled: true,
        emailNotifications: true,
        smsNotifications: true,
        pushNotifications: true,
        language: 'en',
        currency: 'USD',
        darkMode: false,
        favoriteCategories: ['category_1', 'category_3', 'category_5'],
      ),
      membership: models.UserMembership(
        tier: 'gold',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        points: 1250,
        benefits: [
          '10% discount on all services',
          'Priority booking',
          'Free cancellations',
          '24/7 customer support'
        ],
      ),
    );
  }
  
  // Update user profile
  Future<models.UserModel> updateUserProfile(Map<String, dynamic> userData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Get current user (in real app, this would fetch from API)
    final currentUser = await getCurrentUser();
    
    // Return updated user
    return models.UserModel(
      id: currentUser.id,
      name: userData['name'] as String? ?? currentUser.name,
      email: userData['email'] as String? ?? currentUser.email,
      phone: userData['phone'] as String? ?? currentUser.phone,
      avatar: userData['avatar'] as String? ?? currentUser.avatar,
      coverImage: userData['coverImage'] as String? ?? currentUser.coverImage,
      createdAt: currentUser.createdAt,
      updatedAt: DateTime.now(),
      addresses: List<models.UserAddress>.from(userData['addresses'] as List<dynamic>? ?? currentUser.addresses),
      paymentMethods: List<models.PaymentMethod>.from(userData['paymentMethods'] as List<dynamic>? ?? currentUser.paymentMethods),
      stats: userData['stats'] as models.UserProfileStats? ?? currentUser.stats,
      preferences: userData['preferences'] as models.UserPreferences? ?? currentUser.preferences,
      membership: userData['membership'] as models.UserMembership? ?? currentUser.membership,
    );
  }
  
  // Add user address
  Future<models.UserAddress> addUserAddress(Map<String, dynamic> addressData) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate mock address
    return models.UserAddress(
      id: 'address_${Random().nextInt(1000)}',
      title: addressData['title'] as String? ?? 'New Address',
      addressLine1: addressData['addressLine1'] as String? ?? '',
      addressLine2: addressData['addressLine2'] as String?,
      city: addressData['city'] as String? ?? '',
      state: addressData['state'] as String? ?? '',
      zipCode: addressData['zipCode'] as String? ?? '',
      country: addressData['country'] as String? ?? 'USA',
      latitude: (addressData['latitude'] as num?)?.toDouble(),
      longitude: (addressData['longitude'] as num?)?.toDouble(),
      isDefault: addressData['isDefault'] as bool? ?? false,
    );
  }
  
  // Update user address
  Future<models.UserAddress> updateUserAddress(String addressId, Map<String, dynamic> addressData) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate mock updated address
    return models.UserAddress(
      id: addressId,
      title: addressData['title'] as String? ?? 'Updated Address',
      addressLine1: addressData['addressLine1'] as String? ?? '',
      addressLine2: addressData['addressLine2'] as String?,
      city: addressData['city'] as String? ?? '',
      state: addressData['state'] as String? ?? '',
      zipCode: addressData['zipCode'] as String? ?? '',
      country: addressData['country'] as String? ?? 'USA',
      latitude: (addressData['latitude'] as num?)?.toDouble(),
      longitude: (addressData['longitude'] as num?)?.toDouble(),
      isDefault: addressData['isDefault'] as bool? ?? false,
    );
  }
  
  // Delete user address
  Future<bool> deleteUserAddress(String addressId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would make an API call
    // For demo, we'll just return success
    return true;
  }
  
  // Set default address
  Future<bool> setDefaultAddress(String addressId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would make an API call
    // For demo, we'll just return success
    return true;
  }
  
  // Add payment method
  Future<models.PaymentMethod> addPaymentMethod(Map<String, dynamic> paymentData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate mock payment method
    return models.PaymentMethod(
      id: 'pm_${Random().nextInt(10000)}',
      type: paymentData['type'] as String? ?? 'credit_card',
      name: paymentData['name'] as String? ?? 'New Payment Method',
      last4: paymentData['last4'] as String?,
      expiry: paymentData['expiry'] as String?,
      email: paymentData['email'] as String?,
      upiId: paymentData['upiId'] as String?,
      isDefault: paymentData['isDefault'] as bool? ?? false,
    );
  }
  
  // Update payment method
  Future<models.PaymentMethod> updatePaymentMethod(String paymentMethodId, Map<String, dynamic> paymentData) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate mock updated payment method
    return models.PaymentMethod(
      id: paymentMethodId,
      type: paymentData['type'] as String? ?? 'credit_card',
      name: paymentData['name'] as String? ?? 'Updated Payment Method',
      last4: paymentData['last4'] as String?,
      expiry: paymentData['expiry'] as String?,
      email: paymentData['email'] as String?,
      upiId: paymentData['upiId'] as String?,
      isDefault: paymentData['isDefault'] as bool? ?? false,
    );
  }
  
  // Delete payment method
  Future<bool> deletePaymentMethod(String paymentMethodId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would make an API call
    // For demo, we'll just return success
    return true;
  }
  
  // Set default payment method
  Future<bool> setDefaultPaymentMethod(String paymentMethodId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would make an API call
    // For demo, we'll just return success
    return true;
  }
  
  // Update user preferences
  Future<models.UserPreferences> updateUserPreferences(Map<String, dynamic> preferencesData) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Get current user (in real app, this would fetch from API)
    final currentUser = await getCurrentUser();
    
    // Return updated preferences
    return models.UserPreferences(
      notificationsEnabled: preferencesData['notificationsEnabled'] as bool? ?? currentUser.preferences.notificationsEnabled,
      emailNotifications: preferencesData['emailNotifications'] as bool? ?? currentUser.preferences.emailNotifications,
      smsNotifications: preferencesData['smsNotifications'] as bool? ?? currentUser.preferences.smsNotifications,
      pushNotifications: preferencesData['pushNotifications'] as bool? ?? currentUser.preferences.pushNotifications,
      language: preferencesData['language'] as String? ?? currentUser.preferences.language,
      currency: preferencesData['currency'] as String? ?? currentUser.preferences.currency,
      darkMode: preferencesData['darkMode'] as bool? ?? currentUser.preferences.darkMode,
      favoriteCategories: List<String>.from(preferencesData['favoriteCategories'] as List<dynamic>? ?? currentUser.preferences.favoriteCategories),
    );
  }
  
  // Get user stats
  Future<models.UserProfileStats> getUserStats() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Generate mock user stats
    return models.UserProfileStats(
      totalBookings: 25 + Random().nextInt(50),
      completedBookings: 20 + Random().nextInt(45),
      cancelledBookings: Random().nextInt(10),
      averageRating: 4.0 + Random().nextDouble(),
      totalReviews: 15 + Random().nextInt(40),
      totalSpent: (5000 + Random().nextInt(15000)).toDouble(),
    );
  }
  
  // Get user membership
  Future<models.UserMembership> getUserMembership() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Generate mock membership
    final tiers = ['free', 'silver', 'gold', 'platinum'];
    final tier = tiers[Random().nextInt(tiers.length)];
    
    return models.UserMembership(
      tier: tier,
      expiresAt: DateTime.now().add(Duration(days: 30 + Random().nextInt(335))),
      points: 100 + Random().nextInt(2000),
      benefits: [
        'Discount on services',
        'Priority booking',
        'Free cancellations',
        '${Random().nextInt(24) + 1}/7 customer support'
      ],
    );
  }
  
  // Upgrade user membership
  Future<models.UserMembership> upgradeMembership(String newTier) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Generate mock upgraded membership
    return models.UserMembership(
      tier: newTier,
      expiresAt: DateTime.now().add(const Duration(days: 365)),
      points: 2000 + Random().nextInt(3000),
      benefits: [
        '20% discount on all services',
        'Priority booking',
        'Free cancellations',
        '24/7 customer support',
        'Exclusive offers',
        'Early access to new features'
      ],
    );
  }
  
  // Get user reviews
  Future<List<Map<String, dynamic>>> getUserReviews({int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate mock reviews
    final List<Map<String, dynamic>> reviews = [];
    
    for (int i = 0; i < limit; i++) {
      reviews.add({
        'id': 'review_$i',
        'bookingId': 'booking_$i',
        'serviceId': 'service_$i',
        'serviceName': 'Service $i',
        'rating': (3 + Random().nextInt(3)).toDouble(),
        'review': 'Great service! The provider was professional and thorough. I would definitely book again.',
        'createdAt': DateTime.now().subtract(Duration(days: Random().nextInt(60))).toIso8601String(),
      });
    }
    
    return reviews;
  }
}