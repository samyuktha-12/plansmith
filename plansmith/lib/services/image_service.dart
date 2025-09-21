import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageService {
  /// Get image URL for a single place using Unsplash API
  static String getPlaceImageUrl(String placeName) {
    // Return specific high-quality images for each location
    switch (placeName.toLowerCase()) {
      case 'jeju island':
        return 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800&h=600&fit=crop&q=80'; // Jeju Island landscape
      case 'south korea':
        return 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800&h=600&fit=crop&q=80'; // Seoul cityscape
      case 'indonesia':
        return 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop&q=80'; // Bali temple
      case 'malang':
        return 'https://images.unsplash.com/photo-1528181304800-259b08848526?w=800&h=600&fit=crop&q=80'; // Indonesian landscape
      case 'paris':
        return 'https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=800&h=600&fit=crop&q=80'; // Eiffel Tower
      case 'japan':
        return 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800&h=600&fit=crop&q=80'; // Japanese temple
      case 'switzerland':
        return 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop&q=80'; // Swiss Alps
      default:
        return 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&h=600&fit=crop&q=80'; // Default travel image
    }
  }

  /// Verify if image URL exists (optional)
  static Future<bool> verifyImageExists(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Get images for multiple places (returns map)
  static Map<String, String> getPlaceImages(List<String> placeNames) {
    final Map<String, String> results = {};
    for (var place in placeNames) {
      results[place] = getPlaceImageUrl(place);
    }
    return results;
  }

  /// Preload images (just triggers the URLs, does not cache)
  static Future<void> preloadPlaceImages() async {
    const places = [
      'Jeju Island',
      'South Korea',
      'Indonesia',
      'Malang',
      'Paris',
      'Japan',
      'Switzerland',
    ];

    final futures = places.map((place) async {
      final url = getPlaceImageUrl(place);
      await verifyImageExists(url); // optional
    });

    await Future.wait(futures);
    print('Preloaded ${places.length} place images.');
  }

  /// Fallback image if Unsplash fails
  static String getFallbackImageUrl(String placeName) {
    return 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop';
  }
}
