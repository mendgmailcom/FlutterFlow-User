import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  // User state
  Map<String, dynamic>? _user;
  bool _isLoggedIn = false;
  String? _authToken;

  // Booking state
  List<Map<String, dynamic>> _bookings = [];
  Map<String, dynamic>? _currentBooking;

  // Service state
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _categories = [];

  // Provider state
  List<Map<String, dynamic>> _providers = [];

  // Wallet state
  double _walletBalance = 0.0;
  List<Map<String, dynamic>> _transactions = [];

  // Chat state
  List<Map<String, dynamic>> _chatMessages = [];
  Map<String, dynamic>? _currentChat;

  // Location state
  Map<String, double>? _currentLocation;

  // UI state
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDarkMode = false;

  // Getters
  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  String? get authToken => _authToken;
  List<Map<String, dynamic>> get bookings => _bookings;
  Map<String, dynamic>? get currentBooking => _currentBooking;
  List<Map<String, dynamic>> get services => _services;
  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get providers => _providers;
  double get walletBalance => _walletBalance;
  List<Map<String, dynamic>> get transactions => _transactions;
  List<Map<String, dynamic>> get chatMessages => _chatMessages;
  Map<String, dynamic>? get currentChat => _currentChat;
  Map<String, double>? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isDarkMode => _isDarkMode;

  // User methods
  void setUser(Map<String, dynamic>? user) {
    _user = user;
    _isLoggedIn = user != null;
    notifyListeners();
  }

  void setAuthToken(String? token) {
    _authToken = token;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    _authToken = null;
    _bookings = [];
    _currentBooking = null;
    _services = [];
    _providers = [];
    _walletBalance = 0.0;
    _transactions = [];
    _chatMessages = [];
    _currentChat = null;
    notifyListeners();
  }

  // Booking methods
  void setBookings(List<Map<String, dynamic>> bookings) {
    _bookings = bookings;
    notifyListeners();
  }

  void addBooking(Map<String, dynamic> booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void updateBooking(String bookingId, Map<String, dynamic> updatedBooking) {
    _bookings = _bookings.map((booking) {
      if (booking['id'] == bookingId) {
        return updatedBooking;
      }
      return booking;
    }).toList();
    notifyListeners();
  }

  void removeBooking(String bookingId) {
    _bookings.removeWhere((booking) => booking['id'] == bookingId);
    notifyListeners();
  }

  void setCurrentBooking(Map<String, dynamic>? booking) {
    _currentBooking = booking;
    notifyListeners();
  }

  // Service methods
  void setServices(List<Map<String, dynamic>> services) {
    _services = services;
    notifyListeners();
  }

  void addService(Map<String, dynamic> service) {
    _services.add(service);
    notifyListeners();
  }

  void setCategories(List<Map<String, dynamic>> categories) {
    _categories = categories;
    notifyListeners();
  }

  // Provider methods
  void setProviders(List<Map<String, dynamic>> providers) {
    _providers = providers;
    notifyListeners();
  }

  void addProvider(Map<String, dynamic> provider) {
    _providers.add(provider);
    notifyListeners();
  }

  // Wallet methods
  void setWalletBalance(double balance) {
    _walletBalance = balance;
    notifyListeners();
  }

  void setTransactions(List<Map<String, dynamic>> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  void addTransaction(Map<String, dynamic> transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  // Chat methods
  void setChatMessages(List<Map<String, dynamic>> messages) {
    _chatMessages = messages;
    notifyListeners();
  }

  void addChatMessage(Map<String, dynamic> message) {
    _chatMessages.add(message);
    notifyListeners();
  }

  void setCurrentChat(Map<String, dynamic>? chat) {
    _currentChat = chat;
    notifyListeners();
  }

  // Location methods
  void setCurrentLocation(Map<String, double>? location) {
    _currentLocation = location;
    notifyListeners();
  }

  // UI methods
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
}