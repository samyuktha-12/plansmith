import 'dart:math';

class MockData {
  static final Random _random = Random();

  static List<Map<String, dynamic>> getActivities(Map<String, dynamic> preferences) {
    final themes = preferences['themes'] as List<String>? ?? [];
    final budgetLevel = preferences['budget_level'] as String? ?? 'mid_range';
    final interests = preferences['interests'] as List<String>? ?? [];
    
    print('MockData.getActivities called with:');
    print('Themes: $themes');
    print('Budget Level: $budgetLevel');
    print('Interests: $interests');

    List<Map<String, dynamic>> allActivities = [
      // Heritage & Cultural
      {
        'name': 'Amber Fort Heritage Walk',
        'description': 'Explore the magnificent Amber Fort with a guided heritage walk through the palace complex, including the Sheesh Mahal and Diwan-e-Aam.',
        'category': 'Heritage',
        'duration_hours': 3.0,
        'cost_per_person': 800,
        'rating': 4.7,
        'location': 'Amber, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Temples', 'Museums'],
      },
      {
        'name': 'City Palace & Museum Tour',
        'description': 'Discover the royal history of Jaipur with a comprehensive tour of the City Palace and its museum collections.',
        'category': 'Heritage',
        'duration_hours': 2.5,
        'cost_per_person': 600,
        'rating': 4.5,
        'location': 'City Palace, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Museums', 'Temples'],
      },
      {
        'name': 'Jantar Mantar Observatory',
        'description': 'Visit the world\'s largest stone astronomical observatory and learn about ancient Indian astronomy.',
        'category': 'Heritage',
        'duration_hours': 1.5,
        'cost_per_person': 400,
        'rating': 4.3,
        'location': 'Jantar Mantar, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1594736797933-d0c1b6b7b5e5?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Museums'],
      },

      // Adventure
      {
        'name': 'Hot Air Balloon Ride',
        'description': 'Experience Jaipur from above with a breathtaking hot air balloon ride over the Pink City at sunrise.',
        'category': 'Adventure',
        'duration_hours': 2.0,
        'cost_per_person': 2500,
        'rating': 4.9,
        'location': 'Jaipur Sky',
        'image_url': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop',
        'themes': ['Adventure', 'Nature'],
        'interests': ['Water Sports', 'Photography'],
      },
      {
        'name': 'Elephant Safari at Amer',
        'description': 'Ride an elephant up to the Amber Fort and experience the royal way of entering the palace.',
        'category': 'Adventure',
        'duration_hours': 1.0,
        'cost_per_person': 1200,
        'rating': 4.2,
        'location': 'Amber Fort, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
        'themes': ['Adventure', 'Heritage'],
        'interests': ['Wildlife'],
      },
      {
        'name': 'Desert Safari Experience',
        'description': 'Embark on a thrilling desert safari with camel rides and traditional Rajasthani entertainment.',
        'category': 'Adventure',
        'duration_hours': 4.0,
        'cost_per_person': 1800,
        'rating': 4.6,
        'location': 'Sam Sand Dunes',
        'image_url': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
        'themes': ['Adventure', 'Nature'],
        'interests': ['Wildlife', 'Photography'],
      },

      // Relaxation & Wellness
      {
        'name': 'Ayurvedic Spa Retreat',
        'description': 'Rejuvenate with traditional Ayurvedic treatments and therapies at a luxury spa resort.',
        'category': 'Wellness',
        'duration_hours': 3.0,
        'cost_per_person': 3500,
        'rating': 4.8,
        'location': 'Luxury Resort, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=400&h=300&fit=crop',
        'themes': ['Relaxation', 'Wellness'],
        'interests': ['Wellness'],
      },
      {
        'name': 'Yoga Session at Heritage Hotel',
        'description': 'Start your day with a peaceful yoga session in the serene gardens of a heritage hotel.',
        'category': 'Wellness',
        'duration_hours': 1.5,
        'cost_per_person': 800,
        'rating': 4.4,
        'location': 'Heritage Hotel, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
        'themes': ['Relaxation', 'Wellness'],
        'interests': ['Wellness'],
      },

      // Food & Culinary
      {
        'name': 'Rajasthani Cooking Class',
        'description': 'Learn to cook authentic Rajasthani dishes with a local chef in a traditional kitchen setting.',
        'category': 'Food',
        'duration_hours': 2.5,
        'cost_per_person': 1200,
        'rating': 4.7,
        'location': 'Heritage Haveli, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Street Food Walking Tour',
        'description': 'Explore Jaipur\'s vibrant street food scene with a knowledgeable local guide.',
        'category': 'Food',
        'duration_hours': 2.0,
        'cost_per_person': 600,
        'rating': 4.5,
        'location': 'Old City, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine', 'Markets'],
      },

      // Nature & Photography
      {
        'name': 'Sariska Wildlife Safari',
        'description': 'Spot tigers, leopards, and other wildlife in their natural habitat at Sariska Tiger Reserve.',
        'category': 'Nature',
        'duration_hours': 6.0,
        'cost_per_person': 1500,
        'rating': 4.6,
        'location': 'Sariska Tiger Reserve',
        'image_url': 'https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=400&h=300&fit=crop',
        'themes': ['Nature', 'Adventure'],
        'interests': ['Wildlife', 'Photography'],
      },
      {
        'name': 'Sunrise Photography Tour',
        'description': 'Capture the golden hour beauty of Jaipur\'s monuments with a professional photography guide.',
        'category': 'Photography',
        'duration_hours': 2.0,
        'cost_per_person': 1000,
        'rating': 4.8,
        'location': 'Various Monuments, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=400&h=300&fit=crop',
        'themes': ['Photography', 'Nature'],
        'interests': ['Photography', 'Museums'],
      },

      // Shopping & Markets
      {
        'name': 'Bapu Bazaar Shopping Experience',
        'description': 'Shop for traditional Rajasthani handicrafts, textiles, and jewelry in the famous Bapu Bazaar.',
        'category': 'Shopping',
        'duration_hours': 2.0,
        'cost_per_person': 300,
        'rating': 4.2,
        'location': 'Bapu Bazaar, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=300&fit=crop',
        'themes': ['Shopping', 'Cultural'],
        'interests': ['Markets'],
      },
      {
        'name': 'Gemstone Workshop Tour',
        'description': 'Visit traditional gemstone workshops and learn about the art of jewelry making in Jaipur.',
        'category': 'Cultural',
        'duration_hours': 1.5,
        'cost_per_person': 500,
        'rating': 4.4,
        'location': 'Gemstone Workshops, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400&h=300&fit=crop',
        'themes': ['Cultural', 'Shopping'],
        'interests': ['Markets', 'Art Galleries'],
      },
    ];

    // Filter activities based on preferences
    final filteredActivities = allActivities.where((activity) {
      final activityThemes = activity['themes'] as List<String>;
      final activityInterests = activity['interests'] as List<String>;
      
      // Check if any theme matches
      final themeMatch = themes.isEmpty || 
          themes.any((theme) => activityThemes.any((activityTheme) => 
              activityTheme.toLowerCase().contains(theme.toLowerCase()) ||
              theme.toLowerCase().contains(activityTheme.toLowerCase())));
      
      // Check if any interest matches
      final interestMatch = interests.isEmpty ||
          interests.any((interest) => activityInterests.any((activityInterest) =>
              activityInterest.toLowerCase().contains(interest.toLowerCase()) ||
              interest.toLowerCase().contains(activityInterest.toLowerCase())));
      
      // Check budget compatibility
      final activityCost = activity['cost_per_person'] as int;
      final budgetMatch = _isBudgetCompatible(budgetLevel, activityCost);
      
      return themeMatch && interestMatch && budgetMatch;
    }).toList();
    
    print('Filtered activities count: ${filteredActivities.length}');
    if (filteredActivities.isNotEmpty) {
      print('First filtered activity: ${filteredActivities.first['name']}');
    } else {
      print('No activities found, returning first 3 activities as fallback');
      return allActivities.take(3).toList();
    }
    
    return filteredActivities;
  }

  static List<Map<String, dynamic>> getAccommodations(Map<String, dynamic> preferences) {
    final budgetLevel = preferences['budget_level'] as String? ?? 'mid_range';
    final travelersCount = preferences['travelers_count'] as int? ?? 1;
    
    print('MockData.getAccommodations called with budget level: $budgetLevel');

    List<Map<String, dynamic>> allAccommodations = [
      {
        'name': 'The Raj Palace',
        'type': 'Luxury Hotel',
        'cost_per_night': 15000,
        'rating': 4.8,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Parking'],
        'location': 'Civil Lines, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
        'description': 'A magnificent heritage palace hotel offering royal luxury with modern amenities.',
        'budget_level': 'luxury',
      },
      {
        'name': 'Hotel Clarks Amer',
        'type': 'Business Hotel',
        'cost_per_night': 8000,
        'rating': 4.5,
        'amenities': ['Swimming Pool', 'Restaurant', 'WiFi', 'Gym', 'Parking'],
        'location': 'C-Scheme, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Modern business hotel with excellent facilities and central location.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Jaipur Heritage Homestay',
        'type': 'Heritage Homestay',
        'cost_per_night': 3500,
        'rating': 4.6,
        'amenities': ['WiFi', 'Traditional Meals', 'Cultural Shows', 'Garden'],
        'location': 'Old City, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Authentic Rajasthani experience in a beautifully restored heritage haveli.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Zostel Jaipur',
        'type': 'Hostel',
        'cost_per_night': 800,
        'rating': 4.3,
        'amenities': ['WiFi', 'Common Area', 'Kitchen', 'Laundry'],
        'location': 'Pink City, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Budget-friendly hostel with modern amenities and social atmosphere.',
        'budget_level': 'budget',
      },
      {
        'name': 'Suryagarh Resort',
        'type': 'Resort',
        'cost_per_night': 12000,
        'rating': 4.7,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'Garden', 'Cultural Activities'],
        'location': 'Sam Sand Dunes',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Luxury desert resort offering unique experiences in the Thar Desert.',
        'budget_level': 'luxury',
      },
      {
        'name': 'Hotel Pearl Palace',
        'type': 'Boutique Hotel',
        'cost_per_night': 4500,
        'rating': 4.4,
        'amenities': ['Restaurant', 'WiFi', 'Roof Terrace', 'Cultural Programs'],
        'location': 'Hawa Mahal Road, Jaipur',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Charming boutique hotel with traditional Rajasthani architecture.',
        'budget_level': 'mid_range',
      },
    ];

    final filteredAccommodations = allAccommodations.where((accommodation) {
      return _isBudgetCompatible(budgetLevel, accommodation['cost_per_night']);
    }).toList();
    
    print('Filtered accommodations count: ${filteredAccommodations.length}');
    if (filteredAccommodations.isEmpty) {
      print('No accommodations found, returning first 2 as fallback');
      return allAccommodations.take(2).toList();
    }
    return filteredAccommodations;
  }

  static List<Map<String, dynamic>> getFlights(Map<String, dynamic> preferences) {
    final budgetLevel = preferences['budget_level'] as String? ?? 'mid_range';
    final travelersCount = preferences['travelers_count'] as int? ?? 1;
    
    print('MockData.getFlights called with budget level: $budgetLevel');

    List<Map<String, dynamic>> allFlights = [
      {
        'airline': 'IndiGo',
        'from': 'Mumbai',
        'to': 'Jaipur',
        'departure_time': '08:30',
        'arrival_time': '10:15',
        'duration': '1h 45m',
        'price': 4500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'SpiceJet',
        'from': 'Delhi',
        'to': 'Jaipur',
        'departure_time': '14:20',
        'arrival_time': '15:35',
        'duration': '1h 15m',
        'price': 3800,
        'type': 'Direct',
        'aircraft': 'B737',
        'budget_level': 'budget',
      },
      {
        'airline': 'Vistara',
        'from': 'Bangalore',
        'to': 'Jaipur',
        'departure_time': '11:45',
        'arrival_time': '14:20',
        'duration': '2h 35m',
        'price': 7500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'luxury',
      },
      {
        'airline': 'Air India',
        'from': 'Chennai',
        'to': 'Jaipur',
        'departure_time': '16:30',
        'arrival_time': '19:45',
        'duration': '3h 15m',
        'price': 6200,
        'type': '1 Stop',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'GoAir',
        'from': 'Kolkata',
        'to': 'Jaipur',
        'departure_time': '09:15',
        'arrival_time': '12:30',
        'duration': '3h 15m',
        'price': 4200,
        'type': '1 Stop',
        'aircraft': 'A320',
        'budget_level': 'budget',
      },
      {
        'airline': 'Jet Airways',
        'from': 'Pune',
        'to': 'Jaipur',
        'departure_time': '13:00',
        'arrival_time': '15:45',
        'duration': '2h 45m',
        'price': 5800,
        'type': 'Direct',
        'aircraft': 'B737',
        'budget_level': 'mid_range',
      },
    ];

    final filteredFlights = allFlights.where((flight) {
      return _isBudgetCompatible(budgetLevel, flight['price']);
    }).toList();
    
    print('Filtered flights count: ${filteredFlights.length}');
    if (filteredFlights.isEmpty) {
      print('No flights found, returning first 2 as fallback');
      return allFlights.take(2).toList();
    }
    return filteredFlights;
  }

  static List<Map<String, dynamic>> getRestaurants(Map<String, dynamic> preferences) {
    final themes = preferences['themes'] as List<String>? ?? [];
    final budgetLevel = preferences['budget_level'] as String? ?? 'mid_range';
    final interests = preferences['interests'] as List<String>? ?? [];
    
    print('MockData.getRestaurants called with themes: $themes');

    List<Map<String, dynamic>> allRestaurants = [
      {
        'name': 'Suvarna Mahal',
        'cuisine': 'Rajasthani',
        'price_range': '₹₹₹',
        'rating': 4.8,
        'location': 'Rambagh Palace, Jaipur',
        'specialties': ['Dal Baati Churma', 'Laal Maas', 'Gatte Ki Sabzi'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Fine dining restaurant serving authentic Rajasthani cuisine in a royal setting.',
        'budget_level': 'luxury',
        'themes': ['Food', 'Cultural', 'Heritage'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Laxmi Misthan Bhandar',
        'cuisine': 'North Indian',
        'price_range': '₹₹',
        'rating': 4.5,
        'location': 'Johari Bazaar, Jaipur',
        'specialties': ['Pyaz Kachori', 'Mawa Kachori', 'Rasgulla'],
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'description': 'Legendary sweet shop and restaurant famous for traditional Rajasthani sweets and snacks.',
        'budget_level': 'budget',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine', 'Markets'],
      },
      {
        'name': 'Spice Court',
        'cuisine': 'Multi-cuisine',
        'price_range': '₹₹₹',
        'rating': 4.4,
        'location': 'C-Scheme, Jaipur',
        'specialties': ['Butter Chicken', 'Biryani', 'Tandoori Platter'],
        'image_url': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
        'description': 'Modern restaurant offering a mix of North Indian and international cuisine.',
        'budget_level': 'mid_range',
        'themes': ['Food'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Peacock Rooftop Restaurant',
        'cuisine': 'Rajasthani',
        'price_range': '₹₹',
        'rating': 4.3,
        'location': 'Hawa Mahal Road, Jaipur',
        'specialties': ['Thali', 'Dal Baati', 'Ker Sangri'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Rooftop restaurant with stunning views of Hawa Mahal serving traditional Rajasthani thali.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Tapri Central',
        'cuisine': 'Fusion',
        'price_range': '₹₹',
        'rating': 4.2,
        'location': 'C-Scheme, Jaipur',
        'specialties': ['Chai', 'Snacks', 'Fusion Food'],
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'description': 'Trendy café offering innovative fusion dishes and excellent chai.',
        'budget_level': 'budget',
        'themes': ['Food', 'Nightlife'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Rawat Misthan Bhandar',
        'cuisine': 'Rajasthani',
        'price_range': '₹',
        'rating': 4.6,
        'location': 'Sindhi Camp, Jaipur',
        'specialties': ['Pyaz Kachori', 'Samosa', 'Jalebi'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Famous street food destination known for the best pyaz kachori in Jaipur.',
        'budget_level': 'budget',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine', 'Markets'],
      },
    ];

    final filteredRestaurants = allRestaurants.where((restaurant) {
      final restaurantThemes = restaurant['themes'] as List<String>;
      final restaurantInterests = restaurant['interests'] as List<String>;
      
      final themeMatch = themes.isEmpty || 
          themes.any((theme) => restaurantThemes.any((restaurantTheme) => 
              restaurantTheme.toLowerCase().contains(theme.toLowerCase())));
      
      final interestMatch = interests.isEmpty ||
          interests.any((interest) => restaurantInterests.any((restaurantInterest) =>
              restaurantInterest.toLowerCase().contains(interest.toLowerCase())));
      
      return themeMatch && interestMatch;
    }).toList();
    
    print('Filtered restaurants count: ${filteredRestaurants.length}');
    if (filteredRestaurants.isEmpty) {
      print('No restaurants found, returning first 3 as fallback');
      return allRestaurants.take(3).toList();
    }
    return filteredRestaurants;
  }

  static bool _isBudgetCompatible(String budgetLevel, int cost) {
    switch (budgetLevel) {
      case 'budget':
        return cost <= 1000;
      case 'mid_range':
        return cost <= 5000;
      case 'luxury':
        return true; // Luxury accepts all prices
      default:
        return cost <= 2000;
    }
  }
}
