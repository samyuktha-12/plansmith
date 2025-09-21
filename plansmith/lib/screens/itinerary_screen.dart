import 'package:flutter/material.dart';

class ItineraryScreen extends StatefulWidget {
  final String destinationName;
  final String country;

  const ItineraryScreen({
    super.key,
    required this.destinationName,
    required this.country,
  });

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  double totalCost = 0.0;
  List<Map<String, dynamic>> expenses = [];

  @override
  void initState() {
    super.initState();
    _calculateTotalCost();
  }

  void _calculateTotalCost() {
    // TODO: Calculate from actual itinerary data
    totalCost = 1250.0; // Mock total cost
  }

  void _addToExpenses(Map<String, dynamic> activity) {
    setState(() {
      expenses.add({
        'title': activity['title'],
        'cost': activity['cost'],
        'category': activity['category'],
        'date': DateTime.now(),
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${activity['title']} added to expenses'),
        backgroundColor: const Color(0xFF0E4F55),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF0E4F55),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.destinationName} Itinerary',
          style: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share_rounded,
              color: Color(0xFF0E4F55),
              size: 20,
            ),
            onPressed: () {
              // TODO: Implement share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality coming soon!'),
                  backgroundColor: Color(0xFF0E4F55),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Total Cost Card
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0E4F55),
                        Color(0xFF0E4F55),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Estimated Cost',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalCost.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0E4F55),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E4F55).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '3 Days',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0E4F55),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Itinerary List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 3, // 3 days
              itemBuilder: (context, dayIndex) {
                return _buildDayCard(dayIndex + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(int dayNumber) {
    final activities = _getDayActivities(dayNumber);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0E4F55),
                  Color(0xFF0E4F55),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day $dayNumber',
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _getDayTitle(dayNumber),
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${activities.length} activities',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          
          // Activities List
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: activities.map((activity) => _buildActivityCard(activity)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getCategoryColor(activity['category']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(activity['category']),
                  color: _getCategoryColor(activity['category']),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['time'],
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activity['title'],
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E4F55),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${activity['cost']}',
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0E4F55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            activity['description'],
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement book activity functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Booking ${activity['title']} - Coming soon!'),
                        backgroundColor: const Color(0xFF0E4F55),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.book_online_rounded,
                    size: 16,
                  ),
                  label: const Text('Book Activity'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0E4F55),
                    side: const BorderSide(color: Color(0xFF0E4F55)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _addToExpenses(activity),
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 16,
                  ),
                  label: const Text('Add to Expenses'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E4F55),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDayActivities(int dayNumber) {
    // TODO: Replace with actual data from API
    switch (dayNumber) {
      case 1:
        return [
          {
            'time': '09:00 AM',
            'title': 'City Walking Tour',
            'description': 'Explore the historic city center with a knowledgeable local guide. Visit iconic landmarks and learn about the city\'s rich history.',
            'cost': 45,
            'category': 'Tours',
          },
          {
            'time': '12:00 PM',
            'title': 'Traditional Lunch',
            'description': 'Enjoy authentic local cuisine at a family-owned restaurant in the heart of the city.',
            'cost': 25,
            'category': 'Food',
          },
          {
            'time': '02:00 PM',
            'title': 'Museum Visit',
            'description': 'Discover the city\'s art and culture at the renowned national museum.',
            'cost': 15,
            'category': 'Culture',
          },
          {
            'time': '06:00 PM',
            'title': 'Sunset Viewpoint',
            'description': 'Watch the sunset from the best viewpoint in the city with panoramic views.',
            'cost': 0,
            'category': 'Sightseeing',
          },
        ];
      case 2:
        return [
          {
            'time': '08:00 AM',
            'title': 'Market Visit',
            'description': 'Experience the vibrant local market and taste fresh local produce.',
            'cost': 20,
            'category': 'Food',
          },
          {
            'time': '10:00 AM',
            'title': 'Art Gallery',
            'description': 'Visit contemporary art galleries showcasing local and international artists.',
            'cost': 12,
            'category': 'Culture',
          },
          {
            'time': '01:00 PM',
            'title': 'Cooking Class',
            'description': 'Learn to cook traditional dishes with a professional chef.',
            'cost': 65,
            'category': 'Experience',
          },
        ];
      case 3:
        return [
          {
            'time': '09:00 AM',
            'title': 'Nature Hike',
            'description': 'Explore the beautiful natural surroundings with a guided hiking tour.',
            'cost': 35,
            'category': 'Adventure',
          },
          {
            'time': '02:00 PM',
            'title': 'Spa & Relaxation',
            'description': 'Unwind with traditional spa treatments and relaxation techniques.',
            'cost': 80,
            'category': 'Wellness',
          },
          {
            'time': '07:00 PM',
            'title': 'Farewell Dinner',
            'description': 'Enjoy a special farewell dinner at a fine dining restaurant.',
            'cost': 55,
            'category': 'Food',
          },
        ];
      default:
        return [];
    }
  }

  String _getDayTitle(int dayNumber) {
    switch (dayNumber) {
      case 1:
        return 'City Exploration & Culture';
      case 2:
        return 'Local Experiences & Art';
      case 3:
        return 'Nature & Relaxation';
      default:
        return 'Adventure Day';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Tours':
        return Icons.tour_rounded;
      case 'Food':
        return Icons.restaurant_rounded;
      case 'Culture':
        return Icons.museum_rounded;
      case 'Sightseeing':
        return Icons.visibility_rounded;
      case 'Experience':
        return Icons.auto_awesome_rounded;
      case 'Adventure':
        return Icons.hiking_rounded;
      case 'Wellness':
        return Icons.spa_rounded;
      default:
        return Icons.explore_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Tours':
        return const Color(0xFF0E4F55);
      case 'Food':
        return const Color(0xFF2E7D32);
      case 'Culture':
        return const Color(0xFF7B1FA2);
      case 'Sightseeing':
        return const Color(0xFF1976D2);
      case 'Experience':
        return const Color(0xFFF57C00);
      case 'Adventure':
        return const Color(0xFF00BCD4);
      case 'Wellness':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF0E4F55);
    }
  }
}
