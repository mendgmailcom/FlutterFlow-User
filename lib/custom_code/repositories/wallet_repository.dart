import 'dart:async';
import 'dart:math';
import '../../custom_code/models/index.dart' as models;

class WalletRepository {
  // In a real app, this would connect to an API
  // For demo, we'll simulate API calls with delays

  // Get wallet balance
  Future<models.WalletModel> getWallet() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock wallet
    final now = DateTime.now();
    final walletId = 'wallet_${Random().nextInt(1000000)}';

    return models.WalletModel(
      id: walletId,
      userId: 'user_current',
      balance: (1000 + Random().nextInt(10000)).toDouble(),
      currency: 'USD',
      transactions: List.generate(15 + Random().nextInt(20), (index) {
        final transactionDate = now.subtract(Duration(
          days: Random().nextInt(90), // Up to 90 days ago
        ));

        final isCredit = Random().nextBool();
        final amount = (50 + Random().nextInt(2000)).toDouble();

        return models.WalletTransaction(
          id: 'transaction_$index',
          walletId: walletId,
          type: isCredit ? 'credit' : 'debit',
          amount: amount,
          currency: 'USD',
          description: isCredit
              ? [
                  'Service Payment Refund',
                  'Promotional Credit',
                  'Wallet Top-up',
                  'Bonus Reward'
                ][Random().nextInt(4)]
              : [
                  'Service Payment',
                  'Booking Fee',
                  'Withdrawal',
                  'Subscription'
                ][Random().nextInt(4)],
          status: ['completed', 'pending', 'failed'][Random().nextInt(3)],
          referenceId: 'ref_${Random().nextInt(1000000)}',
          relatedEntityId: 'entity_${Random().nextInt(1000000)}',
          balanceAfter:
              (1000 + Random().nextInt(10000) + (isCredit ? amount : -amount))
                  .toDouble(),
          createdAt: transactionDate,
          completedAt:
              transactionDate.add(Duration(minutes: Random().nextInt(60))),
        );
      }),
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
          email: 'user@example.com',
          isDefault: false,
        ),
      ],
      limits: models.WalletLimits(
        dailyLimit: 10000.0,
        monthlyLimit: 100000.0,
        perTransactionLimit: 5000.0,
        currentDailyUsage: (0 + Random().nextInt(5000)).toDouble(),
        currentMonthlyUsage: (0 + Random().nextInt(50000)).toDouble(),
      ),
      createdAt: now.subtract(Duration(days: Random().nextInt(365))),
      updatedAt: now,
    );
  }

  // Add money to wallet
  Future<models.WalletTopUp> addMoneyToWallet(
      double amount, String paymentMethod, String currency) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate mock top-up
    final now = DateTime.now();
    final topUpId = 'topup_${Random().nextInt(1000000)}';

    return models.WalletTopUp(
      id: topUpId,
      userId: 'user_current',
      amount: amount,
      currency: currency,
      paymentMethod: paymentMethod,
      status: 'completed',
      transactionId: 'txn_${Random().nextInt(1000000)}',
      createdAt: now,
      completedAt: now.add(const Duration(seconds: 30)),
    );
  }

  // Withdraw money from wallet
  Future<models.WalletWithdrawal> withdrawMoneyFromWallet(
      double amount, String bankAccount, String currency) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate mock withdrawal
    final now = DateTime.now();
    final withdrawalId = 'withdrawal_${Random().nextInt(1000000)}';

    return models.WalletWithdrawal(
      id: withdrawalId,
      userId: 'user_current',
      amount: amount,
      currency: currency,
      bankAccount: bankAccount,
      status: 'processing',
      transactionId: 'txn_${Random().nextInt(1000000)}',
      createdAt: now,
      completedAt: null,
      failureReason: null,
    );
  }

  // Get transaction history
  Future<List<models.WalletTransaction>> getTransactionHistory({
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 50,
    String? type,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Generate mock transactions
    final List<models.WalletTransaction> transactions = [];
    final now = DateTime.now();
    const walletId = 'wallet_demo';

    for (int i = 0; i < limit; i++) {
      final transactionDate = now.subtract(Duration(
        days: Random().nextInt(90), // Up to 90 days ago
      ));

      // Skip transactions outside date range if specified
      if (startDate != null && transactionDate.isBefore(startDate)) continue;
      if (endDate != null && transactionDate.isAfter(endDate)) continue;

      final isCredit = Random().nextBool();
      final transactionType = type ?? (isCredit ? 'credit' : 'debit');
      final amount = (10 + Random().nextInt(2000)).toDouble();

      transactions.add(models.WalletTransaction(
        id: 'history_transaction_${(page - 1) * limit + i}',
        walletId: walletId,
        type: transactionType,
        amount: amount,
        currency: 'USD',
        description: isCredit
            ? [
                'Service Refund',
                'Promotional Credit',
                'Wallet Top-up',
                'Bonus Reward',
                'Referal Bonus'
              ][Random().nextInt(5)]
            : [
                'Service Payment',
                'Booking Fee',
                'Withdrawal',
                'Subscription',
                'Transfer'
              ][Random().nextInt(5)],
        status: ['completed', 'pending', 'failed'][Random().nextInt(3)],
        referenceId: 'ref_${Random().nextInt(1000000)}',
        relatedEntityId: 'entity_${Random().nextInt(1000000)}',
        balanceAfter:
            (1000 + Random().nextInt(10000) + (isCredit ? amount : -amount))
                .toDouble(),
        createdAt: transactionDate,
        completedAt:
            transactionDate.add(Duration(minutes: Random().nextInt(120))),
      ));
    }

    // Sort by creation date (newest first)
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Filter by type if specified
    if (type != null) {
      return transactions.where((t) => t.type == type).toList();
    }

    return transactions;
  }

  // Get wallet limits
  Future<models.WalletLimits> getWalletLimits() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate mock limits
    return models.WalletLimits(
      dailyLimit: 10000.0,
      monthlyLimit: 100000.0,
      perTransactionLimit: 5000.0,
      currentDailyUsage: (0 + Random().nextInt(5000)).toDouble(),
      currentMonthlyUsage: (0 + Random().nextInt(50000)).toDouble(),
    );
  }

  // Update wallet limits
  Future<models.WalletLimits> updateWalletLimits(
      Map<String, dynamic> limitsData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock updated limits
    return models.WalletLimits(
      dailyLimit: (limitsData['dailyLimit'] as num?)?.toDouble() ?? 10000.0,
      monthlyLimit:
          (limitsData['monthlyLimit'] as num?)?.toDouble() ?? 100000.0,
      perTransactionLimit:
          (limitsData['perTransactionLimit'] as num?)?.toDouble() ?? 5000.0,
      currentDailyUsage:
          (limitsData['currentDailyUsage'] as num?)?.toDouble() ??
              (0 + Random().nextInt(5000)).toDouble(),
      currentMonthlyUsage:
          (limitsData['currentMonthlyUsage'] as num?)?.toDouble() ??
              (0 + Random().nextInt(50000)).toDouble(),
    );
  }

  // Get payment methods
  Future<List<models.PaymentMethod>> getPaymentMethods() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Generate mock payment methods
    return [
      models.PaymentMethod(
        id: 'card_${Random().nextInt(1000)}',
        type: 'credit_card',
        name: 'Visa ending in 1234',
        last4: '1234',
        expiry: '${1 + Random().nextInt(12)}/25',
        isDefault: true,
      ),
      models.PaymentMethod(
        id: 'card_${Random().nextInt(1000)}',
        type: 'debit_card',
        name: 'Mastercard ending in 5678',
        last4: '5678',
        expiry: '${1 + Random().nextInt(12)}/24',
        isDefault: false,
      ),
      models.PaymentMethod(
        id: 'wallet_${Random().nextInt(1000)}',
        type: 'wallet',
        name: 'Google Pay',
        email: 'user@example.com',
        isDefault: false,
      ),
      models.PaymentMethod(
        id: 'wallet_${Random().nextInt(1000)}',
        type: 'wallet',
        name: 'Apple Pay',
        email: 'user@apple.com',
        isDefault: false,
      ),
      models.PaymentMethod(
        id: 'upi_${Random().nextInt(1000)}',
        type: 'upi',
        name: 'PhonePe',
        upiId: 'user@phonepe',
        isDefault: false,
      ),
    ];
  }

  // Add payment method
  Future<models.PaymentMethod> addPaymentMethod(
      Map<String, dynamic> paymentData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock payment method
    return models.PaymentMethod(
      id: 'new_payment_${Random().nextInt(1000000)}',
      type: paymentData['type'] as String? ?? 'credit_card',
      name: paymentData['name'] as String? ?? 'New Payment Method',
      last4: paymentData['last4'] as String?,
      expiry: paymentData['expiry'] as String?,
      email: paymentData['email'] as String?,
      upiId: paymentData['upiId'] as String?,
      isDefault: paymentData['isDefault'] as bool? ?? false,
    );
  }

  // Remove payment method
  Future<bool> removePaymentMethod(String paymentMethodId) async {
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

  // Get wallet statistics
  Future<Map<String, dynamic>> getWalletStatistics(
      {DateTime? startDate, DateTime? endDate}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock statistics
    final income = (1000 + Random().nextInt(5000)).toDouble();
    final expenses = (500 + Random().nextInt(3000)).toDouble();

    return {
      'total_balance': income - expenses,
      'total_income': income,
      'total_expenses': expenses,
      'income_by_category': {
        'service_refunds': (income * 0.6).toDouble(),
        'promotions': (income * 0.25).toDouble(),
        'top_ups': (income * 0.15).toDouble(),
      },
      'expenses_by_category': {
        'service_payments': (expenses * 0.7).toDouble(),
        'withdrawals': (expenses * 0.2).toDouble(),
        'subscriptions': (expenses * 0.1).toDouble(),
      },
      'transaction_count': 25 + Random().nextInt(50),
      'avg_transaction_amount':
          (expenses / (15 + Random().nextInt(20))).toDouble(),
    };
  }

  // Get recent transactions
  Future<List<models.WalletTransaction>> getRecentTransactions(
      {int limit = 10}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Generate mock recent transactions
    final List<models.WalletTransaction> transactions = [];
    final now = DateTime.now();
    const walletId = 'wallet_recent';

    for (int i = 0; i < limit; i++) {
      final transactionDate = now.subtract(Duration(
        minutes: Random().nextInt(60 * 24 * 7), // Up to 7 days ago
      ));

      final isCredit = Random().nextBool();
      final amount = (20 + Random().nextInt(1000)).toDouble();

      transactions.add(models.WalletTransaction(
        id: 'recent_transaction_$i',
        walletId: walletId,
        type: isCredit ? 'credit' : 'debit',
        amount: amount,
        currency: 'USD',
        description: isCredit
            ? [
                'Service Refund',
                'Promotional Credit',
                'Wallet Top-up'
              ][Random().nextInt(3)]
            : [
                'Service Payment',
                'Booking Fee',
                'Withdrawal'
              ][Random().nextInt(3)],
        status: 'completed',
        referenceId: 'ref_${Random().nextInt(1000000)}',
        relatedEntityId: 'entity_${Random().nextInt(1000000)}',
        balanceAfter:
            (1000 + Random().nextInt(5000) + (isCredit ? amount : -amount))
                .toDouble(),
        createdAt: transactionDate,
        completedAt:
            transactionDate.add(Duration(minutes: Random().nextInt(30))),
      ));
    }

    // Sort by creation date (newest first)
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return transactions;
  }

  // Transfer money between wallets
  Future<models.WalletTransaction> transferMoney(String toWalletId,
      double amount, String currency, String description) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate mock transfer transaction
    final now = DateTime.now();
    final transactionId = 'transfer_${Random().nextInt(1000000)}';
    const walletId = 'wallet_current';

    return models.WalletTransaction(
      id: transactionId,
      walletId: walletId,
      type: 'transfer_out',
      amount: amount,
      currency: currency,
      description: description,
      status: 'completed',
      referenceId: 'ref_${Random().nextInt(1000000)}',
      relatedEntityId: toWalletId,
      balanceAfter: (1000 + Random().nextInt(5000) - amount).toDouble(),
      createdAt: now,
      completedAt: now.add(const Duration(seconds: 30)),
    );
  }

  // Request money from another wallet
  Future<models.WalletTransaction> requestMoney(String fromWalletId,
      double amount, String currency, String description) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock request transaction
    final now = DateTime.now();
    final transactionId = 'request_${Random().nextInt(1000000)}';
    const walletId = 'wallet_current';

    return models.WalletTransaction(
      id: transactionId,
      walletId: walletId,
      type: 'request',
      amount: amount,
      currency: currency,
      description: description,
      status: 'pending',
      referenceId: 'ref_${Random().nextInt(1000000)}',
      relatedEntityId: fromWalletId,
      balanceAfter: (1000 + Random().nextInt(5000)).toDouble(),
      createdAt: now,
      completedAt: null,
    );
  }

  // Get pending requests
  Future<List<models.WalletTransaction>> getPendingRequests() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Generate mock pending requests
    final List<models.WalletTransaction> requests = [];
    final now = DateTime.now();
    const walletId = 'wallet_current';

    for (int i = 0; i < 3 + Random().nextInt(5); i++) {
      requests.add(models.WalletTransaction(
        id: 'pending_request_$i',
        walletId: walletId,
        type: 'request',
        amount: (50 + Random().nextInt(500)).toDouble(),
        currency: 'USD',
        description: 'Money request from friend',
        status: 'pending',
        referenceId: 'ref_${Random().nextInt(1000000)}',
        relatedEntityId: 'wallet_friend_$i',
        balanceAfter: (1000 + Random().nextInt(5000)).toDouble(),
        createdAt: now.subtract(Duration(hours: Random().nextInt(48))),
        completedAt: null,
      ));
    }

    return requests;
  }

  // Approve money request
  Future<bool> approveMoneyRequest(String requestId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would make an API call
    // For demo, we'll just return success
    return true;
  }

  // Reject money request
  Future<bool> rejectMoneyRequest(String requestId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, this would make an API call
    // For demo, we'll just return success
    return true;
  }
}
