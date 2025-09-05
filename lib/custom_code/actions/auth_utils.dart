import 'dart:async';
import 'dart:math';

class AuthUtils {
  // Simulate user authentication
  static Future<Map<String, dynamic>> loginWithPhone(String phone) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful login
    return {
      'success': true,
      'userId': 'user_${Random().nextInt(10000)}',
      'token': 'token_${Random().nextInt(1000000)}',
      'userData': {
        'id': 'user_${Random().nextInt(10000)}',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': phone,
        'avatar':
            'https://picsum.photos/200/200?random=${Random().nextInt(100)}',
      }
    };
  }

  // Simulate OTP verification
  static Future<Map<String, dynamic>> verifyOtp(
      String phone, String otp) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate OTP (in real app, this would be done server-side)
    final isValid = otp == '123456'; // For demo purposes

    if (isValid) {
      return {
        'success': true,
        'userId': 'user_${Random().nextInt(10000)}',
        'token': 'token_${Random().nextInt(1000000)}',
      };
    } else {
      return {
        'success': false,
        'error': 'Invalid OTP',
      };
    }
  }

  // Simulate user registration
  static Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> userData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful registration
    return {
      'success': true,
      'userId': 'user_${Random().nextInt(10000)}',
      'token': 'token_${Random().nextInt(1000000)}',
      'userData': userData,
    };
  }

  // Simulate logout
  static Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, this would clear tokens and user data
  }

  // Simulate password reset
  static Future<Map<String, dynamic>> resetPassword(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate successful password reset request
    return {
      'success': true,
      'message': 'Password reset link sent to your email',
    };
  }

  // Simulate social login
  static Future<Map<String, dynamic>> loginWithGoogle() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful Google login
    return {
      'success': true,
      'userId': 'user_${Random().nextInt(10000)}',
      'token': 'token_${Random().nextInt(1000000)}',
      'userData': {
        'id': 'user_${Random().nextInt(10000)}',
        'name': 'Google User',
        'email': 'google.user@example.com',
        'avatar':
            'https://picsum.photos/200/200?random=${Random().nextInt(100)}',
      }
    };
  }

  static Future<Map<String, dynamic>> loginWithApple() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful Apple login
    return {
      'success': true,
      'userId': 'user_${Random().nextInt(10000)}',
      'token': 'token_${Random().nextInt(1000000)}',
      'userData': {
        'id': 'user_${Random().nextInt(10000)}',
        'name': 'Apple User',
        'email': 'apple.user@example.com',
        'avatar':
            'https://picsum.photos/200/200?random=${Random().nextInt(100)}',
      }
    };
  }

  // Validate phone number
  static bool isValidPhoneNumber(String phone) {
    // Simple validation for Indian phone numbers
    final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  // Validate email
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  // Generate random OTP for demo
  static String generateOtp() {
    return '123456'; // For demo purposes
  }

  // Validate OTP
  static bool isValidOtp(String otp) {
    return otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);
  }
}
