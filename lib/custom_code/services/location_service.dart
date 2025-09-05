import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled
      return false;
    }
    return true;
  }

  // Check location permissions
  Future<LocationPermission> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission;
  }

  // Request location permissions
  Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission;
  }

  // Get current position
  Future<Position> getCurrentPosition() async {
    // Check if location services are enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // Check location permissions
    LocationPermission permission = await checkLocationPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestLocationPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }

  // Get position stream
  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: locationSettings ??
          const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // Update every 10 meters
          ),
    );
  }

  // Get address from coordinates
  Future<List<Placemark>> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      return placemarks;
    } catch (e) {
      throw Exception('Failed to get address from coordinates: $e');
    }
  }

  // Get coordinates from address
  Future<List<Location>> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      return locations;
    } catch (e) {
      throw Exception('Failed to get coordinates from address: $e');
    }
  }

  // Calculate distance between two points (in kilometers)
  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Calculate bearing between two points
  double calculateBearing({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Get nearby places
  Future<List<NearbyPlace>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    String type = 'establishment',
    int radius = 1000, // in meters
    String keyword = '',
  }) async {
    // In a real app, this would call a places API
    // For demo, we'll generate mock nearby places

    final List<NearbyPlace> places = [];

    // Generate mock places
    for (int i = 0; i < 10 + Random().nextInt(10); i++) {
      // Generate nearby coordinates
      final nearbyLat = latitude + (Random().nextDouble() - 0.5) * 0.01;
      final nearbyLng = longitude + (Random().nextDouble() - 0.5) * 0.01;

      places.add(NearbyPlace(
        id: 'place_$i',
        name: '${[
          'Service',
          'Provider',
          'Business',
          'Shop'
        ][Random().nextInt(4)]} ${i + 1}',
        address: '${100 + i * 5} ${[
          'Main',
          'Oak',
          'Pine',
          'Elm'
        ][Random().nextInt(4)]} Street',
        latitude: nearbyLat,
        longitude: nearbyLng,
        distance: calculateDistance(
          startLatitude: latitude,
          startLongitude: longitude,
          endLatitude: nearbyLat,
          endLongitude: nearbyLng,
        ),
        rating: 3.0 + Random().nextDouble() * 2.0,
        isOpen: Random().nextBool(),
        phoneNumber: '+1${Random().nextInt(9000000000) + 1000000000}',
        website: 'https://www.example${i + 1}.com',
        types: [
          type,
          ['professional', 'service', 'business'][Random().nextInt(3)]
        ],
      ));
    }

    // Sort by distance
    places.sort((a, b) => a.distance.compareTo(b.distance));

    return places;
  }

  // Get formatted address string
  Future<String> getFormattedAddress({
    required double latitude,
    required double longitude,
  }) async {
    try {
      List<Placemark> placemarks = await getAddressFromCoordinates(
        latitude: latitude,
        longitude: longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}';
      }

      return 'Unknown Address';
    } catch (e) {
      return 'Address not available';
    }
  }

  // Check if user is within a certain radius of a location
  bool isWithinRadius({
    required double userLatitude,
    required double userLongitude,
    required double targetLatitude,
    required double targetLongitude,
    required double radiusInMeters,
  }) {
    double distance = calculateDistance(
      startLatitude: userLatitude,
      startLongitude: userLongitude,
      endLatitude: targetLatitude,
      endLongitude: targetLongitude,
    );

    // Convert distance from meters to kilometers and compare
    return (distance * 1000) <= radiusInMeters;
  }

  // Get mock location for testing
  Position getMockLocation() {
    return Position(
      latitude: 40.7128 + (Random().nextDouble() - 0.5) * 0.1,
      longitude: -74.0060 + (Random().nextDouble() - 0.5) * 0.1,
      timestamp: DateTime.now(),
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      accuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      floor: null,
    );
  }

  // Get location with timeout
  Future<Position> getCurrentPositionWithTimeout({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    return Future.any([
      getCurrentPosition(),
      Future.delayed(timeout,
          () => throw TimeoutException('Location request timed out', timeout)),
    ]);
  }

  // Get last known position
  Future<Position?> getLastKnownPosition() async {
    try {
      Position? position = await Geolocator.getLastKnownPosition();
      return position;
    } catch (e) {
      // Return null if last known position is not available
      return null;
    }
  }
}

// Model class for nearby places
class NearbyPlace {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance; // in meters
  final double rating;
  final bool isOpen;
  final String phoneNumber;
  final String website;
  final List<String> types;

  NearbyPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.rating,
    required this.isOpen,
    required this.phoneNumber,
    required this.website,
    required this.types,
  });

  @override
  String toString() {
    return 'NearbyPlace{id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, distance: $distance, rating: $rating, isOpen: $isOpen, phoneNumber: $phoneNumber, website: $website, types: $types}';
  }
}
