import 'dart:async';
import 'dart:math';
import '../../custom_code/models/index.dart' as models;

class ServiceRepository {
  // In a real app, this would connect to an API
  // For demo, we'll simulate API calls with delays
  
  // Get all services
  Future<List<models.ServiceModel>> getAllServices({int page = 1, int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate mock services
    final List<models.ServiceModel> services = [];
    
    for (int i = 0; i < limit; i++) {
      final serviceId = 'service_${(page - 1) * limit + i}';
      final categoryId = 'category_${(i % 5) + 1}';
      
      services.add(models.ServiceModel(
        id: serviceId,
        name: 'Professional Service ${(page - 1) * limit + i + 1}',
        description: 'High-quality professional service with expert staff and premium equipment. Satisfaction guaranteed.',
        category: categoryId,
        price: (500 + Random().nextInt(2000)).toDouble(),
        rating: 4.0 + Random().nextDouble(),
        reviewCount: 50 + Random().nextInt(200),
        images: [
          'https://picsum.photos/400/300?random=${(page - 1) * limit + i}',
          'https://picsum.photos/400/300?random=${(page - 1) * limit + i + 100}',
          'https://picsum.photos/400/300?random=${(page - 1) * limit + i + 200}',
        ],
        addons: [
          models.AddonModel(
            id: 'addon_${serviceId}_1',
            name: 'Premium Addon',
            description: 'Enhanced service with premium materials',
            price: (200 + Random().nextInt(500)).toDouble(),
          ),
          models.AddonModel(
            id: 'addon_${serviceId}_2',
            name: 'Express Service',
            description: 'Fast-track service completion',
            price: (300 + Random().nextInt(400)).toDouble(),
          ),
        ],
        tags: ['premium', 'fast', 'reliable'],
        isActive: true,
        isFeatured: i < 3, // First 3 services are featured
        createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(365))),
        updatedAt: DateTime.now().subtract(Duration(hours: Random().nextInt(24))),
      ));
    }
    
