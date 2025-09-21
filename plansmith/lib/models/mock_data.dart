import 'dart:math';

class MockData {
  static final Random _random = Random();

  // Major cities and destinations
  static const List<String> majorCities = [
    'Mumbai', 'Delhi', 'Bangalore', 'Chennai', 'Kolkata', 'Hyderabad', 'Pune', 'Ahmedabad',
    'Jaipur', 'Lucknow', 'Kanpur', 'Nagpur', 'Indore', 'Thane', 'Bhopal', 'Visakhapatnam',
    'Pimpri-Chinchwad', 'Patna', 'Vadodara', 'Ghaziabad', 'Ludhiana', 'Agra', 'Nashik',
    'Faridabad', 'Meerut', 'Rajkot', 'Kalyan-Dombivali', 'Vasai-Virar', 'Varanasi', 'Srinagar',
    'Aurangabad', 'Navi Mumbai', 'Solapur', 'Vijayawada', 'Kolhapur', 'Amritsar', 'Noida',
    'Ranchi', 'Howrah', 'Coimbatore', 'Raipur', 'Jabalpur', 'Gwalior', 'Chandigarh',
    'Tiruchirappalli', 'Mysore', 'Mangalore', 'Kochi', 'Thiruvananthapuram', 'Kozhikode',
    'Thrissur', 'Kollam', 'Palakkad', 'Malappuram', 'Kannur', 'Kasaragod', 'Pathanamthitta',
    'Alappuzha', 'Idukki', 'Wayanad', 'Kottayam', 'Ernakulam', 'Kannur', 'Kozhikode'
  ];
  
  static const List<String> internationalDestinations = [
    'Dubai', 'Singapore', 'Bangkok', 'London', 'New York', 'Paris', 'Tokyo', 'Sydney',
    'Toronto', 'Amsterdam', 'Rome', 'Barcelona', 'Istanbul', 'Cairo', 'Cape Town',
    'Nairobi', 'Moscow', 'Beijing', 'Shanghai', 'Hong Kong', 'Seoul', 'Kuala Lumpur',
    'Jakarta', 'Manila', 'Ho Chi Minh City', 'Hanoi', 'Phnom Penh', 'Vientiane',
    'Yangon', 'Kathmandu', 'Dhaka', 'Colombo', 'Male', 'Karachi', 'Lahore', 'Islamabad'
  ];
  
  static const List<String> airlines = [
    'Air India', 'IndiGo', 'SpiceJet', 'Vistara', 'GoAir', 'AirAsia India', 'TruJet',
    'Alliance Air', 'Emirates', 'Singapore Airlines', 'Thai Airways', 'British Airways',
    'Lufthansa', 'Air France', 'KLM', 'Qatar Airways', 'Etihad Airways', 'Turkish Airlines',
    'Cathay Pacific', 'Japan Airlines', 'Korean Air', 'Malaysia Airlines', 'Thai Airways'
  ];

