import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart' as models;
import '../services/network_service.dart';
import '../services/error_handler.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final NetworkService _networkService = NetworkService();
  final ErrorHandler _errorHandler = ErrorHandler();

  // Authentication state
  bool _isAuthenticated = false;
  String? _authToken;
  models.UserModel? _currentUser;
  final StreamController<AuthState> _authStateController =
      StreamController<AuthState>.broadcast();

  // Initialize the auth service
  Future<void> initialize() async {
    // Check for existing auth token
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');

    if (_authToken != null) {
      // Try to restore user session
      try {
        await _restoreUserSession();
        _isAuthenticated = true;
        _authStateController.add(AuthState.authenticated);
      } catch (e) {
        // Failed to restore session, clear auth token
        await _clearAuthData();
        _authStateController.add(AuthState.unauthenticated);
      }
    } else {
      _authStateController.add(AuthState.unauthenticated);
    }
  }

  // Restore user session from token
  Future<void> _restoreUserSession() async {
    if (_authToken == null) return;

    try {
      // Set auth token in network service
      _networkService.setAuthToken(_authToken);

      // Fetch user profile
      final response = await _networkService.authGet('/user/profile');

      if (response.statusCode == 200 && response.data != null) {
        final userData = response.data['data'] as Map<String, dynamic>;
        _currentUser = models.UserModel.fromJson(userData);
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } catch (e, stackTrace) {
      _errorHandler.handleException(e, stackTrace,
          context: 'Restore user session');
      rethrow;
    }
  }

  // Login with phone number
  Future<AuthResult> loginWithPhone(String phone) async {
    try {
      // Validate phone number
      if (!_isValidPhoneNumber(phone)) {
        return AuthResult.failure(
          errorCode: 'INVALID_PHONE',
          message: 'Please enter a valid phone number',
        );
      }

      // Send login request
      final response = await _networkService.post(
        '/auth/login',
        data: {
          'phone': phone,
          'method': 'phone',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['success'] == true) {
          // OTP sent successfully
          return AuthResult.success(
            message: 'OTP sent successfully',
            requiresOtp: true,
          );
        } else {
          return AuthResult.failure(
            errorCode: responseData['error_code'] as String? ?? 'LOGIN_FAILED',
            message: responseData['message'] as String? ?? 'Login failed',
          );
        }
      } else {
        return AuthResult.failure(
          errorCode: 'LOGIN_FAILED',
          message: 'Failed to send OTP',
        );
      }
    } on Exception catch (e, stackTrace) {
      _errorHandler.handleException(e, stackTrace, context: 'Login with phone');
      return AuthResult.failure(
        errorCode: 'NETWORK_ERROR',
        message: 'Network error occurred. Please try again.',
      );
    }
  }

  // Verify OTP
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      // Validate OTP
      if (!_isValidOtp(otp)) {
        return AuthResult.failure(
          errorCode: 'INVALID_OTP',
          message: 'Please enter a valid 6-digit OTP',
        );
      }

      // Send OTP verification request
      final response = await _networkService.post(
        '/auth/verify-otp',
        data: {
          'phone': phone,
          'otp': otp,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['success'] == true) {
          // Extract auth token and user data
          _authToken = responseData['data']['token'] as String?;
          final userData =
              responseData['data']['user'] as Map<String, dynamic>?;

          if (_authToken != null && userData != null) {
            // Save auth token
            await _saveAuthData(_authToken!);

            // Set current user
            _currentUser = models.UserModel.fromJson(userData);

            // Set authenticated state
            _isAuthenticated = true;
            _authStateController.add(AuthState.authenticated);

            // Set auth token in network service
            _networkService.setAuthToken(_authToken);

            return AuthResult.success(
              message: 'Login successful',
              user: _currentUser,
            );
          } else {
            return AuthResult.failure(
              errorCode: 'AUTH_FAILED',
              message: 'Authentication failed',
            );
          }
        } else {
          return AuthResult.failure(
            errorCode: responseData['error_code'] as String? ?? 'OTP_INVALID',
            message: responseData['message'] as String? ?? 'Invalid OTP',
          );
        }
      } else {
        return AuthResult.failure(
          errorCode: 'OTP_VERIFICATION_FAILED',
          message: 'Failed to verify OTP',
        );
      }
    } on Exception catch (e, stackTrace) {
      _errorHandler.handleException(e, stackTrace, context: 'Verify OTP');
      return AuthResult.failure(
        errorCode: 'NETWORK_ERROR',
        message: 'Network error occurred. Please try again.',
      );
    }
  }

  // Register new user
  Future<AuthResult> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      // Validate inputs
      if (!_isValidPhoneNumber(phone)) {
        return AuthResult.failure(
          errorCode: 'INVALID_PHONE',
          message: 'Please enter a valid phone number',
        );
      }

      if (!_isValidEmail(email)) {
        return AuthResult.failure(
          errorCode: 'INVALID_EMAIL',
          message: 'Please enter a valid email address',
        );
      }

      if (password.length < 6) {
        return AuthResult.failure(
          errorCode: 'INVALID_PASSWORD',
          message: 'Password must be at least 6 characters long',
        );
      }

      // Send registration request
      final response = await _networkService.post(
        '/auth/register',
        data: {
          'name': name,
          'phone': phone,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['success'] == true) {
          // Extract auth token and user data
          _authToken = responseData['data']['token'] as String?;
          final userData =
              responseData['data']['user'] as Map<String, dynamic>?;

          if (_authToken != null && userData != null) {
            // Save auth token
            await _saveAuthData(_authToken!);

            // Set current user
            _currentUser = models.UserModel.fromJson(userData);

            // Set authenticated state
            _isAuthenticated = true;
            _authStateController.add(AuthState.authenticated);

            // Set auth token in network service
            _networkService.setAuthToken(_authToken);

            return AuthResult.success(
              message: 'Registration successful',
              user: _currentUser,
            );
          } else {
            return AuthResult.failure(
              errorCode: 'REGISTRATION_FAILED',
              message: 'Registration failed',
            );
          }
        } else {
          return AuthResult.failure(
            errorCode:
                responseData['error_code'] as String? ?? 'REGISTRATION_FAILED',
            message:
                responseData['message'] as String? ?? 'Registration failed',
          );
        }
      } else {
        return AuthResult.failure(
          errorCode: 'REGISTRATION_FAILED',
          message: 'Failed to register',
        );
      }
    } on Exception catch (e, stackTrace) {
      _errorHandler.handleException(e, stackTrace, context: 'Register user');
      return AuthResult.failure(
        errorCode: 'NETWORK_ERROR',
        message: 'Network error occurred. Please try again.',
      );
    }
  }

  // Login with email and password
  Future<AuthResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Validate inputs
      if (!_isValidEmail(email)) {
        return AuthResult.failure(
          errorCode: 'INVALID_EMAIL',
          message: 'Please enter a valid email address',
        );
      }

      if (password.isEmpty) {
        return AuthResult.failure(
          errorCode: 'INVALID_PASSWORD',
          message: 'Please enter your password',
        );
      }

      // Send login request
      final response = await _networkService.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'method': 'email',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['success'] == true) {
          // Extract auth token and user data
          _authToken = responseData['data']['token'] as String?;
          final userData =
              responseData['data']['user'] as Map<String, dynamic>?;

          if (_authToken != null && userData != null) {
            // Save auth token
            await _saveAuthData(_authToken!);

            // Set current user
            _currentUser = models.UserModel.fromJson(userData);

            // Set authenticated state
            _isAuthenticated = true;
            _authStateController.add(AuthState.authenticated);

            // Set auth token in network service
            _networkService.setAuthToken(_authToken);

            return AuthResult.success(
              message: 'Login successful',
              user: _currentUser,
            );
          } else {
            return AuthResult.failure(
              errorCode: 'LOGIN_FAILED',
              message: 'Login failed',
            );
          }
        } else {
          return AuthResult.failure(
            errorCode: responseData['error_code'] as String? ?? 'LOGIN_FAILED',
            message: responseData['message'] as String? ?? 'Login failed',
          );
        }
      } else {
        return AuthResult.failure(
          errorCode: 'LOGIN_FAILED',
          message: 'Failed to login',
        );
      }
    } on Exception catch (e, stackTrace) {
      _errorHandler.handleException(e, stackTrace, context: 'Login with email');
      return AuthResult.failure(
        errorCode: 'NETWORK_ERROR',
        message: 'Network error occurred. Please try again.',
      );
    }
  }

  // Social login (Google, Apple, etc.)
  Future<AuthResult> socialLogin({
    required String provider,
    required String accessToken,
  }) async {
    try {
      // Send social login request
      final response = await _networkService.post(
        '/auth/social-login',
        data: {
          'provider': provider,
          'access_token': accessToken,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['success'] == true) {
          // Extract auth token and user data
          _authToken = responseData['data']['token'] as String?;
          final userData =
              responseData['data']['user'] as Map<String, dynamic>?;

          if (_authToken != null && userData != null) {
            // Save auth token
            await _saveAuthData(_authToken!);

            // Set current user
            _currentUser = models.UserModel.fromJson(userData);

            // Set authenticated state
            _isAuthenticated = true;
            _authStateController.add(AuthState.authenticated);

            // Set auth token in network service
            _networkService.setAuthToken(_authToken);

            return AuthResult.success(
              message: 'Login successful',
              user: _currentUser,
            );
          } else {
            return AuthResult.failure(
              errorCode: 'LOGIN_FAILED',
              message: 'Login failed',
            );
          }
        } else {
          return AuthResult.failure(
            errorCode: responseData['error_code'] as String? ?? 'LOGIN_FAILED',
            message: responseData['message'] as String? ?? 'Login failed',
          );
        }
      } else {
        return AuthResult.failure(
          errorCode: 'LOGIN_FAILED',
          message: 'Failed to login',
        );
      }
    } on Exception catch (e, stackTrace) {
      _errorHandler.handleException(e, stackTrace, context: 'Social login');
      return AuthResult.failure(
        errorCode: 'NETWORK_ERROR',
        message: 'Network error occurred. Please try again.',
      );
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Clear auth data
      await _clearAuthData();

      // Set unauthenticated state
      _isAuthenticated = false;
      _authStateController.add(AuthState.unauthenticated);

      // Clear current user
      _currentUser = null;
    } catch (e, stackTrace) {
      _errorHandler.handleException(e, stackTrace, context: 'Logout');
      rethrow;
    }
  }

  // Refresh auth token
  Future<bool> refreshToken() async {
    if (_authToken == null) return false;

    try {
      // Send refresh token request
      final response = await _networkService.post(
        '/auth/refresh',
        data: {
          'token': _authToken,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['success'] == true) {
          // Extract new auth token
          final newToken = responseData['data']['token'] as String?;

          if (newToken != null) {
            // Save new auth token
            _authToken = newToken;
            await _saveAuthData(_authToken!);

            // Set auth token in network service
            _networkService.setAuthToken(_authToken);

            return true;
          }
        }
      }

      return false;
    } on Exception catch (e, stackTrace) {
      _errorHandler.handleException(e, stackTrace, context: 'Refresh token');
      return false;
    }
  }

  // Save auth data to persistent storage
  Future<void> _saveAuthData(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Clear auth data from persistent storage
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _authToken = null;
    _currentUser = null;
  }

  // Validate phone number
  bool _isValidPhoneNumber(String phone) {
    // Simple validation for Indian phone numbers
    final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  // Validate email
  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  // Validate OTP
  bool _isValidOtp(String otp) {
    return otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);
  }

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get authToken => _authToken;
  models.UserModel? get currentUser => _currentUser;
  Stream<AuthState> get authState => _authStateController.stream;

  // Close stream controller
  void dispose() {
    _authStateController.close();
  }
}

// Authentication state enum
enum AuthState {
  authenticated,
  unauthenticated,
  loading,
}

// Authentication result class
class AuthResult {
  final bool success;
  final String? message;
  final String? errorCode;
  final bool requiresOtp;
  final models.UserModel? user;

  AuthResult._({
    required this.success,
    this.message,
    this.errorCode,
    this.requiresOtp = false,
    this.user,
  });

  factory AuthResult.success({
    String? message,
    bool requiresOtp = false,
    models.UserModel? user,
  }) {
    return AuthResult._(
      success: true,
      message: message,
      requiresOtp: requiresOtp,
      user: user,
    );
  }

  factory AuthResult.failure({
    String? message,
    String? errorCode,
  }) {
    return AuthResult._(
      success: false,
      message: message,
      errorCode: errorCode,
    );
  }

  @override
  String toString() {
    return 'AuthResult{success: $success, message: $message, errorCode: $errorCode, requiresOtp: $requiresOtp, user: ${user?.name}}';
  }
}
