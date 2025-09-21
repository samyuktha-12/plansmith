import 'package:flutter/material.dart';

class AnimatedItineraryScreen extends StatefulWidget {
  final Map<String, dynamic> trip;

  const AnimatedItineraryScreen({
    super.key,
    required this.trip,
  });

  @override
  State<AnimatedItineraryScreen> createState() => _AnimatedItineraryScreenState();
}

class _AnimatedItineraryScreenState extends State<AnimatedItineraryScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  List<Map<String, dynamic>> itinerary = [];
  int selectedDay = 1;
  int selectedActivity = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _loadMockItinerary();
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
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
            'title': 'Hippodrome Entry',
            'location': 'Hippodrome',
            'address': 'Binbirdirek, Sultan Ahmet Parkı No:2',
            'rating': 4.8,
            'tags': ['Statues', 'Fountain'],
            'imageUrl': 'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=400&h=300&fit=crop',
            'isCompleted': true,
            'duration': '2 hours',
            'cost': 0,
          },
          {
            'id': '2',
            'time': '12:00 PM',
            'title': 'Grand Bazaar',
            'location': 'Grand Bazaar',
            'address': 'Beyazıt, Kalpakçılar Cd. No:22',
            'rating': 4.9,
            'tags': ['Bazaar', 'Markets'],
            'imageUrl': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400&h=300&fit=crop',
            'isCompleted': false,
            'duration': '3 hours',
            'cost': 0,
          },
        ],
        'transport': [
          {
            'from': 'Hippodrome',
            'to': 'Grand Bazaar',
            'method': 'Walk',
            'duration': '23m',
            'cost': '₺0',
            'distance': '300m',
          },
          {
            'from': 'Bus Station 1',
            'to': 'Bus Station 2',
            'method': 'Bus',
            'duration': '15m',
            'cost': '₺5',
            'route': '45, 9',
            'stops': '3 stops',
          },
        ],
      },
      {
        'id': '2',
        'day': 2,
        'title': 'Cultural Sites & Markets',
        'activities': [
          {
            'id': '3',
            'time': '08:00 AM',
            'title': 'Senso-ji Temple Visit',
            'location': 'Senso-ji Temple',
            'address': '2-3-1 Asakusa, Taito City, Tokyo',
            'rating': 4.7,
            'tags': ['Temple', 'Cultural'],
            'imageUrl': 'https://images.unsplash.com/photo-1548013146-72479768bada?w=400&h=300&fit=crop',
            'isCompleted': false,
            'duration': '3 hours',
            'cost': 0,
          },
        ],
        'transport': [],
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
                        '< ${widget.trip['name']}',
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
                    Icons.share_rounded,
                    color: Color(0xFF0E4F55),
                    size: 20,
                  ),
                  onPressed: () => _shareItinerary(),
                ),
              ],
            ),
          ),
          
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
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
          ),
          
          // Content
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
    );
  }

  Widget _buildItineraryTab() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip Summary
              _buildTripSummaryCard(),
              const SizedBox(height: 24),
              
              // Day Selector
              _buildDaySelector(),
              const SizedBox(height: 20),
              
              // Activities List
              Expanded(
                child: ListView.builder(
                  itemCount: _getSelectedDayActivities().length,
                  itemBuilder: (context, index) {
                    final activity = _getSelectedDayActivities()[index];
                    return _buildAnimatedActivityCard(activity, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransportTab() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transport Options
              _buildTransportOptions(),
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
                  itemCount: _getSelectedDayTransport().length,
                  itemBuilder: (context, index) {
                    final transport = _getSelectedDayTransport()[index];
                    return _buildTransportCard(transport, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    return Container(
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E4F55).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trip Summary',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildSummaryItem('5 spots', Icons.location_on_rounded),
                    const SizedBox(width: 20),
                    _buildSummaryItem('9 km', Icons.straighten_rounded),
                    const SizedBox(width: 20),
                    _buildSummaryItem('2h 20m', Icons.access_time_rounded),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.route_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0E4F55) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: const Color(0xFF0E4F55).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
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
    );
  }

  Widget _buildAnimatedActivityCard(Map<String, dynamic> activity, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                  // Activity Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        children: [
                          Image.network(
                            activity['imageUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
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
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    color: Color(0xFF0E4F55),
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          ),
                          // Overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Activity Number
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: activity['isCompleted'] 
                                    ? Colors.green 
                                    : const Color(0xFF0E4F55),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
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
                                        style: const TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          // Rating
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    activity['rating'].toString(),
                                    style: const TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
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
                  
                  // Activity Details
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0E4F55),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0E4F55).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                activity['duration'],
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0E4F55),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: (activity['tags'] as List).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransportOptions() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              _buildTransportOption(Icons.directions_walk_rounded, 'Foot', '23m', '₺0'),
              const SizedBox(width: 12),
              _buildTransportOption(Icons.tram_rounded, 'Tram', '15m', '₺5'),
              const SizedBox(width: 12),
              _buildTransportOption(Icons.train_rounded, 'Metro', '12m', '₺8'),
            ],
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

  Widget _buildTransportCard(Map<String, dynamic> transport, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E4F55).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTransportIcon(transport['method']),
                      color: const Color(0xFF0E4F55),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${transport['from']} - ${transport['to']}',
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0E4F55),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${transport['method']} for ${transport['distance'] ?? transport['stops'] ?? ''}',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (transport['route'] != null)
                          Text(
                            'Route: ${transport['route']}',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        transport['duration'],
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0E4F55),
                        ),
                      ),
                      Text(
                        transport['cost'],
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getTransportIcon(String method) {
    switch (method.toLowerCase()) {
      case 'walk':
        return Icons.directions_walk_rounded;
      case 'bus':
        return Icons.directions_bus_rounded;
      case 'tram':
        return Icons.tram_rounded;
      case 'metro':
        return Icons.train_rounded;
      default:
        return Icons.directions_transit_rounded;
    }
  }

  List<Map<String, dynamic>> _getSelectedDayActivities() {
    final selectedDayData = itinerary.firstWhere(
      (day) => day['day'] == selectedDay,
      orElse: () => itinerary.first,
    );
    return selectedDayData['activities'] as List<Map<String, dynamic>>;
  }

  List<Map<String, dynamic>> _getSelectedDayTransport() {
    final selectedDayData = itinerary.firstWhere(
      (day) => day['day'] == selectedDay,
      orElse: () => itinerary.first,
    );
    return selectedDayData['transport'] as List<Map<String, dynamic>>;
  }

  void _shareItinerary() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }
}
