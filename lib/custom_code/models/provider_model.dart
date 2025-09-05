import 'index.dart';

class ProviderModel {
  final String id;
  final String businessName;
  final String ownerName;
  final String description;
  final String category;
  final String? email;
  final String phone;
  final List<String> images;
  final UserAddress businessAddress;
  final List<ProviderService> services;
  final List<ProviderReview> reviews;
  final double averageRating;
  final bool isVerified;
  final bool isActive;
  final int totalBookings;
  final int completedBookings;
  final ProviderBusinessHours businessHours;
  final List<String> certifications;
  final double responseTime;
  final bool isOnline;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProviderModel({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.description,
    required this.category,
    this.email,
    required this.phone,
    required this.images,
    required this.businessAddress,
    required this.services,
    required this.reviews,
    required this.averageRating,
    required this.isVerified,
    required this.isActive,
    required this.totalBookings,
    required this.completedBookings,
    required this.businessHours,
    required this.certifications,
    required this.responseTime,
    required this.isOnline,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      ownerName: json['ownerName'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      images: List<String>.from(json['images'] ?? []),
      businessAddress: UserAddress.fromJson(
        json['businessAddress'] as Map<String, dynamic>,
      ),
      services: List<ProviderService>.from(
        (json['services'] as List<dynamic>? ?? [])
            .map((x) => ProviderService.fromJson(x as Map<String, dynamic>)),
      ),
      reviews: List<ProviderReview>.from(
        (json['reviews'] as List<dynamic>? ?? [])
            .map((x) => ProviderReview.fromJson(x as Map<String, dynamic>)),
      ),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      isVerified: json['isVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      totalBookings: json['totalBookings'] as int? ?? 0,
      completedBookings: json['completedBookings'] as int? ?? 0,
      businessHours: ProviderBusinessHours.fromJson(
        json['businessHours'] as Map<String, dynamic>? ?? {},
      ),
      certifications: List<String>.from(json['certifications'] ?? []),
      responseTime: (json['responseTime'] as num?)?.toDouble() ?? 0.0,
      isOnline: json['isOnline'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessName': businessName,
      'ownerName': ownerName,
      'description': description,
      'category': category,
      'email': email,
      'phone': phone,
      'images': images,
      'businessAddress': businessAddress.toJson(),
      'services': services.map((x) => x.toJson()).toList(),
      'reviews': reviews.map((x) => x.toJson()).toList(),
      'averageRating': averageRating,
      'isVerified': isVerified,
      'isActive': isActive,
      'totalBookings': totalBookings,
      'completedBookings': completedBookings,
      'businessHours': businessHours.toJson(),
      'certifications': certifications,
      'responseTime': responseTime,
      'isOnline': isOnline,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ProviderService {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final List<ProviderAddon> addons;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProviderService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.addons,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProviderService.fromJson(Map<String, dynamic> json) {
    return ProviderService(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      addons: List<ProviderAddon>.from(
        (json['addons'] as List<dynamic>? ?? [])
            .map((x) => ProviderAddon.fromJson(x as Map<String, dynamic>)),
      ),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'addons': addons.map((x) => x.toJson()).toList(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ProviderAddon {
  final String id;
  final String name;
  final String description;
  final double price;
  final bool isSelected;

  ProviderAddon({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.isSelected = false,
  });

  factory ProviderAddon.fromJson(Map<String, dynamic> json) {
    return ProviderAddon(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'isSelected': isSelected,
    };
  }
}

class ProviderReview {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String review;
  final List<String> images;
  final DateTime createdAt;

  ProviderReview({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.review,
    required this.images,
    required this.createdAt,
  });

  factory ProviderReview.fromJson(Map<String, dynamic> json) {
    return ProviderReview(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      rating: (json['rating'] as num).toDouble(),
      review: json['review'] as String,
      images: List<String>.from(json['images'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'review': review,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ProviderBusinessHours {
  final Map<String, BusinessHours> hours;
  final bool isOpen24Hours;
  final bool isClosedOnHolidays;

  ProviderBusinessHours({
    required this.hours,
    required this.isOpen24Hours,
    required this.isClosedOnHolidays,
  });

  factory ProviderBusinessHours.fromJson(Map<String, dynamic> json) {
    final hoursMap = <String, BusinessHours>{};
    if (json['hours'] != null) {
      (json['hours'] as Map<String, dynamic>).forEach((key, value) {
        hoursMap[key] = BusinessHours.fromJson(value as Map<String, dynamic>);
      });
    }

    return ProviderBusinessHours(
      hours: hoursMap,
      isOpen24Hours: json['isOpen24Hours'] as bool? ?? false,
      isClosedOnHolidays: json['isClosedOnHolidays'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final hoursJson = <String, dynamic>{};
    hours.forEach((key, value) {
      hoursJson[key] = value.toJson();
    });

    return {
      'hours': hoursJson,
      'isOpen24Hours': isOpen24Hours,
      'isClosedOnHolidays': isClosedOnHolidays,
    };
  }
}

class BusinessHours {
  final String openTime;
  final String closeTime;
  final bool isClosed;

  BusinessHours({
    required this.openTime,
    required this.closeTime,
    required this.isClosed,
  });

  factory BusinessHours.fromJson(Map<String, dynamic> json) {
    return BusinessHours(
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
      isClosed: json['isClosed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openTime': openTime,
      'closeTime': closeTime,
      'isClosed': isClosed,
    };
  }
}
