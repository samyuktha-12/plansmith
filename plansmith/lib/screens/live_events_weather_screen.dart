import 'package:flutter/material.dart';

class LiveEventsWeatherScreen extends StatefulWidget {
  final Map<String, dynamic> trip;

  const LiveEventsWeatherScreen({
    super.key,
    required this.trip,
  });

  @override
  State<LiveEventsWeatherScreen> createState() => _LiveEventsWeatherScreenState();
}

class _LiveEventsWeatherScreenState extends State<LiveEventsWeatherScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> currentWeather = {};
  List<Map<String, dynamic>> weatherForecast = [];
  List<Map<String, dynamic>> liveEvents = [];
  List<Map<String, dynamic>> alerts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    // TODO: Replace with actual API calls
    currentWeather = {
      'temperature': 22,
      'condition': 'Partly Cloudy',
      'humidity': 65,
      'windSpeed': 12,
      'uvIndex': 6,
      'feelsLike': 24,
      'icon': 'partly_cloudy',
      'lastUpdated': DateTime.now(),
    };

    weatherForecast = [
      {
        'day': 'Today',
        'date': DateTime.now(),
        'high': 25,
        'low': 18,
        'condition': 'Partly Cloudy',
        'icon': 'partly_cloudy',
        'precipitation': 20,
        'windSpeed': 12,
      },
      {
        'day': 'Tomorrow',
        'date': DateTime.now().add(const Duration(days: 1)),
        'high': 28,
        'low': 20,
        'condition': 'Sunny',
        'icon': 'sunny',
        'precipitation': 5,
        'windSpeed': 8,
      },
      {
        'day': 'Wednesday',
        'date': DateTime.now().add(const Duration(days: 2)),
        'high': 26,
        'low': 19,
        'condition': 'Rainy',
        'icon': 'rainy',
        'precipitation': 80,
        'windSpeed': 15,
      },
      {
        'day': 'Thursday',
        'date': DateTime.now().add(const Duration(days: 3)),
        'high': 24,
        'low': 17,
        'condition': 'Cloudy',
        'icon': 'cloudy',
        'precipitation': 40,
        'windSpeed': 10,
      },
      {
        'day': 'Friday',
        'date': DateTime.now().add(const Duration(days: 4)),
        'high': 27,
        'low': 21,
        'condition': 'Sunny',
        'icon': 'sunny',
        'precipitation': 10,
        'windSpeed': 6,
      },
    ];

    liveEvents = [
      {
        'id': '1',
        'title': 'Tokyo Cherry Blossom Festival',
        'location': 'Ueno Park',
        'date': DateTime.now().add(const Duration(days: 2)),
        'time': '10:00 AM - 6:00 PM',
        'type': 'Festival',
        'description': 'Annual cherry blossom viewing festival with food stalls and cultural performances.',
        'price': 'Free',
        'imageUrl': 'https://images.unsplash.com/photo-1522383225653-ed111181a951?w=400&h=300&fit=crop',
        'isRecommended': true,
      },
      {
        'id': '2',
        'title': 'Traditional Tea Ceremony',
        'location': 'Meiji Shrine',
        'date': DateTime.now().add(const Duration(days: 1)),
        'time': '2:00 PM - 4:00 PM',
        'type': 'Cultural',
        'description': 'Experience authentic Japanese tea ceremony in a traditional setting.',
        'price': '¥2,000',
        'imageUrl': 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&h=300&fit=crop',
        'isRecommended': false,
      },
      {
        'id': '3',
        'title': 'Night Market Food Tour',
        'location': 'Shibuya District',
        'date': DateTime.now(),
        'time': '7:00 PM - 10:00 PM',
        'type': 'Food',
        'description': 'Guided tour of local night markets with authentic street food tasting.',
        'price': '¥5,000',
        'imageUrl': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400&h=300&fit=crop',
        'isRecommended': true,
      },
    ];

    alerts = [
      {
        'id': '1',
        'type': 'weather',
        'title': 'Rain Alert',
        'message': 'Heavy rain expected tomorrow. Consider indoor activities.',
        'severity': 'warning',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': false,
      },
      {
        'id': '2',
        'type': 'event',
        'title': 'Event Cancellation',
        'message': 'Tokyo Garden Tour has been cancelled due to weather.',
        'severity': 'info',
        'time': DateTime.now().subtract(const Duration(hours: 4)),
        'isRead': true,
      },
      {
        'id': '3',
        'type': 'transport',
        'title': 'Transport Delay',
        'message': 'Metro Line 1 experiencing 15-minute delays.',
        'severity': 'warning',
        'time': DateTime.now().subtract(const Duration(minutes: 30)),
        'isRead': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => _refreshData(),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0E4F55),
                      Color(0xFF0E4F55),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Updates',
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.trip['destination'],
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Live',
                                  style: const TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Updated ${_getLastUpdated()}',
                                  style: const TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
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
                Tab(text: 'Weather'),
                Tab(text: 'Events'),
                Tab(text: 'Alerts'),
              ],
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildWeatherTab(),
                  _buildEventsTab(),
                  _buildAlertsTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Weather
          _buildCurrentWeatherCard(),
          const SizedBox(height: 24),
          
          // Weather Forecast
          const Text(
            '5-Day Forecast',
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
              itemCount: weatherForecast.length,
              itemBuilder: (context, index) {
                return _buildForecastCard(weatherForecast[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Events',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E4F55),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAllEvents(),
                icon: const Icon(Icons.list_rounded, size: 16),
                label: const Text('View All'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0E4F55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              itemCount: liveEvents.length,
              itemBuilder: (context, index) {
                return _buildEventCard(liveEvents[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Alerts & Notifications',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E4F55),
                ),
              ),
              TextButton(
                onPressed: () => _markAllAsRead(),
                child: const Text(
                  'Mark All Read',
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
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                return _buildAlertCard(alerts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherCard() {
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentWeather['temperature']}°C',
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    currentWeather['condition'],
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    'Feels like ${currentWeather['feelsLike']}°C',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(
                    _getWeatherIcon(currentWeather['icon']),
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated ${_getLastUpdated()}',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Weather Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail('Humidity', '${currentWeather['humidity']}%', Icons.water_drop_rounded),
              _buildWeatherDetail('Wind', '${currentWeather['windSpeed']} km/h', Icons.air_rounded),
              _buildWeatherDetail('UV Index', '${currentWeather['uvIndex']}', Icons.wb_sunny_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard(Map<String, dynamic> forecast) {
    return Container(
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
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  forecast['day'],
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E4F55),
                  ),
                ),
                Text(
                  _formatDate(forecast['date']),
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
          Expanded(
            flex: 1,
            child: Icon(
              _getWeatherIcon(forecast['icon']),
              size: 32,
              color: const Color(0xFF0E4F55),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  forecast['condition'],
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${forecast['precipitation']}% chance',
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
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${forecast['high']}°',
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0E4F55),
                  ),
                ),
                Text(
                  '${forecast['low']}°',
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
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
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
          // Event Image
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
                    event['imageUrl'],
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
                            Icons.event_rounded,
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
                  // Recommended Badge
                  if (event['isRecommended'])
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Recommended',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Event Details
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
                            event['title'],
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0E4F55),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            event['location'],
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
                        color: _getEventTypeColor(event['type']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event['type'],
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getEventTypeColor(event['type']),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Text(
                  event['description'],
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_formatDate(event['date'])} • ${event['time']}',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      event['price'],
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0E4F55),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getAlertColor(alert['severity']),
          width: 2,
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getAlertColor(alert['severity']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getAlertIcon(alert['type']),
              color: _getAlertColor(alert['severity']),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alert['title'],
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0E4F55),
                        ),
                      ),
                    ),
                    if (!alert['isRead'])
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0E4F55),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  alert['message'],
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getTimeAgo(alert['time']),
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
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String icon) {
    switch (icon) {
      case 'sunny':
        return Icons.wb_sunny_rounded;
      case 'partly_cloudy':
        return Icons.wb_cloudy_rounded;
      case 'cloudy':
        return Icons.cloud_rounded;
      case 'rainy':
        return Icons.umbrella_rounded;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  Color _getEventTypeColor(String type) {
    switch (type) {
      case 'Festival':
        return Colors.orange;
      case 'Cultural':
        return Colors.purple;
      case 'Food':
        return Colors.green;
      case 'Entertainment':
        return Colors.blue;
      default:
        return const Color(0xFF0E4F55);
    }
  }

  Color _getAlertColor(String severity) {
    switch (severity) {
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getAlertIcon(String type) {
    switch (type) {
      case 'weather':
        return Icons.wb_cloudy_rounded;
      case 'event':
        return Icons.event_rounded;
      case 'transport':
        return Icons.directions_transit_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _getLastUpdated() {
    final now = DateTime.now();
    final diff = now.difference(currentWeather['lastUpdated']);
    
    if (diff.inMinutes < 1) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    
    if (diff == 0) {
      return 'Today';
    } else if (diff == 1) {
      return 'Tomorrow';
    } else if (diff < 7) {
      return '${date.weekday == 1 ? 'Mon' : date.weekday == 2 ? 'Tue' : date.weekday == 3 ? 'Wed' : date.weekday == 4 ? 'Thu' : date.weekday == 5 ? 'Fri' : date.weekday == 6 ? 'Sat' : 'Sun'}';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  void _refreshData() {
    // TODO: Implement data refresh
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data refreshed!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _showAllEvents() {
    // TODO: Navigate to all events screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All events view coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var alert in alerts) {
        alert['isRead'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All alerts marked as read!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }
}