  static List<Map<String, dynamic>> getActivities(Map<String, dynamic> preferences) {
    final themes = preferences['themes'] as List<String>? ?? [];
    final budgetLevel = preferences['budget_level'] as String? ?? 'mid_range';
    final interests = preferences['interests'] as List<String>? ?? [];
    final destination = preferences['destination'] as String? ?? 'Jaipur';
    
    print('MockData.getActivities called with:');
    print('Themes: $themes');
    print('Budget Level: $budgetLevel');
    print('Interests: $interests');
    print('Destination: $destination');

    List<Map<String, dynamic>> allActivities = _getAllActivities();
    
    // Filter by destination first
    final destinationActivities = allActivities.where((activity) {
      final activityLocation = activity['location'] as String;
      return activityLocation.toLowerCase().contains(destination.toLowerCase()) ||
             destination.toLowerCase().contains(activityLocation.toLowerCase().split(',')[0]);
    }).toList();
    
    // If no activities found for destination, return general activities
    final activitiesToFilter = destinationActivities.isNotEmpty ? destinationActivities : allActivities;

    // Filter activities based on preferences
    final filteredActivities = activitiesToFilter.where((activity) {
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
      return activitiesToFilter.take(3).toList();
    }
    
    return filteredActivities;
  }

  static List<Map<String, dynamic>> _getAllActivities() {
    return [
      // Mumbai Activities
      {
        'name': 'Gateway of India & Elephanta Caves',
        'description': 'Visit the iconic Gateway of India and take a ferry to explore the ancient Elephanta Caves with their stunning rock-cut temples.',
        'category': 'Heritage',
        'duration_hours': 4.0,
        'cost_per_person': 1200,
        'rating': 4.6,
        'location': 'Mumbai, Maharashtra',
        'image_url': 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Temples', 'Museums'],
      },
      {
        'name': 'Bollywood Studio Tour',
        'description': 'Experience the magic of Bollywood with a behind-the-scenes tour of film studios and meet industry professionals.',
        'category': 'Entertainment',
        'duration_hours': 3.0,
        'cost_per_person': 2000,
        'rating': 4.7,
        'location': 'Mumbai, Maharashtra',
        'image_url': 'https://images.unsplash.com/photo-1489599808417-2b8b4a2b5b5b?w=400&h=300&fit=crop',
        'themes': ['Entertainment', 'Cultural'],
        'interests': ['Art Galleries', 'Photography'],
      },
      {
        'name': 'Marine Drive Sunset Walk',
        'description': 'Take a leisurely walk along the Queen\'s Necklace (Marine Drive) during sunset for breathtaking views of the Arabian Sea.',
        'category': 'Nature',
        'duration_hours': 1.5,
        'cost_per_person': 0,
        'rating': 4.8,
        'location': 'Mumbai, Maharashtra',
        'image_url': 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=400&h=300&fit=crop',
        'themes': ['Nature', 'Relaxation'],
        'interests': ['Photography'],
      },

      // Delhi Activities
      {
        'name': 'Red Fort & Jama Masjid Tour',
        'description': 'Explore the magnificent Red Fort and visit the largest mosque in India, Jama Masjid, with a knowledgeable guide.',
        'category': 'Heritage',
        'duration_hours': 3.5,
        'cost_per_person': 800,
        'rating': 4.5,
        'location': 'Delhi, Delhi',
        'image_url': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Temples', 'Museums'],
      },
      {
        'name': 'Old Delhi Food Walk',
        'description': 'Embark on a culinary journey through the narrow lanes of Old Delhi, sampling authentic street food and local delicacies.',
        'category': 'Food',
        'duration_hours': 2.5,
        'cost_per_person': 800,
        'rating': 4.8,
        'location': 'Delhi, Delhi',
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine', 'Markets'],
      },
      {
        'name': 'Qutub Minar & Humayun\'s Tomb',
        'description': 'Visit two UNESCO World Heritage sites - the iconic Qutub Minar and the beautiful Humayun\'s Tomb.',
        'category': 'Heritage',
        'duration_hours': 2.0,
        'cost_per_person': 600,
        'rating': 4.6,
        'location': 'Delhi, Delhi',
        'image_url': 'https://images.unsplash.com/photo-1594736797933-d0c1b6b7b5e5?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Museums'],
      },

      // Bangalore Activities
      {
        'name': 'Cubbon Park & Lalbagh Garden',
        'description': 'Explore Bangalore\'s green spaces - Cubbon Park and the famous Lalbagh Botanical Garden with its glass house.',
        'category': 'Nature',
        'duration_hours': 3.0,
        'cost_per_person': 200,
        'rating': 4.4,
        'location': 'Bangalore, Karnataka',
        'image_url': 'https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=400&h=300&fit=crop',
        'themes': ['Nature', 'Relaxation'],
        'interests': ['Photography'],
      },
      {
        'name': 'Tech Park & Startup Tour',
        'description': 'Visit India\'s Silicon Valley with a tour of major tech parks and startup incubators.',
        'category': 'Business',
        'duration_hours': 2.5,
        'cost_per_person': 1500,
        'rating': 4.3,
        'location': 'Bangalore, Karnataka',
        'image_url': 'https://images.unsplash.com/photo-1489599808417-2b8b4a2b5b5b?w=400&h=300&fit=crop',
        'themes': ['Business', 'Technology'],
        'interests': ['Art Galleries'],
      },
      {
        'name': 'Tipu Sultan\'s Summer Palace',
        'description': 'Explore the beautiful summer palace of Tipu Sultan, known for its intricate architecture and historical significance.',
        'category': 'Heritage',
        'duration_hours': 1.5,
        'cost_per_person': 300,
        'rating': 4.2,
        'location': 'Bangalore, Karnataka',
        'image_url': 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Museums'],
      },

      // Chennai Activities
      {
        'name': 'Marina Beach & Fort St. George',
        'description': 'Visit the second longest beach in the world and explore the historic Fort St. George, the first British fortress in India.',
        'category': 'Heritage',
        'duration_hours': 3.0,
        'cost_per_person': 400,
        'rating': 4.3,
        'location': 'Chennai, Tamil Nadu',
        'image_url': 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Nature'],
        'interests': ['Museums', 'Photography'],
      },
      {
        'name': 'Kapaleeshwarar Temple & Mylapore',
        'description': 'Explore the beautiful Kapaleeshwarar Temple and the traditional neighborhood of Mylapore.',
        'category': 'Cultural',
        'duration_hours': 2.0,
        'cost_per_person': 200,
        'rating': 4.4,
        'location': 'Chennai, Tamil Nadu',
        'image_url': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400&h=300&fit=crop',
        'themes': ['Cultural', 'Heritage'],
        'interests': ['Temples'],
      },

      // Kolkata Activities
      {
        'name': 'Victoria Memorial & Howrah Bridge',
        'description': 'Visit the iconic Victoria Memorial and walk across the famous Howrah Bridge over the Hooghly River.',
        'category': 'Heritage',
        'duration_hours': 3.5,
        'cost_per_person': 500,
        'rating': 4.5,
        'location': 'Kolkata, West Bengal',
        'image_url': 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Museums', 'Photography'],
      },
      {
        'name': 'Kumartuli Pottery Workshop',
        'description': 'Learn traditional Bengali pottery techniques in the famous Kumartuli neighborhood where Durga idols are made.',
        'category': 'Cultural',
        'duration_hours': 2.5,
        'cost_per_person': 800,
        'rating': 4.6,
        'location': 'Kolkata, West Bengal',
        'image_url': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400&h=300&fit=crop',
        'themes': ['Cultural', 'Art'],
        'interests': ['Art Galleries'],
      },

      // Hyderabad Activities
      {
        'name': 'Charminar & Chowmahalla Palace',
        'description': 'Visit the iconic Charminar and explore the magnificent Chowmahalla Palace, the seat of the Nizams.',
        'category': 'Heritage',
        'duration_hours': 3.0,
        'cost_per_person': 600,
        'rating': 4.6,
        'location': 'Hyderabad, Telangana',
        'image_url': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Museums', 'Temples'],
      },
      {
        'name': 'Golconda Fort Sound & Light Show',
        'description': 'Experience the spectacular sound and light show at the historic Golconda Fort, showcasing its rich history.',
        'category': 'Entertainment',
        'duration_hours': 1.5,
        'cost_per_person': 400,
        'rating': 4.7,
        'location': 'Hyderabad, Telangana',
        'image_url': 'https://images.unsplash.com/photo-1489599808417-2b8b4a2b5b5b?w=400&h=300&fit=crop',
        'themes': ['Entertainment', 'Heritage'],
        'interests': ['Museums'],
      },

      // Goa Activities
      {
        'name': 'Beach Hopping & Water Sports',
        'description': 'Explore multiple beaches in Goa and enjoy various water sports including parasailing, jet skiing, and banana boat rides.',
        'category': 'Adventure',
        'duration_hours': 6.0,
        'cost_per_person': 2500,
        'rating': 4.8,
        'location': 'Goa',
        'image_url': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop',
        'themes': ['Adventure', 'Nature'],
        'interests': ['Water Sports', 'Photography'],
      },
      {
        'name': 'Old Goa Churches & Spice Plantation',
        'description': 'Visit the UNESCO World Heritage churches of Old Goa and explore a traditional spice plantation.',
        'category': 'Heritage',
        'duration_hours': 4.0,
        'cost_per_person': 1200,
        'rating': 4.5,
        'location': 'Goa',
        'image_url': 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Temples', 'Museums'],
      },

      // Kerala Activities
      {
        'name': 'Backwater Houseboat Cruise',
        'description': 'Experience the serene backwaters of Kerala on a traditional houseboat with authentic local cuisine.',
        'category': 'Nature',
        'duration_hours': 8.0,
        'cost_per_person': 3000,
        'rating': 4.9,
        'location': 'Kerala',
        'image_url': 'https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=400&h=300&fit=crop',
        'themes': ['Nature', 'Relaxation'],
        'interests': ['Photography', 'Wildlife'],
      },
      {
        'name': 'Ayurvedic Wellness Retreat',
        'description': 'Rejuvenate with traditional Ayurvedic treatments and therapies in the birthplace of Ayurveda.',
        'category': 'Wellness',
        'duration_hours': 4.0,
        'cost_per_person': 2500,
        'rating': 4.7,
        'location': 'Kerala',
        'image_url': 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=400&h=300&fit=crop',
        'themes': ['Wellness', 'Relaxation'],
        'interests': ['Wellness'],
      },

      // Rajasthan Activities (Jaipur)
      {
        'name': 'Amber Fort Heritage Walk',
        'description': 'Explore the magnificent Amber Fort with a guided heritage walk through the palace complex, including the Sheesh Mahal and Diwan-e-Aam.',
        'category': 'Heritage',
        'duration_hours': 3.0,
        'cost_per_person': 800,
        'rating': 4.7,
        'location': 'Jaipur, Rajasthan',
        'image_url': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Temples', 'Museums'],
      },
      {
        'name': 'Hot Air Balloon Ride',
        'description': 'Experience Jaipur from above with a breathtaking hot air balloon ride over the Pink City at sunrise.',
        'category': 'Adventure',
        'duration_hours': 2.0,
        'cost_per_person': 2500,
        'rating': 4.9,
        'location': 'Jaipur, Rajasthan',
        'image_url': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop',
        'themes': ['Adventure', 'Nature'],
        'interests': ['Photography'],
      },

      // International Activities
      {
        'name': 'Burj Khalifa & Dubai Mall',
        'description': 'Visit the world\'s tallest building and explore the largest shopping mall in the world.',
        'category': 'Entertainment',
        'duration_hours': 4.0,
        'cost_per_person': 5000,
        'rating': 4.8,
        'location': 'Dubai, UAE',
        'image_url': 'https://images.unsplash.com/photo-1489599808417-2b8b4a2b5b5b?w=400&h=300&fit=crop',
        'themes': ['Entertainment', 'Shopping'],
        'interests': ['Markets', 'Photography'],
      },
      {
        'name': 'Eiffel Tower & Seine River Cruise',
        'description': 'Visit the iconic Eiffel Tower and enjoy a romantic Seine River cruise with stunning views of Paris.',
        'category': 'Heritage',
        'duration_hours': 4.0,
        'cost_per_person': 3500,
        'rating': 4.9,
        'location': 'Paris, France',
        'image_url': 'https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Romance'],
        'interests': ['Photography', 'Museums'],
      },
      {
        'name': 'Louvre Museum & Champs-Élysées',
        'description': 'Explore the world\'s largest art museum and stroll down the famous Champs-Élysées avenue.',
        'category': 'Cultural',
        'duration_hours': 5.0,
        'cost_per_person': 2500,
        'rating': 4.8,
        'location': 'Paris, France',
        'image_url': 'https://images.unsplash.com/photo-1549144511-f099e773c147?w=400&h=300&fit=crop',
        'themes': ['Cultural', 'Art'],
        'interests': ['Museums', 'Art Galleries'],
      },
      {
        'name': 'Notre-Dame & Montmartre Walking Tour',
        'description': 'Visit the historic Notre-Dame Cathedral and explore the artistic Montmartre district with its charming streets.',
        'category': 'Heritage',
        'duration_hours': 3.5,
        'cost_per_person': 1800,
        'rating': 4.7,
        'location': 'Paris, France',
        'image_url': 'https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Temples', 'Art Galleries'],
      },
      {
        'name': 'Versailles Palace Day Trip',
        'description': 'Take a day trip to the magnificent Palace of Versailles, the former royal residence of French kings.',
        'category': 'Heritage',
        'duration_hours': 6.0,
        'cost_per_person': 4500,
        'rating': 4.8,
        'location': 'Paris, France',
        'image_url': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop',
        'themes': ['Heritage', 'Cultural'],
        'interests': ['Museums', 'Photography'],
      },
      {
        'name': 'French Cooking Class & Market Tour',
        'description': 'Learn authentic French cooking techniques and explore local markets with a professional chef.',
        'category': 'Food',
        'duration_hours': 4.0,
        'cost_per_person': 3200,
        'rating': 4.9,
        'location': 'Paris, France',
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine', 'Markets'],
      },
      {
        'name': 'Marina Bay Sands & Gardens by the Bay',
        'description': 'Experience Singapore\'s iconic Marina Bay Sands and explore the futuristic Gardens by the Bay.',
        'category': 'Entertainment',
        'duration_hours': 3.5,
        'cost_per_person': 4000,
        'rating': 4.7,
        'location': 'Singapore',
        'image_url': 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=400&h=300&fit=crop',
        'themes': ['Entertainment', 'Nature'],
        'interests': ['Photography'],
      },
      {
        'name': 'Temple of Dawn & Floating Markets',
        'description': 'Visit the beautiful Wat Arun temple and explore Bangkok\'s famous floating markets.',
        'category': 'Cultural',
        'duration_hours': 4.0,
        'cost_per_person': 2000,
        'rating': 4.6,
        'location': 'Bangkok, Thailand',
        'image_url': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400&h=300&fit=crop',
        'themes': ['Cultural', 'Heritage'],
        'interests': ['Temples', 'Markets'],
      },
    ];
  }

  static List<Map<String, dynamic>> getAccommodations(Map<String, dynamic> preferences) {
    final budgetLevel = preferences['budget_level'] as String? ?? 'mid_range';
    final travelersCount = preferences['travelers_count'] as int? ?? 1;
    final destination = preferences['destination'] as String? ?? 'Jaipur';
    
    print('MockData.getAccommodations called with budget level: $budgetLevel, destination: $destination');

    List<Map<String, dynamic>> allAccommodations = _getAllAccommodations();
    
    // Filter by destination
    final destinationAccommodations = allAccommodations.where((accommodation) {
      final accommodationLocation = accommodation['location'] as String;
      return accommodationLocation.toLowerCase().contains(destination.toLowerCase()) ||
             destination.toLowerCase().contains(accommodationLocation.toLowerCase().split(',')[0]);
    }).toList();
    
    final accommodationsToFilter = destinationAccommodations.isNotEmpty ? destinationAccommodations : allAccommodations;

    final filteredAccommodations = accommodationsToFilter.where((accommodation) {
      return _isBudgetCompatible(budgetLevel, accommodation['cost_per_night']);
    }).toList();
    
    print('Filtered accommodations count: ${filteredAccommodations.length}');
    if (filteredAccommodations.isEmpty) {
      print('No accommodations found, returning first 3 as fallback');
      return accommodationsToFilter.take(3).toList();
    }
    return filteredAccommodations;
  }

  static List<Map<String, dynamic>> _getAllAccommodations() {
    return [
      // Mumbai Accommodations
      {
        'name': 'The Taj Mahal Palace',
        'type': 'Luxury Hotel',
        'cost_per_night': 25000,
        'rating': 4.9,
        'amenities': ['Swimming Pool', 'Spa', 'Multiple Restaurants', 'WiFi', 'Valet Parking', 'Concierge'],
        'location': 'Mumbai, Maharashtra',
        'image_url': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
        'description': 'Iconic luxury hotel overlooking the Gateway of India with world-class amenities.',
        'budget_level': 'luxury',
      },
      {
        'name': 'The Oberoi Mumbai',
        'type': 'Luxury Hotel',
        'cost_per_night': 20000,
        'rating': 4.8,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Parking', 'Business Center'],
        'location': 'Mumbai, Maharashtra',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Modern luxury hotel with stunning views of the Arabian Sea.',
        'budget_level': 'luxury',
      },
      {
        'name': 'ITC Maratha',
        'type': 'Business Hotel',
        'cost_per_night': 12000,
        'rating': 4.6,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Gym', 'Parking'],
        'location': 'Mumbai, Maharashtra',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Premium business hotel near the airport with excellent facilities.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Hotel Suba Palace',
        'type': 'Mid-range Hotel',
        'cost_per_night': 6000,
        'rating': 4.2,
        'amenities': ['Restaurant', 'WiFi', 'Parking', 'Room Service'],
        'location': 'Mumbai, Maharashtra',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Comfortable mid-range hotel in the heart of Mumbai.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Zostel Mumbai',
        'type': 'Hostel',
        'cost_per_night': 1200,
        'rating': 4.3,
        'amenities': ['WiFi', 'Common Area', 'Kitchen', 'Laundry', 'Locker'],
        'location': 'Mumbai, Maharashtra',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Budget-friendly hostel with modern amenities and social atmosphere.',
        'budget_level': 'budget',
      },

      // Delhi Accommodations
      {
        'name': 'The Leela Palace New Delhi',
        'type': 'Luxury Hotel',
        'cost_per_night': 18000,
        'rating': 4.8,
        'amenities': ['Swimming Pool', 'Spa', 'Multiple Restaurants', 'WiFi', 'Valet Parking', 'Concierge'],
        'location': 'Delhi, Delhi',
        'image_url': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
        'description': 'Luxurious palace hotel with traditional Indian architecture and modern amenities.',
        'budget_level': 'luxury',
      },
      {
        'name': 'The Imperial New Delhi',
        'type': 'Heritage Hotel',
        'cost_per_night': 15000,
        'rating': 4.7,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Parking', 'Cultural Programs'],
        'location': 'Delhi, Delhi',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Historic luxury hotel with colonial architecture and royal heritage.',
        'budget_level': 'luxury',
      },
      {
        'name': 'Hotel Taj Palace',
        'type': 'Business Hotel',
        'cost_per_night': 10000,
        'rating': 4.5,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Gym', 'Parking'],
        'location': 'Delhi, Delhi',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Modern business hotel with excellent facilities and central location.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Hotel Broadway',
        'type': 'Mid-range Hotel',
        'cost_per_night': 4500,
        'rating': 4.1,
        'amenities': ['Restaurant', 'WiFi', 'Parking', 'Room Service'],
        'location': 'Delhi, Delhi',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Comfortable mid-range hotel near major attractions.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Zostel Delhi',
        'type': 'Hostel',
        'cost_per_night': 1000,
        'rating': 4.2,
        'amenities': ['WiFi', 'Common Area', 'Kitchen', 'Laundry', 'Locker'],
        'location': 'Delhi, Delhi',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Budget-friendly hostel in the heart of Delhi.',
        'budget_level': 'budget',
      },

      // Bangalore Accommodations
      {
        'name': 'The Leela Palace Bangalore',
        'type': 'Luxury Hotel',
        'cost_per_night': 16000,
        'rating': 4.8,
        'amenities': ['Swimming Pool', 'Spa', 'Multiple Restaurants', 'WiFi', 'Valet Parking', 'Concierge'],
        'location': 'Bangalore, Karnataka',
        'image_url': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
        'description': 'Luxurious palace hotel with beautiful gardens and modern amenities.',
        'budget_level': 'luxury',
      },
      {
        'name': 'ITC Gardenia',
        'type': 'Business Hotel',
        'cost_per_night': 11000,
        'rating': 4.6,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Gym', 'Parking'],
        'location': 'Bangalore, Karnataka',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Premium business hotel with excellent facilities.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Hotel Royal Orchid',
        'type': 'Mid-range Hotel',
        'cost_per_night': 5500,
        'rating': 4.3,
        'amenities': ['Swimming Pool', 'Restaurant', 'WiFi', 'Parking', 'Gym'],
        'location': 'Bangalore, Karnataka',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Comfortable mid-range hotel with good amenities.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Zostel Bangalore',
        'type': 'Hostel',
        'cost_per_night': 900,
        'rating': 4.1,
        'amenities': ['WiFi', 'Common Area', 'Kitchen', 'Laundry', 'Locker'],
        'location': 'Bangalore, Karnataka',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Budget-friendly hostel in the tech hub of India.',
        'budget_level': 'budget',
      },

      // Chennai Accommodations
      {
        'name': 'The Leela Palace Chennai',
        'type': 'Luxury Hotel',
        'cost_per_night': 14000,
        'rating': 4.7,
        'amenities': ['Swimming Pool', 'Spa', 'Multiple Restaurants', 'WiFi', 'Valet Parking', 'Concierge'],
        'location': 'Chennai, Tamil Nadu',
        'image_url': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
        'description': 'Luxurious palace hotel with traditional South Indian architecture.',
        'budget_level': 'luxury',
      },
      {
        'name': 'ITC Grand Chola',
        'type': 'Business Hotel',
        'cost_per_night': 9500,
        'rating': 4.5,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Gym', 'Parking'],
        'location': 'Chennai, Tamil Nadu',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Premium business hotel with excellent facilities.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Hotel Savera',
        'type': 'Mid-range Hotel',
        'cost_per_night': 4000,
        'rating': 4.0,
        'amenities': ['Restaurant', 'WiFi', 'Parking', 'Room Service'],
        'location': 'Chennai, Tamil Nadu',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Comfortable mid-range hotel in Chennai.',
        'budget_level': 'mid_range',
      },

      // Kolkata Accommodations
      {
        'name': 'The Oberoi Grand Kolkata',
        'type': 'Luxury Hotel',
        'cost_per_night': 12000,
        'rating': 4.6,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Valet Parking', 'Concierge'],
        'location': 'Kolkata, West Bengal',
        'image_url': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
        'description': 'Historic luxury hotel with colonial charm and modern amenities.',
        'budget_level': 'luxury',
      },
      {
        'name': 'ITC Royal Bengal',
        'type': 'Business Hotel',
        'cost_per_night': 8500,
        'rating': 4.4,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Gym', 'Parking'],
        'location': 'Kolkata, West Bengal',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Premium business hotel with excellent facilities.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Hotel Hindustan International',
        'type': 'Mid-range Hotel',
        'cost_per_night': 3500,
        'rating': 4.0,
        'amenities': ['Restaurant', 'WiFi', 'Parking', 'Room Service'],
        'location': 'Kolkata, West Bengal',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Comfortable mid-range hotel in Kolkata.',
        'budget_level': 'mid_range',
      },

      // Hyderabad Accommodations
      {
        'name': 'Taj Falaknuma Palace',
        'type': 'Luxury Hotel',
        'cost_per_night': 30000,
        'rating': 4.9,
        'amenities': ['Swimming Pool', 'Spa', 'Multiple Restaurants', 'WiFi', 'Valet Parking', 'Concierge', 'Cultural Programs'],
        'location': 'Hyderabad, Telangana',
        'image_url': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
        'description': 'Former palace of the Nizam of Hyderabad, now a luxury hotel with royal heritage.',
        'budget_level': 'luxury',
      },
      {
        'name': 'ITC Kakatiya',
        'type': 'Business Hotel',
        'cost_per_night': 9000,
        'rating': 4.5,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Gym', 'Parking'],
        'location': 'Hyderabad, Telangana',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Premium business hotel with excellent facilities.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Hotel Minerva Grand',
        'type': 'Mid-range Hotel',
        'cost_per_night': 4500,
        'rating': 4.1,
        'amenities': ['Restaurant', 'WiFi', 'Parking', 'Room Service'],
        'location': 'Hyderabad, Telangana',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Comfortable mid-range hotel in Hyderabad.',
        'budget_level': 'mid_range',
      },

      // Goa Accommodations
      {
        'name': 'Taj Exotica Resort & Spa',
        'type': 'Luxury Resort',
        'cost_per_night': 18000,
        'rating': 4.8,
        'amenities': ['Swimming Pool', 'Spa', 'Multiple Restaurants', 'WiFi', 'Beach Access', 'Water Sports'],
        'location': 'Goa',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Luxury beachfront resort with stunning views and world-class amenities.',
        'budget_level': 'luxury',
      },
      {
        'name': 'The Leela Goa',
        'type': 'Luxury Resort',
        'cost_per_night': 15000,
        'rating': 4.7,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Beach Access', 'Golf Course'],
        'location': 'Goa',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Luxury resort with beach access and golf course.',
        'budget_level': 'luxury',
      },
      {
        'name': 'Hotel Calangute Beach Resort',
        'type': 'Mid-range Resort',
        'cost_per_night': 6000,
        'rating': 4.3,
        'amenities': ['Swimming Pool', 'Restaurant', 'WiFi', 'Beach Access', 'Water Sports'],
        'location': 'Goa',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Beachfront resort with good amenities and beach access.',
        'budget_level': 'mid_range',
      },
      {
        'name': 'Zostel Goa',
        'type': 'Hostel',
        'cost_per_night': 800,
        'rating': 4.4,
        'amenities': ['WiFi', 'Common Area', 'Kitchen', 'Laundry', 'Beach Access'],
        'location': 'Goa',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Budget-friendly hostel near the beach.',
        'budget_level': 'budget',
      },

      // Kerala Accommodations
      {
        'name': 'Taj Malabar Resort & Spa',
        'type': 'Luxury Resort',
        'cost_per_night': 20000,
        'rating': 4.8,
        'amenities': ['Swimming Pool', 'Spa', 'Multiple Restaurants', 'WiFi', 'Backwater Access', 'Ayurvedic Treatments'],
        'location': 'Kerala',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Luxury resort with backwater access and traditional Ayurvedic treatments.',
        'budget_level': 'luxury',
      },
      {
        'name': 'Kumarakom Lake Resort',
        'type': 'Luxury Resort',
        'cost_per_night': 16000,
        'rating': 4.7,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Backwater Access', 'Cultural Programs'],
        'location': 'Kerala',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Luxury backwater resort with traditional Kerala architecture.',
        'budget_level': 'luxury',
      },
      {
        'name': 'Coconut Lagoon',
        'type': 'Mid-range Resort',
        'cost_per_night': 8000,
        'rating': 4.5,
        'amenities': ['Swimming Pool', 'Restaurant', 'WiFi', 'Backwater Access', 'Cultural Programs'],
        'location': 'Kerala',
        'image_url': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop',
        'description': 'Mid-range backwater resort with traditional charm.',
        'budget_level': 'mid_range',
      },

      // Rajasthan Accommodations (Jaipur)
      {
        'name': 'The Raj Palace',
        'type': 'Luxury Hotel',
        'cost_per_night': 15000,
        'rating': 4.8,
        'amenities': ['Swimming Pool', 'Spa', 'Restaurant', 'WiFi', 'Parking', 'Cultural Programs'],
        'location': 'Jaipur, Rajasthan',
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
        'location': 'Jaipur, Rajasthan',
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
        'location': 'Jaipur, Rajasthan',
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
        'location': 'Jaipur, Rajasthan',
        'image_url': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400&h=300&fit=crop',
        'description': 'Budget-friendly hostel with modern amenities and social atmosphere.',
        'budget_level': 'budget',
      },

      // International Accommodations
      {
        'name': 'Burj Al Arab',
        'type': 'Luxury Hotel',
        'cost_per_night': 50000,
        'rating': 4.9,
        'amenities': ['Swimming Pool', 'Spa', 'Multiple Restaurants', 'WiFi', 'Valet Parking', 'Concierge', 'Helipad'],
        'location': 'Dubai, UAE',
        'image_url': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
        'description': 'Iconic luxury hotel shaped like a sail with world-class amenities.',
        'budget_level': 'luxury',
      },
      {
        'name': 'Marina Bay Sands',
        'type': 'Luxury Hotel',
        'cost_per_night': 40000,
        'rating': 4.8,
        'amenities': ['Swimming Pool', 'Spa', 'Multiple Restaurants', 'WiFi', 'Valet Parking', 'Concierge', 'Casino'],
        'location': 'Singapore',
        'image_url': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
        'description': 'Iconic luxury hotel with the famous infinity pool and stunning city views.',
        'budget_level': 'luxury',
      },
      {
        'name': 'Mandarin Oriental Bangkok',
        'type': 'Luxury Hotel',
        'cost_per_night': 25000,
        'rating': 4.7,
        'amenities': ['Swimming Pool', 'Spa', 'Multiple Restaurants', 'WiFi', 'Valet Parking', 'Concierge'],
        'location': 'Bangkok, Thailand',
        'image_url': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
        'description': 'Luxury hotel with traditional Thai hospitality and modern amenities.',
        'budget_level': 'luxury',
      },
    ];
  }

  static List<Map<String, dynamic>> getFlights(Map<String, dynamic> preferences) {
    final budgetLevel = preferences['budget_level'] as String? ?? 'mid_range';
    final travelersCount = preferences['travelers_count'] as int? ?? 1;
    final fromCity = preferences['from_city'] as String? ?? 'Mumbai';
    final toCity = preferences['to_city'] as String? ?? 'Jaipur';
    
    print('MockData.getFlights called with budget level: $budgetLevel, from: $fromCity, to: $toCity');

    List<Map<String, dynamic>> allFlights = _getAllFlights();
    
    // Filter by route
    final routeFlights = allFlights.where((flight) {
      final flightFrom = flight['from'] as String;
      final flightTo = flight['to'] as String;
      return (flightFrom.toLowerCase().contains(fromCity.toLowerCase()) || 
              fromCity.toLowerCase().contains(flightFrom.toLowerCase())) &&
             (flightTo.toLowerCase().contains(toCity.toLowerCase()) || 
              toCity.toLowerCase().contains(flightTo.toLowerCase()));
    }).toList();
    
    // If no direct flights, try reverse route
    if (routeFlights.isEmpty) {
      final reverseFlights = allFlights.where((flight) {
        final flightFrom = flight['from'] as String;
        final flightTo = flight['to'] as String;
        return (flightFrom.toLowerCase().contains(toCity.toLowerCase()) || 
                toCity.toLowerCase().contains(flightFrom.toLowerCase())) &&
               (flightTo.toLowerCase().contains(fromCity.toLowerCase()) || 
                fromCity.toLowerCase().contains(flightTo.toLowerCase()));
      }).toList();
      
      if (reverseFlights.isNotEmpty) {
        // Swap from/to for reverse flights
        final adjustedFlights = reverseFlights.map((flight) {
          final newFlight = Map<String, dynamic>.from(flight);
          newFlight['from'] = flight['to'];
          newFlight['to'] = flight['from'];
          return newFlight;
        }).toList();
        return _filterFlightsByBudget(adjustedFlights, budgetLevel);
      }
    }
    
    final flightsToFilter = routeFlights.isNotEmpty ? routeFlights : allFlights;
    return _filterFlightsByBudget(flightsToFilter, budgetLevel);
  }

  static List<Map<String, dynamic>> _filterFlightsByBudget(List<Map<String, dynamic>> flights, String budgetLevel) {
    final filteredFlights = flights.where((flight) {
      return _isBudgetCompatible(budgetLevel, flight['price']);
    }).toList();
    
    print('Filtered flights count: ${filteredFlights.length}');
    if (filteredFlights.isEmpty) {
      print('No flights found, returning first 3 as fallback');
      return flights.take(3).toList();
    }
    return filteredFlights;
  }

  static List<Map<String, dynamic>> _getAllFlights() {
    return [
      // Domestic Flights - Mumbai Routes
      {
        'airline': 'IndiGo',
        'from': 'Mumbai',
        'to': 'Delhi',
        'departure_time': '08:30',
        'arrival_time': '10:15',
        'duration': '1h 45m',
        'price': 4500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Air India',
        'from': 'Mumbai',
        'to': 'Delhi',
        'departure_time': '14:20',
        'arrival_time': '16:05',
        'duration': '1h 45m',
        'price': 5200,
        'type': 'Direct',
        'aircraft': 'B787',
        'budget_level': 'luxury',
      },
      {
        'airline': 'SpiceJet',
        'from': 'Mumbai',
        'to': 'Delhi',
        'departure_time': '19:45',
        'arrival_time': '21:30',
        'duration': '1h 45m',
        'price': 3800,
        'type': 'Direct',
        'aircraft': 'B737',
        'budget_level': 'budget',
      },
      {
        'airline': 'Vistara',
        'from': 'Mumbai',
        'to': 'Bangalore',
        'departure_time': '11:45',
        'arrival_time': '13:20',
        'duration': '1h 35m',
        'price': 6500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'luxury',
      },
      {
        'airline': 'IndiGo',
        'from': 'Mumbai',
        'to': 'Bangalore',
        'departure_time': '16:30',
        'arrival_time': '18:15',
        'duration': '1h 45m',
        'price': 4200,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'GoAir',
        'from': 'Mumbai',
        'to': 'Chennai',
        'departure_time': '09:15',
        'arrival_time': '11:00',
        'duration': '1h 45m',
        'price': 3800,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'budget',
      },
      {
        'airline': 'IndiGo',
        'from': 'Mumbai',
        'to': 'Chennai',
        'departure_time': '13:00',
        'arrival_time': '14:45',
        'duration': '1h 45m',
        'price': 4500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'SpiceJet',
        'from': 'Mumbai',
        'to': 'Kolkata',
        'departure_time': '07:30',
        'arrival_time': '10:15',
        'duration': '2h 45m',
        'price': 4200,
        'type': 'Direct',
        'aircraft': 'B737',
        'budget_level': 'budget',
      },
      {
        'airline': 'Air India',
        'from': 'Mumbai',
        'to': 'Kolkata',
        'departure_time': '15:45',
        'arrival_time': '18:30',
        'duration': '2h 45m',
        'price': 5800,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'IndiGo',
        'from': 'Mumbai',
        'to': 'Hyderabad',
        'departure_time': '10:20',
        'arrival_time': '11:50',
        'duration': '1h 30m',
        'price': 3800,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'budget',
      },
      {
        'airline': 'Vistara',
        'from': 'Mumbai',
        'to': 'Hyderabad',
        'departure_time': '17:15',
        'arrival_time': '18:45',
        'duration': '1h 30m',
        'price': 5500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'luxury',
      },
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
        'from': 'Mumbai',
        'to': 'Jaipur',
        'departure_time': '14:20',
        'arrival_time': '16:05',
        'duration': '1h 45m',
        'price': 3800,
        'type': 'Direct',
        'aircraft': 'B737',
        'budget_level': 'budget',
      },

      // Delhi Routes
      {
        'airline': 'IndiGo',
        'from': 'Delhi',
        'to': 'Mumbai',
        'departure_time': '06:30',
        'arrival_time': '08:15',
        'duration': '1h 45m',
        'price': 4500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Air India',
        'from': 'Delhi',
        'to': 'Mumbai',
        'departure_time': '12:45',
        'arrival_time': '14:30',
        'duration': '1h 45m',
        'price': 5200,
        'type': 'Direct',
        'aircraft': 'B787',
        'budget_level': 'luxury',
      },
      {
        'airline': 'SpiceJet',
        'from': 'Delhi',
        'to': 'Mumbai',
        'departure_time': '18:20',
        'arrival_time': '20:05',
        'duration': '1h 45m',
        'price': 3800,
        'type': 'Direct',
        'aircraft': 'B737',
        'budget_level': 'budget',
      },
      {
        'airline': 'IndiGo',
        'from': 'Delhi',
        'to': 'Bangalore',
        'departure_time': '09:15',
        'arrival_time': '11:30',
        'duration': '2h 15m',
        'price': 4800,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Vistara',
        'from': 'Delhi',
        'to': 'Bangalore',
        'departure_time': '15:30',
        'arrival_time': '17:45',
        'duration': '2h 15m',
        'price': 6800,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'luxury',
      },
      {
        'airline': 'IndiGo',
        'from': 'Delhi',
        'to': 'Chennai',
        'departure_time': '08:45',
        'arrival_time': '11:00',
        'duration': '2h 15m',
        'price': 4500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Air India',
        'from': 'Delhi',
        'to': 'Chennai',
        'departure_time': '14:15',
        'arrival_time': '16:30',
        'duration': '2h 15m',
        'price': 5800,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'SpiceJet',
        'from': 'Delhi',
        'to': 'Kolkata',
        'departure_time': '10:30',
        'arrival_time': '12:45',
        'duration': '2h 15m',
        'price': 4200,
        'type': 'Direct',
        'aircraft': 'B737',
        'budget_level': 'budget',
      },
      {
        'airline': 'IndiGo',
        'from': 'Delhi',
        'to': 'Kolkata',
        'departure_time': '16:45',
        'arrival_time': '19:00',
        'duration': '2h 15m',
        'price': 4500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'IndiGo',
        'from': 'Delhi',
        'to': 'Hyderabad',
        'departure_time': '11:20',
        'arrival_time': '13:10',
        'duration': '1h 50m',
        'price': 4200,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Vistara',
        'from': 'Delhi',
        'to': 'Hyderabad',
        'departure_time': '17:30',
        'arrival_time': '19:20',
        'duration': '1h 50m',
        'price': 6200,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'luxury',
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
        'airline': 'IndiGo',
        'from': 'Delhi',
        'to': 'Jaipur',
        'departure_time': '19:45',
        'arrival_time': '21:00',
        'duration': '1h 15m',
        'price': 4200,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },

      // Bangalore Routes
      {
        'airline': 'IndiGo',
        'from': 'Bangalore',
        'to': 'Mumbai',
        'departure_time': '07:30',
        'arrival_time': '09:15',
        'duration': '1h 45m',
        'price': 4200,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Vistara',
        'from': 'Bangalore',
        'to': 'Mumbai',
        'departure_time': '13:45',
        'arrival_time': '15:30',
        'duration': '1h 45m',
        'price': 6500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'luxury',
      },
      {
        'airline': 'IndiGo',
        'from': 'Bangalore',
        'to': 'Delhi',
        'departure_time': '08:15',
        'arrival_time': '10:30',
        'duration': '2h 15m',
        'price': 4800,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Air India',
        'from': 'Bangalore',
        'to': 'Delhi',
        'departure_time': '15:00',
        'arrival_time': '17:15',
        'duration': '2h 15m',
        'price': 5800,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'IndiGo',
        'from': 'Bangalore',
        'to': 'Chennai',
        'departure_time': '09:30',
        'arrival_time': '10:30',
        'duration': '1h 00m',
        'price': 2800,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'budget',
      },
      {
        'airline': 'SpiceJet',
        'from': 'Bangalore',
        'to': 'Chennai',
        'departure_time': '16:45',
        'arrival_time': '17:45',
        'duration': '1h 00m',
        'price': 2500,
        'type': 'Direct',
        'aircraft': 'B737',
        'budget_level': 'budget',
      },
      {
        'airline': 'IndiGo',
        'from': 'Bangalore',
        'to': 'Kolkata',
        'departure_time': '10:15',
        'arrival_time': '12:45',
        'duration': '2h 30m',
        'price': 4500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Air India',
        'from': 'Bangalore',
        'to': 'Kolkata',
        'departure_time': '17:30',
        'arrival_time': '20:00',
        'duration': '2h 30m',
        'price': 5800,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'IndiGo',
        'from': 'Bangalore',
        'to': 'Hyderabad',
        'departure_time': '08:45',
        'arrival_time': '09:45',
        'duration': '1h 00m',
        'price': 2800,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'budget',
      },
      {
        'airline': 'Vistara',
        'from': 'Bangalore',
        'to': 'Hyderabad',
        'departure_time': '14:30',
        'arrival_time': '15:30',
        'duration': '1h 00m',
        'price': 4500,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'IndiGo',
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

      // International Routes
      {
        'airline': 'Emirates',
        'from': 'Mumbai',
        'to': 'Dubai',
        'departure_time': '02:30',
        'arrival_time': '04:45',
        'duration': '3h 15m',
        'price': 25000,
        'type': 'Direct',
        'aircraft': 'B777',
        'budget_level': 'luxury',
      },
      {
        'airline': 'Air India',
        'from': 'Mumbai',
        'to': 'Dubai',
        'departure_time': '14:20',
        'arrival_time': '16:35',
        'duration': '3h 15m',
        'price': 18000,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Singapore Airlines',
        'from': 'Mumbai',
        'to': 'Singapore',
        'departure_time': '01:45',
        'arrival_time': '09:30',
        'duration': '5h 45m',
        'price': 35000,
        'type': 'Direct',
        'aircraft': 'A350',
        'budget_level': 'luxury',
      },
      {
        'airline': 'Air India',
        'from': 'Mumbai',
        'to': 'Singapore',
        'departure_time': '16:30',
        'arrival_time': '23:45',
        'duration': '5h 15m',
        'price': 25000,
        'type': 'Direct',
        'aircraft': 'B787',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Thai Airways',
        'from': 'Mumbai',
        'to': 'Bangkok',
        'departure_time': '03:15',
        'arrival_time': '08:30',
        'duration': '4h 15m',
        'price': 22000,
        'type': 'Direct',
        'aircraft': 'A350',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'IndiGo',
        'from': 'Mumbai',
        'to': 'Bangkok',
        'departure_time': '12:45',
        'arrival_time': '18:00',
        'duration': '4h 15m',
        'price': 18000,
        'type': 'Direct',
        'aircraft': 'A320',
        'budget_level': 'budget',
      },
      {
        'airline': 'British Airways',
        'from': 'Mumbai',
        'to': 'London',
        'departure_time': '02:30',
        'arrival_time': '07:45',
        'duration': '9h 15m',
        'price': 65000,
        'type': 'Direct',
        'aircraft': 'B777',
        'budget_level': 'luxury',
      },
      {
        'airline': 'Air India',
        'from': 'Mumbai',
        'to': 'London',
        'departure_time': '15:45',
        'arrival_time': '21:00',
        'duration': '9h 15m',
        'price': 45000,
        'type': 'Direct',
        'aircraft': 'B777',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Vistara',
        'from': 'Mumbai',
        'to': 'New York',
        'departure_time': '01:30',
        'arrival_time': '08:45',
        'duration': '15h 15m',
        'price': 85000,
        'type': 'Direct',
        'aircraft': 'B777',
        'budget_level': 'luxury',
      },
      {
        'airline': 'Air India',
        'from': 'Mumbai',
        'to': 'New York',
        'departure_time': '16:20',
        'arrival_time': '23:35',
        'duration': '15h 15m',
        'price': 65000,
        'type': 'Direct',
        'aircraft': 'B777',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Air France',
        'from': 'Mumbai',
        'to': 'Paris',
        'departure_time': '02:15',
        'arrival_time': '08:30',
        'duration': '8h 15m',
        'price': 55000,
        'type': 'Direct',
        'aircraft': 'B777',
        'budget_level': 'luxury',
      },
      {
        'airline': 'Lufthansa',
        'from': 'Mumbai',
        'to': 'Paris',
        'departure_time': '14:30',
        'arrival_time': '20:45',
        'duration': '8h 15m',
        'price': 48000,
        'type': '1 Stop',
        'aircraft': 'A350',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Japan Airlines',
        'from': 'Mumbai',
        'to': 'Tokyo',
        'departure_time': '01:45',
        'arrival_time': '12:30',
        'duration': '8h 45m',
        'price': 45000,
        'type': 'Direct',
        'aircraft': 'B777',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Cathay Pacific',
        'from': 'Mumbai',
        'to': 'Hong Kong',
        'departure_time': '03:30',
        'arrival_time': '11:45',
        'duration': '6h 15m',
        'price': 35000,
        'type': 'Direct',
        'aircraft': 'A350',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Korean Air',
        'from': 'Mumbai',
        'to': 'Seoul',
        'departure_time': '02:00',
        'arrival_time': '12:15',
        'duration': '8h 15m',
        'price': 40000,
        'type': 'Direct',
        'aircraft': 'A330',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Malaysia Airlines',
        'from': 'Mumbai',
        'to': 'Kuala Lumpur',
        'departure_time': '04:15',
        'arrival_time': '12:30',
        'duration': '6h 15m',
        'price': 25000,
        'type': 'Direct',
        'aircraft': 'A330',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Qatar Airways',
        'from': 'Mumbai',
        'to': 'Doha',
        'departure_time': '01:30',
        'arrival_time': '03:45',
        'duration': '3h 15m',
        'price': 20000,
        'type': 'Direct',
        'aircraft': 'A350',
        'budget_level': 'mid_range',
      },
      {
        'airline': 'Etihad Airways',
        'from': 'Mumbai',
        'to': 'Abu Dhabi',
        'departure_time': '15:45',
        'arrival_time': '18:00',
        'duration': '3h 15m',
        'price': 18000,
        'type': 'Direct',
        'aircraft': 'B787',
        'budget_level': 'mid_range',
      },
    ];
  }

  static List<Map<String, dynamic>> getRestaurants(Map<String, dynamic> preferences) {
    final themes = preferences['themes'] as List<String>? ?? [];
    final budgetLevel = preferences['budget_level'] as String? ?? 'mid_range';
    final interests = preferences['interests'] as List<String>? ?? [];
    final destination = preferences['destination'] as String? ?? 'Jaipur';
    
    print('MockData.getRestaurants called with themes: $themes, destination: $destination');

    List<Map<String, dynamic>> allRestaurants = _getAllRestaurants();
    
    // Filter by destination
    final destinationRestaurants = allRestaurants.where((restaurant) {
      final restaurantLocation = restaurant['location'] as String;
      return restaurantLocation.toLowerCase().contains(destination.toLowerCase()) ||
             destination.toLowerCase().contains(restaurantLocation.toLowerCase().split(',')[0]);
    }).toList();
    
    final restaurantsToFilter = destinationRestaurants.isNotEmpty ? destinationRestaurants : allRestaurants;

    final filteredRestaurants = restaurantsToFilter.where((restaurant) {
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
      return restaurantsToFilter.take(3).toList();
    }
    return filteredRestaurants;
  }

  static List<Map<String, dynamic>> _getAllRestaurants() {
    return [
      // Mumbai Restaurants
      {
        'name': 'Trishna',
        'cuisine': 'Seafood',
        'price_range': '₹₹₹',
        'rating': 4.7,
        'location': 'Mumbai, Maharashtra',
        'specialties': ['Crab Masala', 'Prawn Curry', 'Fish Tikka'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Legendary seafood restaurant known for authentic coastal cuisine.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Bademiya',
        'cuisine': 'Mughlai',
        'price_range': '₹₹',
        'rating': 4.5,
        'location': 'Mumbai, Maharashtra',
        'specialties': ['Seekh Kebab', 'Chicken Tikka', 'Roti'],
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'description': 'Famous street food joint serving delicious kebabs and tikkas.',
        'budget_level': 'budget',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine', 'Markets'],
      },
      {
        'name': 'The Bombay Canteen',
        'cuisine': 'Modern Indian',
        'price_range': '₹₹₹',
        'rating': 4.6,
        'location': 'Mumbai, Maharashtra',
        'specialties': ['Modern Thali', 'Cocktails', 'Fusion Dishes'],
        'image_url': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
        'description': 'Contemporary restaurant reimagining Indian cuisine with modern techniques.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Entertainment'],
        'interests': ['Local Cuisine'],
      },

      // Delhi Restaurants
      {
        'name': 'Karim\'s',
        'cuisine': 'Mughlai',
        'price_range': '₹₹',
        'rating': 4.6,
        'location': 'Delhi, Delhi',
        'specialties': ['Mutton Korma', 'Chicken Jahangiri', 'Naan'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Historic restaurant serving authentic Mughlai cuisine since 1913.',
        'budget_level': 'budget',
        'themes': ['Food', 'Cultural', 'Heritage'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Bukhara',
        'cuisine': 'North Indian',
        'price_range': '₹₹₹',
        'rating': 4.8,
        'location': 'Delhi, Delhi',
        'specialties': ['Dal Bukhara', 'Tandoori Chicken', 'Naan'],
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'description': 'Award-winning restaurant known for its signature dal and tandoori dishes.',
        'budget_level': 'luxury',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Paranthe Wali Gali',
        'cuisine': 'North Indian',
        'price_range': '₹',
        'rating': 4.3,
        'location': 'Delhi, Delhi',
        'specialties': ['Aloo Parantha', 'Paneer Parantha', 'Mixed Parantha'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Famous street food destination in Old Delhi known for stuffed paranthas.',
        'budget_level': 'budget',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine', 'Markets'],
      },

      // Bangalore Restaurants
      {
        'name': 'MTR (Mavalli Tiffin Room)',
        'cuisine': 'South Indian',
        'price_range': '₹₹',
        'rating': 4.5,
        'location': 'Bangalore, Karnataka',
        'specialties': ['Rava Idli', 'Masala Dosa', 'Filter Coffee'],
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'description': 'Legendary South Indian restaurant famous for its rava idli and filter coffee.',
        'budget_level': 'budget',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Vidyarthi Bhavan',
        'cuisine': 'South Indian',
        'price_range': '₹',
        'rating': 4.4,
        'location': 'Bangalore, Karnataka',
        'specialties': ['Masala Dosa', 'Benne Dosa', 'Filter Coffee'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Historic restaurant known for the best masala dosa in Bangalore.',
        'budget_level': 'budget',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'The Fatty Bao',
        'cuisine': 'Asian Fusion',
        'price_range': '₹₹₹',
        'rating': 4.6,
        'location': 'Bangalore, Karnataka',
        'specialties': ['Bao Buns', 'Ramen', 'Cocktails'],
        'image_url': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
        'description': 'Modern Asian restaurant with innovative fusion dishes and craft cocktails.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Entertainment'],
        'interests': ['Local Cuisine'],
      },

      // Chennai Restaurants
      {
        'name': 'Murugan Idli Shop',
        'cuisine': 'South Indian',
        'price_range': '₹',
        'rating': 4.5,
        'location': 'Chennai, Tamil Nadu',
        'specialties': ['Idli', 'Dosa', 'Sambar'],
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'description': 'Famous for soft idlis and crispy dosas with authentic South Indian flavors.',
        'budget_level': 'budget',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Dakshin',
        'cuisine': 'South Indian',
        'price_range': '₹₹₹',
        'rating': 4.7,
        'location': 'Chennai, Tamil Nadu',
        'specialties': ['Chettinad Chicken', 'Fish Curry', 'Biryani'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Fine dining restaurant serving authentic South Indian cuisine from different states.',
        'budget_level': 'luxury',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },

      // Kolkata Restaurants
      {
        'name': 'Peter Cat',
        'cuisine': 'Continental',
        'price_range': '₹₹',
        'rating': 4.4,
        'location': 'Kolkata, West Bengal',
        'specialties': ['Chelo Kebab', 'Chicken Steak', 'Fish Fry'],
        'image_url': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
        'description': 'Historic restaurant famous for its chelo kebab and continental cuisine.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Kewpie\'s Kitchen',
        'cuisine': 'Bengali',
        'price_range': '₹₹',
        'rating': 4.6,
        'location': 'Kolkata, West Bengal',
        'specialties': ['Fish Curry', 'Mutton Curry', 'Rice'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Authentic Bengali home-style cooking in a traditional setting.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },

      // Hyderabad Restaurants
      {
        'name': 'Paradise Restaurant',
        'cuisine': 'Hyderabadi',
        'price_range': '₹₹',
        'rating': 4.5,
        'location': 'Hyderabad, Telangana',
        'specialties': ['Hyderabadi Biryani', 'Haleem', 'Kebab'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Famous for authentic Hyderabadi biryani and traditional Muslim cuisine.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Bawarchi',
        'cuisine': 'Hyderabadi',
        'price_range': '₹₹',
        'rating': 4.6,
        'location': 'Hyderabad, Telangana',
        'specialties': ['Mutton Biryani', 'Chicken Biryani', 'Raita'],
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'description': 'Another legendary biryani destination with authentic Hyderabadi flavors.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },

      // Goa Restaurants
      {
        'name': 'Gunpowder',
        'cuisine': 'Goan',
        'price_range': '₹₹',
        'rating': 4.7,
        'location': 'Goa',
        'specialties': ['Fish Curry', 'Prawn Balchao', 'Bebinca'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Authentic Goan cuisine with traditional recipes and coastal flavors.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Martin\'s Corner',
        'cuisine': 'Goan',
        'price_range': '₹₹',
        'rating': 4.5,
        'location': 'Goa',
        'specialties': ['Crab Xec Xec', 'Pork Vindaloo', 'Fish Recheado'],
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'description': 'Popular restaurant serving authentic Goan seafood and local specialties.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },

      // Kerala Restaurants
      {
        'name': 'Grand Hotel',
        'cuisine': 'Kerala',
        'price_range': '₹₹',
        'rating': 4.6,
        'location': 'Kerala',
        'specialties': ['Fish Curry', 'Appam', 'Stew'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Traditional Kerala cuisine with authentic flavors and local ingredients.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Paragon Restaurant',
        'cuisine': 'Malayalam',
        'price_range': '₹₹',
        'rating': 4.5,
        'location': 'Kerala',
        'specialties': ['Kerala Biryani', 'Fish Fry', 'Payasam'],
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'description': 'Famous for Kerala biryani and traditional Malayalam cuisine.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },

      // Rajasthan Restaurants (Jaipur)
      {
        'name': 'Suvarna Mahal',
        'cuisine': 'Rajasthani',
        'price_range': '₹₹₹',
        'rating': 4.8,
        'location': 'Jaipur, Rajasthan',
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
        'location': 'Jaipur, Rajasthan',
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
        'location': 'Jaipur, Rajasthan',
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
        'location': 'Jaipur, Rajasthan',
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
        'location': 'Jaipur, Rajasthan',
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
        'location': 'Jaipur, Rajasthan',
        'specialties': ['Pyaz Kachori', 'Samosa', 'Jalebi'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Famous street food destination known for the best pyaz kachori in Jaipur.',
        'budget_level': 'budget',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine', 'Markets'],
      },

      // International Restaurants
      {
        'name': 'Nobu Dubai',
        'cuisine': 'Japanese',
        'price_range': '₹₹₹₹',
        'rating': 4.8,
        'location': 'Dubai, UAE',
        'specialties': ['Sushi', 'Black Cod', 'Tempura'],
        'image_url': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
        'description': 'World-renowned Japanese restaurant with innovative cuisine and stunning views.',
        'budget_level': 'luxury',
        'themes': ['Food', 'Entertainment'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Jumbo Seafood',
        'cuisine': 'Singaporean',
        'price_range': '₹₹₹',
        'rating': 4.7,
        'location': 'Singapore',
        'specialties': ['Chili Crab', 'Black Pepper Crab', 'Mantou'],
        'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'description': 'Famous for Singapore\'s signature chili crab and seafood specialties.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
      {
        'name': 'Jay Fai',
        'cuisine': 'Thai',
        'price_range': '₹₹',
        'rating': 4.9,
        'location': 'Bangkok, Thailand',
        'specialties': ['Crab Omelet', 'Drunken Noodles', 'Tom Yum'],
        'image_url': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        'description': 'Michelin-starred street food restaurant famous for its crab omelet.',
        'budget_level': 'mid_range',
        'themes': ['Food', 'Cultural'],
        'interests': ['Local Cuisine'],
      },
    ];
  }

  static bool _isBudgetCompatible(String budgetLevel, int cost) {
    switch (budgetLevel) {
      case 'budget':
        return cost <= 2000;
      case 'mid_range':
        return cost <= 10000;
      case 'luxury':
        return true; // Luxury accepts all prices
      default:
        return cost <= 5000;
    }
  }
}
