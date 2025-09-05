import 'index.dart';

class WalletModel {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final List<WalletTransaction> transactions;
  final List<PaymentMethod> paymentMethods;
  final WalletLimits limits;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.transactions,
    required this.paymentMethods,
    required this.limits,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
      transactions: List<WalletTransaction>.from(
        (json['transactions'] as List<dynamic>? ?? [])
            .map((x) => WalletTransaction.fromJson(x as Map<String, dynamic>)),
      ),
      paymentMethods: List<PaymentMethod>.from(
        (json['paymentMethods'] as List<dynamic>? ?? [])
            .map((x) => PaymentMethod.fromJson(x as Map<String, dynamic>)),
      ),
      limits: WalletLimits.fromJson(
        json['limits'] as Map<String, dynamic>? ?? {},
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'balance': balance,
      'currency': currency,
      'transactions': transactions.map((x) => x.toJson()).toList(),
      'paymentMethods': paymentMethods.map((x) => x.toJson()).toList(),
      'limits': limits.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class WalletTransaction {
  final String id;
  final String walletId;
  final String type;
  final double amount;
  final String currency;
  final String description;
  final String status;
  final String? referenceId;
  final String? relatedEntityId;
  final double balanceAfter;
  final DateTime createdAt;
  final DateTime? completedAt;

  WalletTransaction({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.description,
    required this.status,
    this.referenceId,
    this.relatedEntityId,
    required this.balanceAfter,
    required this.createdAt,
    this.completedAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'] as String,
      walletId: json['walletId'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      referenceId: json['referenceId'] as String?,
      relatedEntityId: json['relatedEntityId'] as String?,
      balanceAfter: (json['balanceAfter'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletId': walletId,
      'type': type,
      'amount': amount,
      'currency': currency,
      'description': description,
      'status': status,
      'referenceId': referenceId,
      'relatedEntityId': relatedEntityId,
      'balanceAfter': balanceAfter,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

class WalletLimits {
  final double dailyLimit;
  final double monthlyLimit;
  final double perTransactionLimit;
  final double currentDailyUsage;
  final double currentMonthlyUsage;

  WalletLimits({
    required this.dailyLimit,
    required this.monthlyLimit,
    required this.perTransactionLimit,
    required this.currentDailyUsage,
    required this.currentMonthlyUsage,
  });

  factory WalletLimits.fromJson(Map<String, dynamic> json) {
    return WalletLimits(
      dailyLimit: (json['dailyLimit'] as num?)?.toDouble() ?? 10000.0,
      monthlyLimit: (json['monthlyLimit'] as num?)?.toDouble() ?? 100000.0,
      perTransactionLimit:
          (json['perTransactionLimit'] as num?)?.toDouble() ?? 5000.0,
      currentDailyUsage: (json['currentDailyUsage'] as num?)?.toDouble() ?? 0.0,
      currentMonthlyUsage:
          (json['currentMonthlyUsage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyLimit': dailyLimit,
      'monthlyLimit': monthlyLimit,
      'perTransactionLimit': perTransactionLimit,
      'currentDailyUsage': currentDailyUsage,
      'currentMonthlyUsage': currentMonthlyUsage,
    };
  }
}

class WalletTopUp {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final String paymentMethod;
  final String status;
  final String? transactionId;
  final DateTime createdAt;
  final DateTime? completedAt;

  WalletTopUp({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.status,
    this.transactionId,
    required this.createdAt,
    this.completedAt,
  });

  factory WalletTopUp.fromJson(Map<String, dynamic> json) {
    return WalletTopUp(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      transactionId: json['transactionId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'paymentMethod': paymentMethod,
      'status': status,
      'transactionId': transactionId,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

class WalletWithdrawal {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final String bankAccount;
  final String status;
  final String? transactionId;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;

  WalletWithdrawal({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.bankAccount,
    required this.status,
    this.transactionId,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
  });

  factory WalletWithdrawal.fromJson(Map<String, dynamic> json) {
    return WalletWithdrawal(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      bankAccount: json['bankAccount'] as String,
      status: json['status'] as String,
      transactionId: json['transactionId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      failureReason: json['failureReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'bankAccount': bankAccount,
      'status': status,
      'transactionId': transactionId,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'failureReason': failureReason,
    };
  }
}
