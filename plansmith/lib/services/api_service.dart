import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator localhost
  // For iOS simulator use: 'http://localhost:8000'
  // For physical device use your computer's IP address
  
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Health check
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/health'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }

  // Generate itinerary using AI
  static Future<Map<String, dynamic>?> generateItinerary(Map<String, dynamic> preferences) async {
    try {
      print('Generating itinerary with preferences: $preferences');
      
      // Convert Flutter preferences to backend format
      final tripRequest = _convertToTripRequest(preferences);
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/trips/generate'),
        headers: headers,
        body: jsonEncode(tripRequest),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Itinerary generated successfully: ${data['itinerary_id']}');
        return data;
      } else {
        print('Failed to generate itinerary: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error generating itinerary: $e');
      return null;
    }
  }

  // Get activities based on preferences
  static Future<List<Map<String, dynamic>>> getActivities(Map<String, dynamic> preferences) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/activities'),
        headers: headers,
        body: jsonEncode(preferences),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['activities'] ?? []);
      } else {
        print('Failed to get activities: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting activities: $e');
      return [];
    }
  }

  // Get accommodations based on preferences
  static Future<List<Map<String, dynamic>>> getAccommodations(Map<String, dynamic> preferences) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/accommodations'),
        headers: headers,
        body: jsonEncode(preferences),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['accommodations'] ?? []);
      } else {
        print('Failed to get accommodations: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting accommodations: $e');
      return [];
    }
  }

  // Get flights based on preferences
  static Future<List<Map<String, dynamic>>> getFlights(Map<String, dynamic> preferences) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/flights'),
        headers: headers,
        body: jsonEncode(preferences),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['flights'] ?? []);
      } else {
        print('Failed to get flights: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting flights: $e');
      return [];
    }
  }

  // Get restaurants based on preferences
  static Future<List<Map<String, dynamic>>> getRestaurants(Map<String, dynamic> preferences) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/restaurants'),
        headers: headers,
        body: jsonEncode(preferences),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['restaurants'] ?? []);
      } else {
        print('Failed to get restaurants: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting restaurants: $e');
      return [];
    }
  }

  // Search locations
  static Future<List<Map<String, dynamic>>> searchLocations(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/locations/search?query=${Uri.encodeComponent(query)}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['locations'] ?? []);
      } else {
        print('Failed to search locations: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error searching locations: $e');
      return [];
    }
  }

  // Convert Flutter preferences to backend TripRequest format
  static Map<String, dynamic> _convertToTripRequest(Map<String, dynamic> preferences) {
    final destination = preferences['destination'] as Map<String, dynamic>? ?? {};
    final startDate = DateTime.now().add(const Duration(days: 7));
    final endDate = startDate.add(Duration(days: int.parse(preferences['trip_duration'] ?? '5')));

    return {
      'origin': {
        'name': 'Current Location',
        'city': 'Current City',
        'state': 'Current State',
        'country': 'Current Country',
      },
      'destination': {
        'name': '${destination['city'] ?? ''}, ${destination['country'] ?? ''}',
        'city': destination['city'] ?? '',
        'state': '', // We'll let the backend handle this
        'country': destination['country'] ?? '',
      },
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'travelers_count': preferences['travelers_count'] ?? 1,
      'preferences': {
        'themes': (preferences['themes'] as List<dynamic>? ?? [])
            .map((theme) => theme.toString().toLowerCase())
            .toList(),
        'budget_level': preferences['budget_level'] ?? 'mid_range',
        'max_budget': (preferences['budget_amount'] ?? 50000).toDouble(),
        'dietary_restrictions': [],
        'accessibility_needs': [],
        'languages_spoken': ['English'],
        'travel_style': preferences['travel_style'] ?? 'balanced',
        'interests': (preferences['interests'] as List<dynamic>? ?? [])
            .map((interest) => interest.toString().toLowerCase())
            .toList(),
        'travelers_count': preferences['travelers_count'] ?? 1,
      },
      'special_requirements': preferences['notes'] ?? '',
    };
  }
}
