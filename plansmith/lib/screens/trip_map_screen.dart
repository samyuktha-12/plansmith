import 'package:flutter/material.dart';

class TripMapScreen extends StatefulWidget {
  final Map<String, dynamic> trip;

  const TripMapScreen({
    super.key,
    required this.trip,
  });

  @override
  State<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends State<TripMapScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> itinerary = [];
  int selectedDay = 1;
  int selectedActivity = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMockItinerary();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadMockItinerary() {
    // TODO: Replace with actual API call
    itinerary = [
      {
        'id': '1',
        'day': 1,
        'title': 'Arrival & City Exploration',
        'activities': [
          {
            'id': '1',
            'time': '09:00 AM',
            'title': 'Check-in at Hotel',
            'location': 'Grand Hotel Tokyo',
            'address': '1-1-1 Marunouchi, Chiyoda City, Tokyo',
            'lat': 35.6762,
            'lng': 139.6503,
            'duration': '1 hour',
            'cost': 0,
            'isCompleted': true,
          },
          {
            'id': '2',
            'time': '10:30 AM',
            'title': 'Tokyo Station Tour',
            'location': 'Tokyo Station',
            'address': '1 Chome-9-1 Marunouchi, Chiyoda City, Tokyo',
            'lat': 35.6812,
            'lng': 139.7671,
            'duration': '2 hours',
            'cost': 20,
            'isCompleted': true,
          },
          {
            'id': '3',
            'time': '02:00 PM',
            'title': 'Lunch at Local Restaurant',
            'location': 'Ginza District',
            'address': 'Ginza, Chuo City, Tokyo',
            'lat': 35.6718,
            'lng': 139.7649,
            'duration': '1 hour',
            'cost': 50,
            'isCompleted': false,
          },
        ],
      },
      {
        'id': '2',
        'day': 2,
        'title': 'Cultural Sites & Markets',
        'activities': [
          {
            'id': '4',
            'time': '08:00 AM',
            'title': 'Senso-ji Temple Visit',
            'location': 'Senso-ji Temple',
            'address': '2-3-1 Asakusa, Taito City, Tokyo',
            'lat': 35.7148,
            'lng': 139.7967,
            'duration': '3 hours',
            'cost': 0,
            'isCompleted': false,
          },
          {
            'id': '5',
            'time': '12:00 PM',
            'title': 'Tsukiji Fish Market',
            'location': 'Tsukiji Fish Market',
            'address': '5-2-1 Tsukiji, Chuo City, Tokyo',
            'lat': 35.6654,
            'lng': 139.7706,
            'duration': '2 hours',
            'cost': 80,
            'isCompleted': false,
          },
        ],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 20,
              right: 20,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Color(0xFF0E4F55),
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.trip['name'],
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0E4F55),
                        ),
                      ),
                      Text(
                        widget.trip['destination'],
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.layers_rounded,
                    color: Color(0xFF0E4F55),
                    size: 20,
                  ),
                  onPressed: () => _showMapLayers(),
                ),
              ],
            ),
          ),
          
          // Map Placeholder
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Map Placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF0E4F55).withOpacity(0.1),
                            const Color(0xFF0E4F55).withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map_rounded,
                              size: 64,
                              color: Color(0xFF0E4F55),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Interactive Map',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0E4F55),
                              ),
                            ),
                            Text(
                              'Coming Soon',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Map Controls
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        _buildMapControl(Icons.my_location_rounded, 'My Location'),
                        const SizedBox(height: 8),
                        _buildMapControl(Icons.layers_rounded, 'Layers'),
                        const SizedBox(height: 8),
                        _buildMapControl(Icons.fullscreen_rounded, 'Fullscreen'),
                      ],
                    ),
                  ),
                  
                  // Route Info
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E4F55).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.route_rounded,
                              color: Color(0xFF0E4F55),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Today\'s Route',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0E4F55),
                                  ),
                                ),
                                Text(
                                  '5 stops • 9 km • 2h 20m',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => _startNavigation(),
                            child: const Text(
                              'Start',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0E4F55),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Panel
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Tab Bar
                TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF0E4F55),
                  unselectedLabelColor: Colors.grey.shade600,
                  indicatorColor: const Color(0xFF0E4F55),
                  labelStyle: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Itinerary'),
                    Tab(text: 'Transport'),
                  ],
                ),
                
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildItineraryTab(),
                      _buildTransportTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControl(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: const Color(0xFF0E4F55),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildItineraryTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Selector
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itinerary.length,
              itemBuilder: (context, index) {
                final day = itinerary[index];
                final isSelected = selectedDay == day['day'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = day['day'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0E4F55) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Day ${day['day']}',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Activities List
          Expanded(
            child: ListView.builder(
              itemCount: _getSelectedDayActivities().length,
              itemBuilder: (context, index) {
                final activity = _getSelectedDayActivities()[index];
                return _buildActivityCard(activity, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transport Options
          const Text(
            'Transport Options',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0E4F55),
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              _buildTransportOption(Icons.directions_walk_rounded, 'Walk', '23m', '₺0'),
              const SizedBox(width: 12),
              _buildTransportOption(Icons.tram_rounded, 'Tram', '15m', '₺5'),
              const SizedBox(width: 12),
              _buildTransportOption(Icons.train_rounded, 'Metro', '12m', '₺8'),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Route Details
          const Text(
            'Route Details',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0E4F55),
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              itemCount: _getSelectedDayActivities().length,
              itemBuilder: (context, index) {
                final activity = _getSelectedDayActivities()[index];
                return _buildRouteItem(activity, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: activity['isCompleted'] 
              ? Colors.green 
              : selectedActivity == index 
                  ? const Color(0xFF0E4F55) 
                  : Colors.grey.shade200,
          width: activity['isCompleted'] || selectedActivity == index ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Activity Number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: activity['isCompleted'] 
                  ? Colors.green 
                  : selectedActivity == index 
                      ? const Color(0xFF0E4F55) 
                      : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: activity['isCompleted']
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    )
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: selectedActivity == index ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Activity Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF0E4F55),
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Activity Details
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
                const SizedBox(height: 4),
                Text(
                  activity['title'],
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E4F55),
                  ),
                ),
                Text(
                  activity['location'],
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // Action Button
          GestureDetector(
            onTap: () {
              setState(() {
                selectedActivity = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selectedActivity == index 
                    ? const Color(0xFF0E4F55) 
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'View',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selectedActivity == index ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportOption(IconData icon, String name, String duration, String cost) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF0E4F55), size: 24),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0E4F55),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              duration,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              cost,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteItem(Map<String, dynamic> activity, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0E4F55).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF0E4F55),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E4F55),
                  ),
                ),
                Text(
                  activity['address'],
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                activity['duration'],
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              if (activity['cost'] > 0)
                Text(
                  '₹${activity['cost']}',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getSelectedDayActivities() {
    final selectedDayData = itinerary.firstWhere(
      (day) => day['day'] == selectedDay,
      orElse: () => itinerary.first,
    );
    return selectedDayData['activities'] as List<Map<String, dynamic>>;
  }

  void _showMapLayers() {
    // TODO: Implement map layers
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Map layers coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _startNavigation() {
    // TODO: Implement navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigation starting...'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }
}
