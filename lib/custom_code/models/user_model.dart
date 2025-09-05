class UserModel {
  final String id;
  final String name;
  final String? email;
  final String phone;
  final String? avatar;
  final String? coverImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<UserAddress> addresses;
  final List<PaymentMethod> paymentMethods;
  final UserProfileStats stats;
  final UserPreferences preferences;
  final UserMembership membership;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    this.avatar,
    this.coverImage,
    required this.createdAt,
    required this.updatedAt,
    required this.addresses,
    required this.paymentMethods,
    required this.stats,
    required this.preferences,
    required this.membership,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      avatar: json['avatar'] as String?,
      coverImage: json['coverImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      addresses: List<UserAddress>.from(
        (json['addresses'] as List<dynamic>? ?? [])
            .map((x) => UserAddress.fromJson(x as Map<String, dynamic>)),
      ),
      paymentMethods: List<PaymentMethod>.from(
        (json['paymentMethods'] as List<dynamic>? ?? [])
            .map((x) => PaymentMethod.fromJson(x as Map<String, dynamic>)),
      ),
      stats: UserProfileStats.fromJson(
        json['stats'] as Map<String, dynamic>? ?? {},
      ),
      preferences: UserPreferences.fromJson(
        json['preferences'] as Map<String, dynamic>? ?? {},
      ),
      membership: UserMembership.fromJson(
        json['membership'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'coverImage': coverImage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'addresses': addresses.map((x) => x.toJson()).toList(),
      'paymentMethods': paymentMethods.map((x) => x.toJson()).toList(),
      'stats': stats.toJson(),
      'preferences': preferences.toJson(),
      'membership': membership.toJson(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? coverImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<UserAddress>? addresses,
    List<PaymentMethod>? paymentMethods,
    UserProfileStats? stats,
    UserPreferences? preferences,
    UserMembership? membership,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      coverImage: coverImage ?? this.coverImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      stats: stats ?? this.stats,
      preferences: preferences ?? this.preferences,
      membership: membership ?? this.membership,
    );
  }
}

class UserAddress {
  final String id;
  final String title;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  UserAddress({
    required this.id,
    required this.title,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.latitude,
    this.longitude,
    required this.isDefault,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'] as String,
      title: json['title'] as String,
      addressLine1: json['addressLine1'] as String,
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  String get fullAddress {
    final parts = [
      addressLine1,
      addressLine2,
      '$city, $state $zipCode',
      country,
    ];
    return parts.where((part) => part != null && part.isNotEmpty).join(', ');
  }
}

class PaymentMethod {
  final String id;
  final String type;
  final String name;
  final String? last4;
  final String? expiry;
  final String? email;
  final String? upiId;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    this.last4,
    this.expiry,
    this.email,
    this.upiId,
    required this.isDefault,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      last4: json['last4'] as String?,
      expiry: json['expiry'] as String?,
      email: json['email'] as String?,
      upiId: json['upiId'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'last4': last4,
      'expiry': expiry,
      'email': email,
      'upiId': upiId,
      'isDefault': isDefault,
    };
  }
}

class UserProfileStats {
  final int totalBookings;
  final int completedBookings;
  final int cancelledBookings;
  final double averageRating;
  final int totalReviews;
  final double totalSpent;

  UserProfileStats({
    required this.totalBookings,
    required this.completedBookings,
    required this.cancelledBookings,
    required this.averageRating,
    required this.totalReviews,
    required this.totalSpent,
  });

  factory UserProfileStats.fromJson(Map<String, dynamic> json) {
    return UserProfileStats(
      totalBookings: json['totalBookings'] as int? ?? 0,
      completedBookings: json['completedBookings'] as int? ?? 0,
      cancelledBookings: json['cancelledBookings'] as int? ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBookings': totalBookings,
      'completedBookings': completedBookings,
      'cancelledBookings': cancelledBookings,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'totalSpent': totalSpent,
    };
  }
}

class UserPreferences {
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool pushNotifications;
  final String language;
  final String currency;
  final bool darkMode;
  final List<String> favoriteCategories;

  UserPreferences({
    required this.notificationsEnabled,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.pushNotifications,
    required this.language,
    required this.currency,
    required this.darkMode,
    required this.favoriteCategories,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      currency: json['currency'] as String? ?? 'INR',
      darkMode: json['darkMode'] as bool? ?? false,
      favoriteCategories: List<String>.from(
        json['favoriteCategories'] as List<dynamic>? ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'pushNotifications': pushNotifications,
      'language': language,
      'currency': currency,
      'darkMode': darkMode,
      'favoriteCategories': favoriteCategories,
    };
  }
}

class UserMembership {
  final String tier;
  final DateTime? expiresAt;
  final int points;
  final List<String> benefits;

  UserMembership({
    required this.tier,
    this.expiresAt,
    required this.points,
    required this.benefits,
  });

  factory UserMembership.fromJson(Map<String, dynamic> json) {
    return UserMembership(
      tier: json['tier'] as String? ?? 'free',
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      points: json['points'] as int? ?? 0,
      benefits: List<String>.from(json['benefits'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tier': tier,
      'expiresAt': expiresAt?.toIso8601String(),
      'points': points,
      'benefits': benefits,
    };
  }
}