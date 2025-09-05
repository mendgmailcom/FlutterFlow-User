import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  late SharedPreferences _prefs;
  Database? _database;
  final Map<String, CacheItem> _memoryCache = {};
  final Map<String, Timer> _expirationTimers = {};

  // Initialize the cache service
  Future<void> initialize() async {
    // Initialize shared preferences
    _prefs = await SharedPreferences.getInstance();

    // Initialize database
    await _initDatabase();
  }

  // Initialize SQLite database
  Future<void> _initDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'cache.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // Create cache table
          await db.execute('''
            CREATE TABLE cache (
              key TEXT PRIMARY KEY,
              value TEXT NOT NULL,
              expiry INTEGER,
              created_at INTEGER NOT NULL,
              accessed_at INTEGER NOT NULL
            )
          ''');

          // Create indices for performance
          await db.execute('CREATE INDEX idx_cache_expiry ON cache(expiry)');
          await db.execute(
              'CREATE INDEX idx_cache_accessed_at ON cache(accessed_at)');
        },
      );
    } catch (e) {
      // If database initialization fails, we'll fall back to memory and shared preferences
      // This shouldn't happen in normal circumstances
    }
  }

  // Get value from cache
  Future<T?> get<T>(String key,
      {T Function(Map<String, dynamic>)? fromJson}) async {
    // Check memory cache first (fastest)
    final memoryItem = _memoryCache[key];
    if (memoryItem != null && !memoryItem.isExpired) {
      memoryItem.accessedAt = DateTime.now().millisecondsSinceEpoch;
      return _deserialize<T>(memoryItem.value, fromJson);
    }

    // Remove expired memory item
    if (memoryItem != null) {
      _memoryCache.remove(key);
    }

    // Check database cache
    if (_database != null) {
      try {
        final result = await _database!.query(
          'cache',
          where: 'key = ? AND (expiry IS NULL OR expiry > ?)',
          whereArgs: [key, DateTime.now().millisecondsSinceEpoch],
        );

        if (result.isNotEmpty) {
          final item = result.first;
          final value = item['value'] as String;
          final createdAt = item['created_at'] as int;

          // Update accessed time
          await _database!.update(
            'cache',
            {'accessed_at': DateTime.now().millisecondsSinceEpoch},
            where: 'key = ?',
            whereArgs: [key],
          );

          // Add to memory cache
          _memoryCache[key] = CacheItem(
            key: key,
            value: value,
            createdAt: createdAt,
            accessedAt: DateTime.now().millisecondsSinceEpoch,
          );

          return _deserialize<T>(value, fromJson);
        }
      } catch (e) {
        // Database error, fall back to shared preferences
      }
    }

    // Check shared preferences
    final prefValue = _prefs.getString(key);
    if (prefValue != null) {
      // Add to memory cache
      final cacheItem = CacheItem(
        key: key,
        value: prefValue,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        accessedAt: DateTime.now().millisecondsSinceEpoch,
      );
      _memoryCache[key] = cacheItem;
      return _deserialize<T>(prefValue, fromJson);
    }

    // Not found in any cache
    return null;
  }

  // Set value in cache
  Future<void> set<T>(
    String key,
    T value, {
    Duration? expiry,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic> Function(T)? toJson,
  }) async {
    final serializedValue = _serialize<T>(value, toJson);
    final now = DateTime.now().millisecondsSinceEpoch;
    final expiryTime = expiry != null ? now + expiry.inMilliseconds : null;

    // Store in memory cache
    _memoryCache[key] = CacheItem(
      key: key,
      value: serializedValue,
      expiry: expiryTime,
      createdAt: now,
      accessedAt: now,
    );

    // Set expiration timer if needed
    if (expiry != null) {
      _expirationTimers[key]?.cancel();
      _expirationTimers[key] = Timer(expiry, () {
        _memoryCache.remove(key);
        _expirationTimers.remove(key);
      });
    }

    // Store in database
    if (_database != null) {
      try {
        await _database!.insert(
          'cache',
          {
            'key': key,
            'value': serializedValue,
            'expiry': expiryTime,
            'created_at': now,
            'accessed_at': now,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        // Database error, fall back to shared preferences
        await _prefs.setString(key, serializedValue);
      }
    } else {
      // Fall back to shared preferences
      await _prefs.setString(key, serializedValue);
    }
  }

  // Remove value from cache
  Future<void> remove(String key) async {
    // Remove from memory cache
    _memoryCache.remove(key);
    _expirationTimers[key]?.cancel();
    _expirationTimers.remove(key);

    // Remove from database
    if (_database != null) {
      try {
        await _database!.delete(
          'cache',
          where: 'key = ?',
          whereArgs: [key],
        );
      } catch (e) {
        // Database error, remove from shared preferences
        await _prefs.remove(key);
      }
    } else {
      // Remove from shared preferences
      await _prefs.remove(key);
    }
  }

  // Clear all cache
  Future<void> clear() async {
    // Clear memory cache
    _memoryCache.clear();

    // Cancel all timers
    for (final timer in _expirationTimers.values) {
      timer.cancel();
    }
    _expirationTimers.clear();

    // Clear database
    if (_database != null) {
      try {
        await _database!.delete('cache');
      } catch (e) {
        // Database error, clear shared preferences
        await _prefs.clear();
      }
    } else {
      // Clear shared preferences
      await _prefs.clear();
    }
  }

  // Check if key exists in cache
  Future<bool> containsKey(String key) async {
    // Check memory cache
    if (_memoryCache.containsKey(key)) {
      return !_memoryCache[key]!.isExpired;
    }

    // Check database
    if (_database != null) {
      try {
        final result = await _database!.query(
          'cache',
          columns: ['key'],
          where: 'key = ? AND (expiry IS NULL OR expiry > ?)',
          whereArgs: [key, DateTime.now().millisecondsSinceEpoch],
        );
        return result.isNotEmpty;
      } catch (e) {
        // Database error, check shared preferences
        return _prefs.containsKey(key);
      }
    } else {
      // Check shared preferences
      return _prefs.containsKey(key);
    }
  }

  // Get cache statistics
  Future<Map<String, dynamic>> getStats() async {
    int memoryCount = _memoryCache.length;
    int dbCount = 0;
    int prefCount = 0;

    // Count database entries
    if (_database != null) {
      try {
        final result =
            await _database!.rawQuery('SELECT COUNT(*) as count FROM cache');
        dbCount = result.first['count'] as int;
      } catch (e) {
        // Ignore database errors
      }
    }

    // Count shared preferences
    prefCount = _prefs.getKeys().length;

    return {
      'memory_items': memoryCount,
      'database_items': dbCount,
      'preferences_items': prefCount,
      'total_items': memoryCount + dbCount + prefCount,
    };
  }

  // Serialize value to string
  String _serialize<T>(T value, Map<String, dynamic> Function(T)? toJson) {
    if (value is String) {
      return value;
    } else if (value is num || value is bool) {
      return value.toString();
    } else if (value is Map<String, dynamic>) {
      return jsonEncode(value);
    } else if (value is List) {
      return jsonEncode(value);
    } else if (toJson != null) {
      final map = toJson(value);
      return jsonEncode(map);
    } else {
      // Try to convert to JSON-serializable format
      try {
        return jsonEncode(value);
      } catch (e) {
        // If serialization fails, return string representation
        return value.toString();
      }
    }
  }

  // Deserialize string to value
  T? _deserialize<T>(String value, T Function(Map<String, dynamic>)? fromJson) {
    if (T == String) {
      return value as T;
    } else if (T == int) {
      return int.tryParse(value) as T?;
    } else if (T == double) {
      return double.tryParse(value) as T?;
    } else if (T == bool) {
      if (value.toLowerCase() == 'true') return true as T;
      if (value.toLowerCase() == 'false') return false as T;
      return null;
    } else if (T == Map<String, dynamic>) {
      try {
        return jsonDecode(value) as T?;
      } catch (e) {
        return null;
      }
    } else if (T == List) {
      try {
        return jsonDecode(value) as T?;
      } catch (e) {
        return null;
      }
    } else if (fromJson != null) {
      try {
        final map = jsonDecode(value) as Map<String, dynamic>;
        return fromJson(map);
      } catch (e) {
        return null;
      }
    } else {
      // Try to parse as generic JSON
      try {
        return jsonDecode(value) as T?;
      } catch (e) {
        return null;
      }
    }
  }

  // Cleanup expired cache entries
  Future<void> cleanupExpired() async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Cleanup memory cache
    _memoryCache.removeWhere((key, item) => item.isExpired);

    // Cleanup database
    if (_database != null) {
      try {
        await _database!.delete(
          'cache',
          where: 'expiry < ?',
          whereArgs: [now],
        );
      } catch (e) {
        // Ignore database errors
      }
    }
  }

  // Get all keys
  Future<List<String>> getAllKeys() async {
    final keys = <String>{};

    // Add memory cache keys
    keys.addAll(_memoryCache.keys);

    // Add database keys
    if (_database != null) {
      try {
        final result = await _database!.query('cache', columns: ['key']);
        for (final row in result) {
          keys.add(row['key'] as String);
        }
      } catch (e) {
        // Ignore database errors
      }
    }

    // Add shared preferences keys
    keys.addAll(_prefs.getKeys());

    return keys.toList();
  }

  // Preload frequently accessed items into memory
  Future<void> preloadFrequentlyAccessed({int limit = 50}) async {
    if (_database != null) {
      try {
        final result = await _database!.query(
          'cache',
          orderBy: 'accessed_at DESC',
          limit: limit,
        );

        for (final row in result) {
          final key = row['key'] as String;
          final value = row['value'] as String;
          final createdAt = row['created_at'] as int;
          final accessedAt = row['accessed_at'] as int?;
          final expiry = row['expiry'] as int?;

          _memoryCache[key] = CacheItem(
            key: key,
            value: value,
            expiry: expiry,
            createdAt: createdAt,
            accessedAt: accessedAt ?? createdAt,
          );
        }
      } catch (e) {
        // Ignore database errors
      }
    }
  }

  // Close database connection
  Future<void> close() async {
    await _database?.close();
    _database = null;

    // Cancel all timers
    for (final timer in _expirationTimers.values) {
      timer.cancel();
    }
    _expirationTimers.clear();
  }

  // Generate mock cache data for testing
  Future<void> generateMockCacheData() async {
    // Generate mock services
    for (int i = 0; i < 20; i++) {
      await set<Map<String, dynamic>>(
        'mock_service_$i',
        {
          'id': 'service_$i',
          'name': 'Mock Service $i',
          'description': 'This is a mock service for testing purposes',
          'price': (100 + Random().nextInt(1000)).toDouble(),
          'rating': 3.5 + Random().nextDouble() * 1.5,
          'category': 'category_${Random().nextInt(5) + 1}',
        },
        expiry: const Duration(hours: 1),
      );
    }

    // Generate mock providers
    for (int i = 0; i < 15; i++) {
      await set<Map<String, dynamic>>(
        'mock_provider_$i',
        {
          'id': 'provider_$i',
          'businessName': 'Mock Provider $i',
          'ownerName': 'Owner $i',
          'description': 'This is a mock provider for testing purposes',
          'rating': 4.0 + Random().nextDouble(),
          'isVerified': Random().nextBool(),
        },
        expiry: const Duration(hours: 2),
      );
    }

    // Generate mock user data
    await set<Map<String, dynamic>>(
      'mock_user_profile',
      {
        'id': 'user_mock',
        'name': 'Mock User',
        'email': 'mock@example.com',
        'phone': '+1${Random().nextInt(9000000000) + 1000000000}',
        'avatar': 'https://picsum.photos/200/200?random=user',
      },
      expiry: const Duration(minutes: 30),
    );
  }
}

