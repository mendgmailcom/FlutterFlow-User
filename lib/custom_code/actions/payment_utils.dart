import 'dart:async';
import 'dart:math';

class PaymentUtils {
  // Simulate processing a payment
  static Future<Map<String, dynamic>> processPayment(Map<String, dynamic> paymentData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 3));
    
    // Simulate payment processing (80% success rate for demo)
    final isSuccess = Random().nextDouble() > 0.2;
    
    if (isSuccess) {
      return {
        'success': true,
        'transactionId': 'txn_${Random().nextInt(1000000)}',
        'paymentId': 'pay_${Random().nextInt(1000000)}',
        'amount': paymentData['amount'],
        'currency': paymentData['currency'] ?? 'INR',
        'status': 'success',
        'message': 'Payment processed successfully',
      };
    } else {
      return {
        'success': false,
        'error': 'Payment failed. Please try again.',
        'errorCode': 'PAYMENT_FAILED',
      };
    }
  }

  // Simulate adding money to wallet
  static Future<Map<String, dynamic>> addMoneyToWallet(double amount, String paymentMethod) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate successful wallet top-up
    return {
      'success': true,
      'transactionId': 'txn_${Random().nextInt(1000000)}',
      'amount': amount,
      'paymentMethod': paymentMethod,
      'newBalance': (1000 + Random().nextInt(5000) + amount).toDouble(),
      'message': '₹${amount.toStringAsFixed(2)} added to wallet successfully',
    };
  }

  // Simulate withdrawing money from wallet
  static Future<Map<String, dynamic>> withdrawMoneyFromWallet(double amount, String bankAccount) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate successful withdrawal
    return {
      'success': true,
      'transactionId': 'txn_${Random().nextInt(1000000)}',
      'amount': amount,
      'bankAccount': bankAccount,
      'status': 'processing',
      'message': '₹${amount.toStringAsFixed(2)} withdrawal initiated. Will be processed within 24 hours.',
    };
  }

  // Get user's payment methods
  static Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return mock payment methods
    return [
      {
        'id': 'card_1',
        'type': 'credit_card',
        'name': 'Credit Card',
        'last4': '1234',
        'expiry': '12/25',
        'isDefault': true,
      },
      {
        'id': 'card_2',
        'type': 'debit_card',
        'name': 'Debit Card',
        'last4': '5678',
        'expiry': '06/24',
        'isDefault': false,
      },
      {
        'id': 'wallet_1',
        'type': 'wallet',
        'name': 'Google Pay',
        'email': 'user@example.com',
        'isDefault': false,
      },
      {
        'id': 'upi_1',
        'type': 'upi',
        'name': 'PhonePe',
        'upiId': 'user@phonepe',
        'isDefault': false,
      },
    ];
  }

  // Add new payment method
  static Future<Map<String, dynamic>> addPaymentMethod(Map<String, dynamic> paymentMethod) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate successful addition
    return {
      'success': true,
      'paymentMethodId': 'pm_${Random().nextInt(1000000)}',
      'message': 'Payment method added successfully',
    };
  }

  // Remove payment method
  static Future<Map<String, dynamic>> removePaymentMethod(String paymentMethodId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate successful removal
    return {
      'success': true,
      'message': 'Payment method removed successfully',
    };
  }

  // Set default payment method
  static Future<Map<String, dynamic>> setDefaultPaymentMethod(String paymentMethodId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate successful update
    return {
      'success': true,
      'message': 'Default payment method updated successfully',
    };
  }

  // Get transaction history
  static Future<List<Map<String, dynamic>>> getTransactionHistory({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Generate mock transactions
    final List<Map<String, dynamic>> transactions = [];
    final int count = min(limit, 20); // Max 20 for demo
    
    for (int i = 0; i < count; i++) {
      final isCredit = Random().nextBool();
      final amount = (100 + Random().nextInt(5000)).toDouble();
      final daysAgo = Random().nextInt(30);
      
      transactions.add({
        'id': 'txn_$i',
        'type': isCredit ? 'credit' : 'debit',
        'amount': amount,
        'currency': 'INR',
        'description': isCredit 
            ? ['Service Payment Refund', 'Wallet Top-up', 'Promotional Credit'][Random().nextInt(3)]
            : ['Service Payment', 'Booking Fee', 'Wallet Withdrawal'][Random().nextInt(3)],
        'status': ['completed', 'pending', 'failed'][Random().nextInt(3)],
        'timestamp': DateTime.now().subtract(Duration(days: daysAgo)).toIso8601String(),
        'balanceAfter': (1000 + Random().nextInt(5000)).toDouble(),
      });
    }
    
    // Sort by timestamp (newest first)
    transactions.sort((a, b) => 
        DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
    
    return transactions;
  }

  // Get wallet balance
  static Future<Map<String, dynamic>> getWalletBalance() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Return mock wallet balance
    final balance = (1000 + Random().nextInt(5000)).toDouble();
    
    return {
      'balance': balance,
      'currency': 'INR',
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  // Validate card number (simplified)
  static bool isValidCardNumber(String cardNumber) {
    // Remove spaces and dashes
    final cleanNumber = cardNumber.replaceAll(RegExp(r'[\s-]'), '');
    
    // Check if it's all digits and has valid length
    if (!RegExp(r'^\d{13,19}$').hasMatch(cleanNumber)) {
      return false;
    }
    
    // Luhn algorithm for basic validation
    return _luhnCheck(cleanNumber);
  }

  // Validate expiry date
  static bool isValidExpiryDate(String expiry) {
    // Expected format: MM/YY or MM/YYYY
    final RegExp expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2}|[0-9]{4})$');
    if (!expiryRegex.hasMatch(expiry)) {
      return false;
    }
    
    final parts = expiry.split('/');
    final month = int.parse(parts[0]);
    final year = parts[1].length == 2 
        ? 2000 + int.parse(parts[1]) 
        : int.parse(parts[1]);
    
    final now = DateTime.now();
    final expiryDate = DateTime(year, month + 1, 0); // Last day of the month
    
    return expiryDate.isAfter(now);
  }

  // Validate CVV
  static bool isValidCvv(String cvv) {
    return RegExp(r'^\d{3,4}$').hasMatch(cvv);
  }

  // Helper method for Luhn algorithm
  static bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool isEven = false;
    
    // Loop through values starting from the rightmost side
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      
      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      
      sum += digit;
      isEven = !isEven;
    }
    
    return sum % 10 == 0;
  }
}