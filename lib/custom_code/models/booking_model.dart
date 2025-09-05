import 'index.dart';

class BookingModel {
  final String id;
  final String serviceId;
  final String serviceName;
  final String providerId;
  final String providerName;
  final DateTime scheduledDate;
  final String scheduledTime;
  final String serviceAddress;
  final String status;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final List<AddonModel> addons;
  final String? specialInstructions;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.providerId,
    required this.providerName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.serviceAddress,
    required this.status,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.addons,
    this.specialInstructions,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      scheduledTime: json['scheduledTime'] as String,
      serviceAddress: json['serviceAddress'] as String,
      status: json['status'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: json['paymentStatus'] as String,
      addons: List<AddonModel>.from(
        (json['addons'] as List<dynamic>? ?? [])
            .map((x) => AddonModel.fromJson(x as Map<String, dynamic>)),
      ),
      specialInstructions: json['specialInstructions'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'providerId': providerId,
      'providerName': providerName,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': scheduledTime,
      'serviceAddress': serviceAddress,
      'status': status,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'addons': addons.map((x) => x.toJson()).toList(),
      'specialInstructions': specialInstructions,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  BookingModel copyWith({
    String? id,
    String? serviceId,
    String? serviceName,
    String? providerId,
    String? providerName,
    DateTime? scheduledDate,
    String? scheduledTime,
    String? serviceAddress,
    String? status,
    double? totalAmount,
    String? paymentMethod,
    String? paymentStatus,
    List<AddonModel>? addons,
    String? specialInstructions,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      serviceAddress: serviceAddress ?? this.serviceAddress,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      addons: addons ?? this.addons,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BookingStatusUpdate {
  final String bookingId;
  final String status;
  final String message;
  final DateTime timestamp;

  BookingStatusUpdate({
    required this.bookingId,
    required this.status,
    required this.message,
    required this.timestamp,
  });

  factory BookingStatusUpdate.fromJson(Map<String, dynamic> json) {
    return BookingStatusUpdate(
      bookingId: json['bookingId'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'status': status,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