// Cache item model
class CacheItem {
  final String key;
  final String value;
  final int? expiry;
  int createdAt;
  int accessedAt;

  CacheItem({
    required this.key,
    required this.value,
    this.expiry,
    required this.createdAt,
    required this.accessedAt,
  });

  bool get isExpired {
    if (expiry == null) return false;
    return DateTime.now().millisecondsSinceEpoch > expiry!;
  }

  @override
  String toString() {
    return 'CacheItem{key: $key, value: $value, expiry: $expiry, createdAt: $createdAt, accessedAt: $accessedAt}';
  }
}

// Extension for easy caching of futures
extension FutureCacheExtension<T> on Future<T> {
  Future<T> cache({
    required String key,
    Duration? expiry,
    Map<String, dynamic> Function(T)? toJson,
  }) async {
    final cacheService = CacheService();
    final cachedValue = await cacheService.get<T>(key);

    if (cachedValue != null) {
      return cachedValue;
    }

    final value = await this;
    await cacheService.set<T>(
      key,
      value,
      expiry: expiry,
      toJson: toJson,
    );

    return value;
  }
}

// Extension for easy caching of streams
extension StreamCacheExtension<T> on Stream<T> {
  Stream<T> cache({
    required String key,
    Duration? expiry,
    Map<String, dynamic> Function(T)? toJson,
  }) async* {
    final cacheService = CacheService();
    final cachedValue = await cacheService.get<T>(key);

    if (cachedValue != null) {
      yield cachedValue;
    }

    await for (final value in this) {
      await cacheService.set<T>(
        key,
        value,
        expiry: expiry,
        toJson: toJson,
      );
      yield value;
    }
  }
}