    return services;
  }
  
  // Get service by ID
  Future<models.ServiceModel?> getServiceById(String serviceId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would fetch from API
    // For demo, return a mock service
    return models.ServiceModel(
      id: serviceId,
      name: 'Detailed Service $serviceId',
      description: 'Comprehensive professional service with all premium features and expert staff.',
      category: 'category_1',
      price: (800 + Random().nextInt(1500)).toDouble(),
      rating: 4.5 + Random().nextDouble() * 0.5,
      reviewCount: 100 + Random().nextInt(300),
      images: [
        'https://picsum.photos/600/400?random=$serviceId',
        'https://picsum.photos/600/400?random=${serviceId}a',
        'https://picsum.photos/600/400?random=${serviceId}b',
      ],
      addons: [
        models.AddonModel(
          id: 'addon_${serviceId}_1',
          name: 'Extended Warranty',
          description: 'Additional warranty coverage',
          price: 299.0,
        ),
        models.AddonModel(
          id: 'addon_${serviceId}_2',
          name: 'Priority Support',
          description: '24/7 dedicated support',
          price: 199.0,
        ),
        models.AddonModel(
          id: 'addon_${serviceId}_3',
          name: 'Eco-Friendly Option',
          description: 'Environmentally conscious materials',
          price: 149.0,
        ),
      ],
      tags: ['premium', 'eco-friendly', 'warranty'],
      isActive: true,
      isFeatured: Random().nextBool(),
      createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(365))),
      updatedAt: DateTime.now(),
    );
  }
  
  // Search services
  Future<List<models.ServiceModel>> searchServices(String query, {int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Generate mock search results
    final List<models.ServiceModel> results = [];
    
    for (int i = 0; i < min(limit, 10); i++) {
      results.add(models.ServiceModel(
        id: 'search_result_$i',
        name: '$query Service $i',
        description: 'Search result for $query with professional quality',
        category: 'category_${(i % 3) + 1}',
        price: (600 + Random().nextInt(1800)).toDouble(),
        rating: 4.0 + Random().nextDouble(),
        reviewCount: 30 + Random().nextInt(150),
        images: [
          'https://picsum.photos/400/300?random=search_$i',
        ],
        addons: [
          models.AddonModel(
            id: 'addon_search_$i',
            name: 'Search Addon',
            description: 'Special addon for search results',
            price: (150 + Random().nextInt(300)).toDouble(),
          ),
        ],
        tags: [query.toLowerCase()],
        isActive: true,
        isFeatured: Random().nextBool(),
        createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(100))),
        updatedAt: DateTime.now(),
      ));
    }
    
    return results;
  }
  
  // Get services by category
  Future<List<models.ServiceModel>> getServicesByCategory(String categoryId, {int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Generate mock category services
    final List<models.ServiceModel> services = [];
    
    for (int i = 0; i < min(limit, 15); i++) {
      services.add(models.ServiceModel(
        id: 'category_${categoryId}_service_$i',
        name: 'Category $categoryId Service $i',
        description: 'Specialized service in category $categoryId',
        category: categoryId,
        price: (400 + Random().nextInt(2000)).toDouble(),
        rating: 4.0 + Random().nextDouble(),
        reviewCount: 20 + Random().nextInt(200),
        images: [
          'https://picsum.photos/400/300?random=cat_${categoryId}_$i',
        ],
        addons: [
          models.AddonModel(
            id: 'addon_cat_${categoryId}_$i',
            name: 'Category Addon',
            description: 'Specialized addon for this category',
            price: (100 + Random().nextInt(400)).toDouble(),
          ),
        ],
        tags: ['category-$categoryId'],
        isActive: true,
        isFeatured: i < 2,
        createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(200))),
        updatedAt: DateTime.now(),
      ));
    }
    
    return services;
  }
  
  // Get all categories
  Future<List<models.CategoryModel>> getAllCategories() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Return mock categories
    return [
      models.CategoryModel(
        id: 'category_1',
        name: 'Cleaning',
        icon: 'cleaning_services',
        imageUrl: 'https://picsum.photos/200/200?random=cat1',
        serviceCount: 42,
        isActive: true,
      ),
      models.CategoryModel(
        id: 'category_2',
        name: 'Plumbing',
        icon: 'plumbing',
        imageUrl: 'https://picsum.photos/200/200?random=cat2',
        serviceCount: 28,
        isActive: true,
      ),
      models.CategoryModel(
        id: 'category_3',
        name: 'Electrical',
        icon: 'electrical_services',
        imageUrl: 'https://picsum.photos/200/200?random=cat3',
        serviceCount: 35,
        isActive: true,
      ),
      models.CategoryModel(
        id: 'category_4',
        name: 'Gardening',
        icon: 'grass',
        imageUrl: 'https://picsum.photos/200/200?random=cat4',
        serviceCount: 19,
        isActive: true,
      ),
      models.CategoryModel(
        id: 'category_5',
        name: 'Painting',
        icon: 'format_paint',
        imageUrl: 'https://picsum.photos/200/200?random=cat5',
        serviceCount: 24,
        isActive: true,
      ),
      models.CategoryModel(
        id: 'category_6',
        name: 'Carpentry',
        icon: 'carpenter',
        imageUrl: 'https://picsum.photos/200/200?random=cat6',
        serviceCount: 31,
        isActive: true,
      ),
    ];
  }
  
  // Get featured services
  Future<List<models.ServiceModel>> getFeaturedServices({int limit = 10}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Generate mock featured services
    final List<models.ServiceModel> services = [];
    
    for (int i = 0; i < min(limit, 10); i++) {
      services.add(models.ServiceModel(
        id: 'featured_$i',
        name: 'Featured Service $i',
        description: 'Premium featured service with special offers',
        category: 'category_${(i % 3) + 1}',
        price: (1000 + Random().nextInt(2000)).toDouble(),
        rating: 4.7 + Random().nextDouble() * 0.3,
        reviewCount: 150 + Random().nextInt(300),
        images: [
          'https://picsum.photos/500/300?random=featured_$i',
        ],
        addons: [
          models.AddonModel(
            id: 'addon_featured_$i',
            name: 'Featured Addon',
            description: 'Exclusive addon for featured services',
            price: (300 + Random().nextInt(500)).toDouble(),
          ),
        ],
        tags: ['featured', 'premium'],
        isActive: true,
        isFeatured: true,
        createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(50))),
        updatedAt: DateTime.now(),
      ));
    }
    
    return services;
  }
  
  // Get trending services
  Future<List<models.ServiceModel>> getTrendingServices({int limit = 10}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Generate mock trending services
    final List<models.ServiceModel> services = [];
    
    for (int i = 0; i < min(limit, 10); i++) {
      services.add(models.ServiceModel(
        id: 'trending_$i',
        name: 'Trending Service $i',
        description: 'Most popular service this week',
        category: 'category_${(i % 4) + 1}',
        price: (700 + Random().nextInt(1500)).toDouble(),
        rating: 4.6 + Random().nextDouble() * 0.4,
        reviewCount: 200 + Random().nextInt(400),
        images: [
          'https://picsum.photos/500/300?random=trending_$i',
        ],
        addons: [
          models.AddonModel(
            id: 'addon_trending_$i',
            name: 'Trending Addon',
            description: 'Popular addon this season',
            price: (250 + Random().nextInt(400)).toDouble(),
          ),
        ],
        tags: ['trending', 'popular'],
        isActive: true,
        isFeatured: Random().nextBool(),
        createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(30))),
        updatedAt: DateTime.now(),
      ));
    }
    
    return services;
  }
}