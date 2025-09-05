class ServiceModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final List<AddonModel> addons;
  final List<String> tags;
  final bool isActive;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.addons,
    required this.tags,
    required this.isActive,
    required this.isFeatured,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      images: List<String>.from(json['images'] ?? []),
      addons: List<AddonModel>.from(
        (json['addons'] as List<dynamic>? ?? [])
            .map((x) => AddonModel.fromJson(x as Map<String, dynamic>)),
      ),
      tags: List<String>.from(json['tags'] ?? []),
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'images': images,
      'addons': addons.map((x) => x.toJson()).toList(),
      'tags': tags,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AddonModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final bool isSelected;

  AddonModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.isSelected = false,
  });

  factory AddonModel.fromJson(Map<String, dynamic> json) {
    return AddonModel(
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

  AddonModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    bool? isSelected,
  }) {
    return AddonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String imageUrl;
  final int serviceCount;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.imageUrl,
    required this.serviceCount,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      imageUrl: json['imageUrl'] as String,
      serviceCount: json['serviceCount'] as int,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'imageUrl': imageUrl,
      'serviceCount': serviceCount,
      'isActive': isActive,
    };
  }
}