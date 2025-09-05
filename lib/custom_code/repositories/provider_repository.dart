import 'dart:async';
import 'dart:math';
import '../../custom_code/models/index.dart' as models;

class ProviderRepository {
  // In a real app, this would connect to an API
  // For demo, we'll simulate API calls with delays
  
  // Get all providers
  Future<List<models.ProviderModel>> getAllProviders({int page = 1, int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Generate mock providers
    final List<models.ProviderModel> providers = [];
    
    for (int i = 0; i < limit; i++) {
      final providerId = 'provider_${(page - 1) * limit + i}';
      
      providers.add(models.ProviderModel(
        id: providerId,
        businessName: 'Provider Business ${(page - 1) * limit + i + 1}',
        ownerName: 'Owner ${(page - 1) * limit + i + 1}',
        description: 'Professional service provider with ${5 + Random().nextInt(10)} years of experience. Specializing in high-quality service delivery with customer satisfaction as our top priority.',
        category: 'category_${(i % 5) + 1}',
        email: 'contact${(page - 1) * limit + i + 1}@provider.com',
        phone: '+1${Random().nextInt(9000000000) + 1000000000}',
        images: [
          'https://picsum.photos/400/300?random=provider_${(page - 1) * limit + i}',
          'https://picsum.photos/400/300?random=provider_${(page - 1) * limit + i + 100}',
        ],
        businessAddress: models.UserAddress(
          id: 'address_$providerId',
          title: 'Business Address',
          addressLine1: '${100 + Random().nextInt(900)} Business Street',
          addressLine2: 'Suite ${100 + Random().nextInt(900)}',
          city: 'New York',
          state: 'NY',
          zipCode: '${10000 + Random().nextInt(9000)}',
          country: 'USA',
          latitude: 40.7128 + Random().nextDouble() * 0.1 - 0.05,
          longitude: -74.0060 + Random().nextDouble() * 0.1 - 0.05,
          isDefault: true,
        ),
        services: [
          models.ProviderService(
            id: 'service_${providerId}_1',
            name: 'Basic Service',
            description: 'Essential service package with standard features',
            price: (500 + Random().nextInt(1000)).toDouble(),
            images: [
              'https://picsum.photos/300/200?random=service_${providerId}_1',
            ],
            addons: [
              models.ProviderAddon(
                id: 'addon_${providerId}_1',
                name: 'Premium Materials',
                description: 'High-quality materials for better results',
                price: (150 + Random().nextInt(200)).toDouble(),
              ),
            ],
            isActive: true,
            createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(365))),
            updatedAt: DateTime.now(),
          ),
          models.ProviderService(
            id: 'service_${providerId}_2',
            name: 'Premium Service',
            description: 'Advanced service package with premium features',
            price: (1200 + Random().nextInt(1500)).toDouble(),
            images: [
              'https://picsum.photos/300/200?random=service_${providerId}_2',
            ],
            addons: [
              models.ProviderAddon(
                id: 'addon_${providerId}_2',
                name: 'Extended Warranty',
                description: 'Additional warranty coverage',
                price: (250 + Random().nextInt(300)).toDouble(),
              ),
            ],
            isActive: true,
            createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(300))),
            updatedAt: DateTime.now(),
          ),
        ],
        reviews: List.generate(3 + Random().nextInt(8), (index) {
          return models.ProviderReview(
            id: 'review_${providerId}_$index',
            userId: 'user_$index',
            userName: 'Customer $index',
            userAvatar: 'https://picsum.photos/100/100?random=user_$index',
            rating: (3 + Random().nextInt(3)).toDouble(),
            review: 'Excellent service! Professional and thorough. Would highly recommend.',
            images: [
              'https://picsum.photos/200/200?random=review_${providerId}_$index',
            ],
            createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(90))),
          );
        }),
        averageRating: 4.0 + Random().nextDouble(),
        isVerified: Random().nextBool(),
        isActive: true,
        totalBookings: 50 + Random().nextInt(200),
        completedBookings: 45 + Random().nextInt(180),
        businessHours: models.ProviderBusinessHours(
          hours: {
            'monday': models.BusinessHours(
              openTime: '08:00',
              closeTime: '18:00',
              isClosed: false,
            ),
            'tuesday': models.BusinessHours(
              openTime: '08:00',
              closeTime: '18:00',
              isClosed: false,
            ),
            'wednesday': models.BusinessHours(
              openTime: '08:00',
              closeTime: '18:00',
              isClosed: false,
            ),
            'thursday': models.BusinessHours(
              openTime: '08:00',
              closeTime: '18:00',
              isClosed: false,
            ),
            'friday': models.BusinessHours(
              openTime: '08:00',
              closeTime: '18:00',
              isClosed: false,
            ),
            'saturday': models.BusinessHours(
              openTime: '09:00',
              closeTime: '16:00',
              isClosed: false,
            ),
            'sunday': models.BusinessHours(
              openTime: '00:00',
              closeTime: '00:00',
              isClosed: true,
            ),
          },
          isOpen24Hours: false,
          isClosedOnHolidays: true,
        ),
        certifications: [
          'Certified Professional',
          'Safety Certified',
          'Quality Assured',
        ],
        responseTime: (30 + Random().nextInt(120)).toDouble(),
        isOnline: Random().nextBool(),
        createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(730))),
        updatedAt: DateTime.now(),
      ));
    }
    
    return providers;
  }
  
  // Get provider by ID
  Future<models.ProviderModel?> getProviderById(String providerId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate mock provider
    return models.ProviderModel(
      id: providerId,
      businessName: 'Detailed Provider $providerId',
      ownerName: 'Owner Name',
      description: 'Comprehensive service provider with extensive experience and expertise in delivering high-quality professional services. We pride ourselves on customer satisfaction and attention to detail.',
      category: 'category_1',
      email: 'info@provider$providerId.com',
      phone: '+1${Random().nextInt(9000000000) + 1000000000}',
      images: [
        'https://picsum.photos/500/300?random=detail_provider_$providerId',
        'https://picsum.photos/500/300?random=detail_provider_${providerId}a',
        'https://picsum.photos/500/300?random=detail_provider_${providerId}b',
      ],
      businessAddress: models.UserAddress(
        id: 'address_detail_$providerId',
        title: 'Headquarters',
        addressLine1: '789 Professional Avenue',
        addressLine2: 'Building C',
        city: 'New York',
        state: 'NY',
        zipCode: '10003',
        country: 'USA',
        latitude: 40.7589 + Random().nextDouble() * 0.1 - 0.05,
        longitude: -73.9851 + Random().nextDouble() * 0.1 - 0.05,
        isDefault: true,
      ),
      services: List.generate(5, (index) {
        return models.ProviderService(
          id: 'service_detail_${providerId}_$index',
          name: 'Service Package ${index + 1}',
          description: 'Comprehensive service package with all premium features',
          price: (800 + index * 200 + Random().nextInt(500)).toDouble(),
          images: [
            'https://picsum.photos/400/250?random=service_detail_${providerId}_$index',
          ],
          addons: List.generate(2 + Random().nextInt(3), (addonIndex) {
            return models.ProviderAddon(
              id: 'addon_detail_${providerId}_${index}_$addonIndex',
              name: 'Addon ${addonIndex + 1}',
              description: 'Specialized addon service',
              price: (100 + addonIndex * 50 + Random().nextInt(200)).toDouble(),
            );
          }),
          isActive: true,
          createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(365))),
          updatedAt: DateTime.now(),
        );
      }),
      reviews: List.generate(8 + Random().nextInt(15), (index) {
        return models.ProviderReview(
          id: 'review_detail_${providerId}_$index',
          userId: 'user_detail_$index',
          userName: 'Satisfied Customer ${index + 1}',
          userAvatar: 'https://picsum.photos/100/100?random=user_detail_$index',
          rating: (3 + Random().nextInt(3)).toDouble(),
          review: 'Outstanding service! Professional, punctual, and thorough. Exceeded all expectations. Will definitely hire again.',
          images: [
            'https://picsum.photos/200/200?random=review_detail_${providerId}_$index',
          ],
          createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(180))),
        );
      }),
      averageRating: 4.5 + Random().nextDouble() * 0.5,
      isVerified: true,
      isActive: true,
      totalBookings: 150 + Random().nextInt(300),
      completedBookings: 140 + Random().nextInt(280),
      businessHours: models.ProviderBusinessHours(
        hours: {
          'monday': models.BusinessHours(
            openTime: '07:00',
            closeTime: '19:00',
            isClosed: false,
          ),
          'tuesday': models.BusinessHours(
            openTime: '07:00',
            closeTime: '19:00',
            isClosed: false,
          ),
          'wednesday': models.BusinessHours(
            openTime: '07:00',
            closeTime: '19:00',
            isClosed: false,
          ),
          'thursday': models.BusinessHours(
            openTime: '07:00',
            closeTime: '19:00',
            isClosed: false,
          ),
          'friday': models.BusinessHours(
            openTime: '07:00',
            closeTime: '19:00',
            isClosed: false,
          ),
          'saturday': models.BusinessHours(
            openTime: '08:00',
            closeTime: '17:00',
            isClosed: false,
          ),
          'sunday': models.BusinessHours(
            openTime: '09:00',
            closeTime: '16:00',
            isClosed: false,
          ),
        },
        isOpen24Hours: false,
        isClosedOnHolidays: true,
      ),
      certifications: [
        'Master Certified Professional',
        'ISO 9001 Quality Certified',
        'Safety First Award Winner',
        'Customer Satisfaction Excellence',
      ],
      responseTime: (15 + Random().nextInt(60)).toDouble(),
      isOnline: Random().nextBool(),
      createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(1000))),
      updatedAt: DateTime.now(),
    );
  }
  
  // Search providers
  Future<List<models.ProviderModel>> searchProviders(String query, {int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate mock search results
    final List<models.ProviderModel> providers = [];
    
    for (int i = 0; i < limit; i++) {
      providers.add(models.ProviderModel(
        id: 'search_result_$i',
        businessName: '$query Provider $i',
        ownerName: 'Search Owner $i',
        description: 'Search result provider specializing in $query services with professional expertise.',
        category: 'category_${(i % 4) + 1}',
        email: 'search$i@example.com',
        phone: '+1${Random().nextInt(9000000000) + 1000000000}',
        images: [
          'https://picsum.photos/400/300?random=search_$i',
        ],
        businessAddress: models.UserAddress(
          id: 'address_search_$i',
          title: 'Search Location',
          addressLine1: '${100 + i * 10} Search Street',
          city: 'Search City',
          state: 'SC',
          zipCode: '${10000 + i * 100}',
          country: 'USA',
          latitude: 40.0 + Random().nextDouble(),
          longitude: -75.0 + Random().nextDouble(),
          isDefault: true,
        ),
        services: [
          models.ProviderService(
            id: 'service_search_$i',
            name: 'Search Service',
            description: 'Service specifically for $query',
            price: (600 + Random().nextInt(1200)).toDouble(),
            images: [
              'https://picsum.photos/300/200?random=search_service_$i',
            ],
            addons: [
              models.ProviderAddon(
                id: 'addon_search_$i',
                name: 'Search Addon',
                description: 'Specialized addon for search',
                price: (150 + Random().nextInt(300)).toDouble(),
              ),
            ],
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        reviews: [],
        averageRating: 4.0 + Random().nextDouble(),
        isVerified: Random().nextBool(),
        isActive: true,
        totalBookings: 20 + Random().nextInt(100),
        completedBookings: 18 + Random().nextInt(90),
        businessHours: models.ProviderBusinessHours(
          hours: {},
          isOpen24Hours: false,
          isClosedOnHolidays: true,
        ),
        certifications: ['Search Certified'],
        responseTime: (30 + Random().nextInt(120)).toDouble(),
        isOnline: Random().nextBool(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
    
    return providers;
  }
  
  // Get providers by category
  Future<List<models.ProviderModel>> getProvidersByCategory(String categoryId, {int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate mock category providers
    final List<models.ProviderModel> providers = [];
    
    for (int i = 0; i < limit; i++) {
      providers.add(models.ProviderModel(
        id: 'category_${categoryId}_provider_$i',
        businessName: 'Category $categoryId Provider $i',
        ownerName: 'Category Owner $i',
        description: 'Specialized provider in category $categoryId with expertise and professional service delivery.',
        category: categoryId,
        email: 'category${categoryId}provider$i@example.com',
        phone: '+1${Random().nextInt(9000000000) + 1000000000}',
        images: [
          'https://picsum.photos/400/300?random=category_${categoryId}_$i',
        ],
        businessAddress: models.UserAddress(
          id: 'address_category_${categoryId}_$i',
          title: 'Category Location',
          addressLine1: '${200 + i * 15} Category Street',
          city: 'Category City',
          state: 'CC',
          zipCode: '${20000 + i * 150}',
          country: 'USA',
          latitude: 41.0 + Random().nextDouble(),
          longitude: -76.0 + Random().nextDouble(),
          isDefault: true,
        ),
        services: [
          models.ProviderService(
            id: 'service_category_${categoryId}_$i',
            name: 'Category Service',
            description: 'Service specialized for category $categoryId',
            price: (700 + Random().nextInt(1500)).toDouble(),
            images: [
              'https://picsum.photos/300/200?random=category_service_${categoryId}_$i',
            ],
            addons: [
              models.ProviderAddon(
                id: 'addon_category_${categoryId}_$i',
                name: 'Category Addon',
                description: 'Specialized addon for category $categoryId',
                price: (200 + Random().nextInt(400)).toDouble(),
              ),
            ],
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        reviews: List.generate(2 + Random().nextInt(5), (index) {
          return models.ProviderReview(
            id: 'review_category_${categoryId}_${i}_$index',
            userId: 'user_category_$index',
            userName: 'Category Customer $index',
            userAvatar: 'https://picsum.photos/100/100?random=user_category_$index',
            rating: (3 + Random().nextInt(3)).toDouble(),
            review: 'Great service in category $categoryId!',
            images: [],
            createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(60))),
          );
        }),
        averageRating: 4.2 + Random().nextDouble() * 0.8,
        isVerified: Random().nextBool(),
        isActive: true,
        totalBookings: 30 + Random().nextInt(150),
        completedBookings: 28 + Random().nextInt(140),
        businessHours: models.ProviderBusinessHours(
          hours: {
            'monday': models.BusinessHours(
              openTime: '08:00',
              closeTime: '18:00',
              isClosed: false,
            ),
            'tuesday': models.BusinessHours(
              openTime: '08:00',
              closeTime: '18:00',
              isClosed: false,
            ),
          },
          isOpen24Hours: false,
          isClosedOnHolidays: true,
        ),
        certifications: ['Category Certified'],
        responseTime: (25 + Random().nextInt(100)).toDouble(),
        isOnline: Random().nextBool(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
    
    return providers;
  }
  
  // Get top rated providers
  Future<List<models.ProviderModel>> getTopRatedProviders({int limit = 10}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Generate mock top rated providers
    final List<models.ProviderModel> providers = [];
    
    for (int i = 0; i < limit; i++) {
      providers.add(models.ProviderModel(
        id: 'top_rated_$i',
        businessName: 'Top Rated Provider $i',
        ownerName: 'Top Rated Owner $i',
        description: 'Award-winning provider recognized for exceptional service quality and customer satisfaction.',
        category: 'category_${(i % 3) + 1}',
        email: 'toprated$i@example.com',
        phone: '+1${Random().nextInt(9000000000) + 1000000000}',
        images: [
          'https://picsum.photos/500/300?random=top_rated_$i',
        ],
        businessAddress: models.UserAddress(
          id: 'address_top_rated_$i',
          title: 'Premier Location',
          addressLine1: '${300 + i * 20} Premier Street',
          city: 'Top City',
          state: 'TC',
          zipCode: '${30000 + i * 200}',
          country: 'USA',
          latitude: 42.0 + Random().nextDouble(),
          longitude: -77.0 + Random().nextDouble(),
          isDefault: true,
        ),
        services: [
          models.ProviderService(
            id: 'service_top_rated_$i',
            name: 'Premium Service',
            description: 'Top-rated premium service with exclusive features',
            price: (1500 + Random().nextInt(2000)).toDouble(),
            images: [
              'https://picsum.photos/400/250?random=top_service_$i',
            ],
            addons: [
              models.ProviderAddon(
                id: 'addon_top_rated_$i',
                name: 'VIP Addon',
                description: 'Exclusive VIP service addon',
                price: (400 + Random().nextInt(600)).toDouble(),
              ),
            ],
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        reviews: List.generate(10 + Random().nextInt(20), (index) {
          return models.ProviderReview(
            id: 'review_top_rated_${i}_$index',
            userId: 'user_top_rated_$index',
            userName: 'VIP Customer $index',
            userAvatar: 'https://picsum.photos/100/100?random=user_top_rated_$index',
            rating: 4.7 + Random().nextDouble() * 0.3,
            review: 'Absolutely outstanding! Best service I\'ve ever experienced. Highly recommended!',
            images: [
              'https://picsum.photos/200/200?random=review_top_rated_${i}_$index',
            ],
            createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(30))),
          );
        }),
        averageRating: 4.8 + Random().nextDouble() * 0.2,
        isVerified: true,
        isActive: true,
        totalBookings: 200 + Random().nextInt(500),
        completedBookings: 190 + Random().nextInt(480),
        businessHours: models.ProviderBusinessHours(
          hours: {
            'monday': models.BusinessHours(
              openTime: '07:00',
              closeTime: '20:00',
              isClosed: false,
            ),
            'tuesday': models.BusinessHours(
              openTime: '07:00',
              closeTime: '20:00',
              isClosed: false,
            ),
            'wednesday': models.BusinessHours(
              openTime: '07:00',
              closeTime: '20:00',
              isClosed: false,
            ),
            'thursday': models.BusinessHours(
              openTime: '07:00',
              closeTime: '20:00',
              isClosed: false,
            ),
            'friday': models.BusinessHours(
              openTime: '07:00',
              closeTime: '20:00',
              isClosed: false,
            ),
            'saturday': models.BusinessHours(
              openTime: '08:00',
              closeTime: '19:00',
              isClosed: false,
            ),
            'sunday': models.BusinessHours(
              openTime: '09:00',
              closeTime: '18:00',
              isClosed: false,
            ),
          },
          isOpen24Hours: false,
          isClosedOnHolidays: true,
        ),
        certifications: [
          'Top Rated Certificate',
          'Customer Choice Award',
          'Quality Excellence',
          'Service Master',
        ],
        responseTime: (10 + Random().nextInt(30)).toDouble(),
        isOnline: true,
        createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(500))),
        updatedAt: DateTime.now(),
      ));
    }
    
    // Sort by rating descending
    providers.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    
    return providers;
  }
  
  // Get nearby providers
  Future<List<models.ProviderModel>> getNearbyProviders(double latitude, double longitude, {int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));
    
    // Generate mock nearby providers
    final List<models.ProviderModel> providers = [];
    
    for (int i = 0; i < limit; i++) {
      // Generate nearby coordinates
      final nearbyLat = latitude + (Random().nextDouble() - 0.5) * 0.1;
      final nearbyLng = longitude + (Random().nextDouble() - 0.5) * 0.1;
      
      providers.add(models.ProviderModel(
        id: 'nearby_$i',
        businessName: 'Nearby Provider $i',
        ownerName: 'Nearby Owner $i',
        description: 'Conveniently located provider near your area with quick response times and professional service.',
        category: 'category_${(i % 4) + 1}',
        email: 'nearby$i@example.com',
        phone: '+1${Random().nextInt(9000000000) + 1000000000}',
        images: [
          'https://picsum.photos/400/300?random=nearby_$i',
        ],
        businessAddress: models.UserAddress(
          id: 'address_nearby_$i',
          title: 'Nearby Location',
          addressLine1: '${400 + i * 25} Nearby Street',
          city: 'Nearby City',
          state: 'NC',
          zipCode: '${40000 + i * 250}',
          country: 'USA',
          latitude: nearbyLat,
          longitude: nearbyLng,
          isDefault: true,
        ),
        services: [
          models.ProviderService(
            id: 'service_nearby_$i',
            name: 'Local Service',
            description: 'Convenient local service with quick turnaround',
            price: (600 + Random().nextInt(1200)).toDouble(),
            images: [
              'https://picsum.photos/300/200?random=nearby_service_$i',
            ],
            addons: [
              models.ProviderAddon(
                id: 'addon_nearby_$i',
                name: 'Express Addon',
                description: 'Quick express service option',
                price: (200 + Random().nextInt(300)).toDouble(),
              ),
            ],
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        reviews: List.generate(3 + Random().nextInt(7), (index) {
          return models.ProviderReview(
            id: 'review_nearby_${i}_$index',
            userId: 'user_nearby_$index',
            userName: 'Local Customer $index',
            userAvatar: 'https://picsum.photos/100/100?random=user_nearby_$index',
            rating: 4.0 + Random().nextDouble(),
            review: 'Convenient location and great service!',
            images: [],
            createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(45))),
          );
        }),
        averageRating: 4.3 + Random().nextDouble() * 0.7,
        isVerified: Random().nextBool(),
        isActive: true,
        totalBookings: 80 + Random().nextInt(200),
        completedBookings: 75 + Random().nextInt(190),
        businessHours: models.ProviderBusinessHours(
          hours: {
            'monday': models.BusinessHours(
              openTime: '08:00',
              closeTime: '18:00',
              isClosed: false,
            ),
          },
          isOpen24Hours: false,
          isClosedOnHolidays: true,
        ),
        certifications: ['Local Certified'],
        responseTime: (20 + Random().nextInt(80)).toDouble(),
        isOnline: Random().nextBool(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
    
    return providers;
  }
}