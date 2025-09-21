import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/image_service.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import 'trip_preferences_form.dart';
import 'itinerary_builder_screen.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;
  Map<String, String?> _placeImages = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  void initState() {
    super.initState();
    _loadPlaceImages();
  }
  
  Future<void> _loadPlaceImages() async {
    final images = ImageService.getPlaceImages([
      'Jeju Island',
      'South Korea',
      'Indonesia',
    ]);
    
    print('Loaded images: $images'); // Debug print
    
    if (mounted) {
      setState(() {
        _placeImages = images;
      });
    }
  }

  void _showSnackbarMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              
              // Menu header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_rounded,
                      color: const Color(0xFF0E4F55),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Menu options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildMenuOption(
                      Icons.search_rounded,
                      'Search Destinations',
                      'Find your next adventure',
                      () => _showSnackbar('Search functionality coming soon!'),
                    ),
                    _buildMenuOption(
                      Icons.bookmark_rounded,
                      'Saved Places',
                      'View your bookmarked locations',
                      () => _showSnackbar('Saved places feature coming soon!'),
                    ),
                    _buildMenuOption(
                      Icons.history_rounded,
                      'Recent Trips',
                      'See your travel history',
                      () => _showSnackbar('Recent trips feature coming soon!'),
                    ),
                    _buildMenuOption(
                      Icons.settings_rounded,
                      'Settings',
                      'Customize your experience',
                      () => _showSnackbar('Settings page coming soon!'),
                    ),
                    _buildMenuOption(
                      Icons.help_rounded,
                      'Help & Support',
                      'Get assistance and support',
                      () => _showSnackbar('Help & support coming soon!'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E4F55).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF0E4F55),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
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
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0E4F55),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.fromLTRB(AppStyles.spacing20, AppStyles.spacing16, AppStyles.spacing20, AppStyles.spacing20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppStyles.radius24),
                    bottomRight: Radius.circular(AppStyles.radius24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppStyles.radius8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(AppStyles.radius8),
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              gradient: AppGradients.primaryGradient,
                                              borderRadius: BorderRadius.circular(AppStyles.radius8),
                                            ),
                                            child: const Icon(
                                              Icons.travel_explore_rounded,
                                              color: AppColors.white,
                                              size: 18,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppStyles.spacing12),
                                  Text(
                                    'PlanSmith',
                                    style: AppStyles.heading3.copyWith(
                                      color: AppColors.primary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppStyles.spacing8),
                              Text(
                                'Discover amazing destinations',
                                style: AppStyles.bodyLarge.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppStyles.spacing16),
                        // Menu Button
                        GestureDetector(
                          onTap: _showSnackbarMenu,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(AppStyles.radius12),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.menu_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppStyles.spacing24),
                    
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacing16, vertical: AppStyles.spacing16),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(AppStyles.radius16),
                        border: Border.all(
                          color: AppColors.border,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: AppStyles.spacing12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Where to?',
                                  style: AppStyles.labelLarge.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppStyles.spacing4),
                                Text(
                                  'Search destinations...',
                                  style: AppStyles.bodySmall.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(AppStyles.spacing8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppStyles.radius8),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppStyles.spacing24),
              
              // AI Trip Planner Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppStyles.spacing24),
                padding: const EdgeInsets.all(AppStyles.spacing20),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                  borderRadius: BorderRadius.circular(AppStyles.radius20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppStyles.spacing12),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppStyles.radius12),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: AppStyles.spacing16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Trip Planner',
                                style: AppStyles.heading3.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                'Create personalized itineraries with swipe-to-add',
                                style: AppStyles.bodyMedium.copyWith(
                                  color: AppColors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppStyles.spacing16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _startAITripPlanning,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppStyles.spacing16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppStyles.radius12),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, size: 20),
                                const SizedBox(width: AppStyles.spacing8),
                                Text(
                                  'Plan New Trip',
                                  style: AppStyles.labelLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppStyles.spacing12),
                        OutlinedButton(
                          onPressed: _viewExistingTrips,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.white),
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppStyles.spacing16,
                              horizontal: AppStyles.spacing20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppStyles.radius12),
                            ),
                          ),
                          child: const Icon(Icons.history, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Service Categories
              Padding(
                padding: const EdgeInsets.fromLTRB(AppStyles.spacing24, AppStyles.spacing32, AppStyles.spacing24, AppStyles.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Services',
                      style: AppStyles.heading2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppStyles.spacing20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacing4),
                      child: Row(
                        children: [
                          const SizedBox(width: AppStyles.spacing4),
                          _buildServiceCategory(Icons.bed_outlined, 'Hotel', AppColors.primary),
                          const SizedBox(width: AppStyles.spacing16),
                          _buildServiceCategory(Icons.restaurant_outlined, 'Restaurant', AppColors.secondary),
                          const SizedBox(width: AppStyles.spacing16),
                          _buildServiceCategory(Icons.flight_outlined, 'Flight', AppColors.primaryLight),
                          const SizedBox(width: AppStyles.spacing16),
                          _buildServiceCategory(Icons.directions_car_outlined, 'Rental Car', AppColors.secondaryLight),
                          const SizedBox(width: AppStyles.spacing16),
                          _buildServiceCategory(Icons.tour_rounded, 'Tours', AppColors.primary),
                          const SizedBox(width: AppStyles.spacing16),
                          _buildServiceCategory(Icons.beach_access_rounded, 'Beach', AppColors.secondary),
                          const SizedBox(width: AppStyles.spacing20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Featured Trip Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: const Color(0xFF0E4F55).withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: _placeImages['Jeju Island'] != null
                              ? Image.network(
                                  _placeImages['Jeju Island']!,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xFF1976D2),
                                            const Color(0xFF1976D2).withOpacity(0.8),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Featured card image error: $error'); // Debug print
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xFF1976D2),
                                            const Color(0xFF1976D2).withOpacity(0.8),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFF1976D2),
                                        const Color(0xFF1976D2).withOpacity(0.8),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      // Overlay gradient for better text readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Jeju Trip',
                                              style: TextStyle(
                                                fontFamily: 'Quicksand',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.3,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Discover the natural beauty of South Korea',
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '12-15 October 2024',
                                    style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 88,
                                      height: 36,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(18),
                                                border: Border.all(color: Colors.white, width: 2),
                                              ),
                                              child: Icon(
                                                Icons.person_rounded,
                                                color: const Color(0xFF0E4F55),
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 26,
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(18),
                                                border: Border.all(color: Colors.white, width: 2),
                                              ),
                                              child: Icon(
                                                Icons.person_rounded,
                                                color: const Color(0xFF0E4F55),
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 52,
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(18),
                                                border: Border.all(color: Colors.white, width: 2),
                                              ),
                                              child: Icon(
                                                Icons.person_add_rounded,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '+2 friends',
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to group trip details
                                    Navigator.pushNamed(context, '/group-trip-details', arguments: {
                                      'id': 'jeju_trip',
                                      'name': 'Jeju Trip',
                                      'destination': 'Jeju Island, South Korea',
                                      'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
                                      'startDate': DateTime.now().add(const Duration(days: 7)),
                                      'endDate': DateTime.now().add(const Duration(days: 14)),
                                      'members': 5,
                                      'budget': 1500.0,
                                      'status': 'confirmed',
                                      'isGroupTrip': true,
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Group Trip >',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0E4F55),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 28),
              
              // Most Popular Trip Section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Most Popular Trip',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E4F55).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0E4F55),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Popular Trip Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    _buildPopularTripCard('South Korea', '🇰🇷', 'Seoul, Busan'),
                    const SizedBox(width: 16),
                    _buildPopularTripCard('Indonesia', '🇮🇩', 'Bali, Jakarta'),
                    _buildPopularTripCard('Japan', '🇯🇵', 'Tokyo, Kyoto'),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
              
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 32,
              offset: const Offset(0, 12),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: const Color(0xFF0E4F55).withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade50,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0, true),
              _buildNavItem(Icons.explore_rounded, 'Explore', 1, false),
              _buildNavItem(Icons.edit_calendar_rounded, '', 2, false, isSpecial: true),
              _buildNavItem(Icons.luggage_rounded, 'Trip', 3, false),
              _buildNavItem(Icons.person_rounded, 'Profile', 4, false),
            ],
          ),
        ),
      ),
      
      // Floating Action Button for Expenses
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/expenses');
        },
        backgroundColor: const Color(0xFF0E4F55),
        foregroundColor: Colors.white,
        elevation: 0,
        child: const Icon(Icons.account_balance_wallet_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
    );
  }

  Widget _buildServiceCategory(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () => _showSnackbar('$label service coming soon!'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppStyles.radius16),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: AppStyles.spacing8),
            Text(
              label,
              style: AppStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularTripCard(String country, String flag, String cities) {
    final imageUrl = _placeImages[country];
    print('Building card for $country with image: $imageUrl'); // Debug print
    
    return GestureDetector(
      onTap: () {
        // Navigate to destination details
        Navigator.pushNamed(context, '/destination');
      },
      child: Container(
      width: 160,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0xFF0E4F55).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image
          if (imageUrl != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1976D2).withOpacity(0.1),
                            const Color(0xFF1976D2).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xFF1976D2),
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('Image load error for $country: $error'); // Debug print
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1976D2).withOpacity(0.1),
                            const Color(0xFF1976D2).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),
            ),
          
          // Overlay for better text readability
          if (imageUrl != null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        flag,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            country,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: imageUrl != null ? Colors.white : Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            cities,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: imageUrl != null 
                                  ? Colors.white.withOpacity(0.8) 
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 36,
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
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Explore',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0E4F55),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: const Color(0xFF0E4F55),
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isSelected, {bool isSpecial = false}) {
    if (isSpecial) {
      return GestureDetector(
        onTap: () {
          // Navigate to destination details screen
          Navigator.pushNamed(context, '/destination');
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0E4F55),
                const Color(0xFF0E4F55).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0E4F55).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 26,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        
        // Navigate to different screens based on index
        switch (index) {
          case 0:
            // Home - already here
            break;
          case 1:
            // Explore - navigate to creator zone
            Navigator.pushNamed(context, '/creator');
            break;
          case 3:
            // Trip - navigate to itinerary
            Navigator.pushNamed(context, '/itinerary');
            break;
          case 4:
            // Profile - navigate to profile
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0E4F55).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF0E4F55) : Colors.grey.shade500,
              size: 24,
            ),
            const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF0E4F55) : Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _startAITripPlanning() {
    print('Starting AI trip planning...');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripPreferencesForm(
          onSubmit: (preferences) {
            print('Received preferences in callback: $preferences');
            // First pop the form, then navigate to itinerary builder
            Navigator.pop(context); // Close the form
            print('Navigating to ItineraryBuilderScreen...');
            print('About to create ItineraryBuilderScreen with preferences: $preferences');
            
            // Use a small delay to ensure the form is closed before navigation
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      print('MaterialPageRoute builder called');
                      return ItineraryBuilderScreen(
                        userPreferences: preferences,
                      );
                    },
                  ),
                ).then((_) {
                  print('Navigation to ItineraryBuilderScreen completed');
                }).catchError((error) {
                  print('Navigation error: $error');
                });
              }
            });
          },
        ),
      ),
    );
  }

  void _viewExistingTrips() {
    // Show existing trips or navigate to trip history
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Trip History',
          style: AppStyles.heading3.copyWith(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your recent trips will appear here.',
              style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppStyles.spacing16),
            Container(
              padding: const EdgeInsets.all(AppStyles.spacing16),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(AppStyles.radius12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.travel_explore,
                    size: 48,
                    color: AppColors.grey400,
                  ),
                  const SizedBox(height: AppStyles.spacing8),
                  Text(
                    'No trips yet',
                    style: AppStyles.labelLarge.copyWith(color: AppColors.textSecondary),
                  ),
                  Text(
                    'Start planning your first trip!',
                    style: AppStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppStyles.labelLarge.copyWith(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startAITripPlanning();
            },
            style: AppStyles.primaryButton,
            child: Text(
              'Plan Trip',
              style: AppStyles.labelLarge.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
