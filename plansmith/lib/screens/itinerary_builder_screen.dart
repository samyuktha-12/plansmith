import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../models/mock_data.dart';
import '../widgets/swipeable_card.dart';

class ItineraryBuilderScreen extends StatefulWidget {
  final Map<String, dynamic> userPreferences;

  const ItineraryBuilderScreen({
    super.key,
    required this.userPreferences,
  });

  @override
  State<ItineraryBuilderScreen> createState() => _ItineraryBuilderScreenState();
}

class _ItineraryBuilderScreenState extends State<ItineraryBuilderScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentCardIndex = 0;
  bool _isListView = true; // Toggle between list and swipe view
  
  // Selected items
  List<Map<String, dynamic>> selectedActivities = [];
  List<Map<String, dynamic>> selectedAccommodations = [];
  List<Map<String, dynamic>> selectedFlights = [];
  List<Map<String, dynamic>> selectedRestaurants = [];
  
  // Mock data
  List<Map<String, dynamic>> activities = [];
  List<Map<String, dynamic>> accommodations = [];
  List<Map<String, dynamic>> flights = [];
  List<Map<String, dynamic>> restaurants = [];

  @override
  void initState() {
    super.initState();
    print('ItineraryBuilderScreen initState called');
    print('User preferences received: ${widget.userPreferences}');
    _tabController = TabController(length: 4, vsync: this);
    _loadMockData();
  }

  void _loadMockData() {
    print('Loading mock data with preferences: ${widget.userPreferences}');
    try {
      setState(() {
        activities = MockData.getActivities(widget.userPreferences);
        accommodations = MockData.getAccommodations(widget.userPreferences);
        flights = MockData.getFlights(widget.userPreferences);
        restaurants = MockData.getRestaurants(widget.userPreferences);
      });
      
      print('Loaded activities: ${activities.length}');
      print('Loaded accommodations: ${accommodations.length}');
      print('Loaded flights: ${flights.length}');
      print('Loaded restaurants: ${restaurants.length}');
    } catch (e) {
      print('Error loading mock data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('=== ItineraryBuilderScreen build method called ===');
    print('Current context: $context');
    print('Widget mounted: $mounted');
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Build Your Trip',
          style: AppStyles.heading3.copyWith(color: AppColors.primary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(icon: Icon(Icons.explore), text: 'Activities'),
            Tab(icon: Icon(Icons.hotel), text: 'Stays'),
            Tab(icon: Icon(Icons.flight), text: 'Flights'),
            Tab(icon: Icon(Icons.restaurant), text: 'Food'),
          ],
        ),
      ),
      body: Column(
        children: [
          // View Toggle
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildToggleButton('List', Icons.list, _isListView),
                      _buildToggleButton('Swipe', Icons.swipe, !_isListView),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _isListView 
                  ? _buildSimpleContent(activities, 'Activities')
                  : _buildSwipeContent(activities, 'Activities'),
                _isListView 
                  ? _buildSimpleContent(accommodations, 'Accommodations')
                  : _buildSwipeContent(accommodations, 'Accommodations'),
                _isListView 
                  ? _buildSimpleContent(flights, 'Flights')
                  : _buildSwipeContent(flights, 'Flights'),
                _isListView 
                  ? _buildSimpleContent(restaurants, 'Restaurants')
                  : _buildSwipeContent(restaurants, 'Restaurants'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewItinerary,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.check, color: AppColors.white),
      ),
    );
  }

  Widget _buildToggleButton(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isListView = label == 'List';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeContent(List<Map<String, dynamic>> items, String title) {
    print('Building swipe content for $title with ${items.length} items');
    
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              'No $title found',
              style: AppStyles.heading3.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your preferences',
              style: AppStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Swipe to select $title',
                style: AppStyles.heading3.copyWith(color: AppColors.textPrimary),
              ),
              Text(
                '${items.length} available',
                style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        
        // Swipe Cards
        Expanded(
          child: Stack(
            children: [
              // Background cards (stacked behind)
              if (items.length > 1)
                Positioned.fill(
                  child: _buildCardStack(items, title, 1),
                ),
              if (items.length > 2)
                Positioned.fill(
                  child: _buildCardStack(items, title, 2),
                ),
              
              // Top card (swipeable)
              if (items.isNotEmpty)
                Positioned.fill(
                  child: _buildSwipeableCard(items, title),
                ),
            ],
          ),
        ),
        
        // Instructions
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSwipeInstruction(Icons.close, 'Pass', AppColors.error),
              _buildSwipeInstruction(Icons.favorite, 'Add', AppColors.success),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardStack(List<Map<String, dynamic>> items, String title, int offset) {
    if (items.length <= offset) return const SizedBox.shrink();
    
    return Transform.translate(
      offset: Offset(offset * 4.0, offset * 4.0),
      child: Transform.scale(
        scale: 1.0 - (offset * 0.05),
        child: _buildCard(items[offset], title, false),
      ),
    );
  }

  Widget _buildSwipeableCard(List<Map<String, dynamic>> items, String title) {
    if (items.isEmpty) return const SizedBox.shrink();
    
    return SwipeableCard(
      onSwipeLeft: () => _handleSwipeLeft(items, title),
      onSwipeRight: () => _handleSwipeRight(items, title),
      child: _buildCard(items[0], title, true),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, String title, bool isTop) {
    switch (title.toLowerCase()) {
      case 'activities':
        return ActivityCard(
          activity: item,
          onAdd: () => _handleSwipeRight([item], title),
          onReject: () => _handleSwipeLeft([item], title),
        );
      case 'accommodations':
        return AccommodationCard(
          accommodation: item,
          onAdd: () => _handleSwipeRight([item], title),
          onReject: () => _handleSwipeLeft([item], title),
        );
      case 'flights':
        return FlightCard(
          flight: item,
          onAdd: () => _handleSwipeRight([item], title),
          onReject: () => _handleSwipeLeft([item], title),
        );
      case 'restaurants':
        return RestaurantCard(
          restaurant: item,
          onAdd: () => _handleSwipeRight([item], title),
          onReject: () => _handleSwipeLeft([item], title),
        );
      default:
        return ActivityCard(
          activity: item,
          onAdd: () => _handleSwipeRight([item], title),
          onReject: () => _handleSwipeLeft([item], title),
        );
    }
  }

  Widget _buildSwipeInstruction(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppStyles.labelMedium.copyWith(color: color),
        ),
      ],
    );
  }

  void _handleSwipeRight(List<Map<String, dynamic>> items, String title) {
    if (items.isEmpty) return;
    
    final item = items.first;
    _toggleItemSelection(item, title.toLowerCase());
    
    // Show success popup
    _showSwipeFeedback(true, item['name'] ?? 'Item', title);
    
    // Remove the item from the list and move to next
    setState(() {
      switch (title.toLowerCase()) {
        case 'activities':
          activities.removeAt(0);
          break;
        case 'accommodations':
          accommodations.removeAt(0);
          break;
        case 'flights':
          flights.removeAt(0);
          break;
        case 'restaurants':
          restaurants.removeAt(0);
          break;
      }
    });
  }

  void _handleSwipeLeft(List<Map<String, dynamic>> items, String title) {
    if (items.isEmpty) return;
    
    final item = items.first;
    
    // Show pass popup
    _showSwipeFeedback(false, item['name'] ?? 'Item', title);
    
    // Just remove the item without adding to selection
    setState(() {
      switch (title.toLowerCase()) {
        case 'activities':
          activities.removeAt(0);
          break;
        case 'accommodations':
          accommodations.removeAt(0);
          break;
        case 'flights':
          flights.removeAt(0);
          break;
        case 'restaurants':
          restaurants.removeAt(0);
          break;
      }
    });
  }

  Widget _buildSimpleContent(List<Map<String, dynamic>> items, String title) {
    print('Building simple content for $title with ${items.length} items');
    
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              'No $title found',
              style: AppStyles.heading3.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your preferences',
              style: AppStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select $title',
                style: AppStyles.heading3.copyWith(color: AppColors.textPrimary),
              ),
              Text(
                '${items.length} available',
                style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        
        // Items list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildItemCard(item, title.toLowerCase());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, String type) {
    final isSelected = _isItemSelected(item, type);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSelected ? AppColors.primary : AppColors.grey200,
          child: Icon(
            _getIconForType(type),
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
        title: Text(
          item['name'] ?? 'Unknown',
          style: AppStyles.labelLarge.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item['description'] != null)
              Text(
                item['description'],
                style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (item['cost_per_person'] != null)
                  Text(
                    '₹${item['cost_per_person']}',
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (item['cost_per_person'] != null && item['rating'] != null)
                  const SizedBox(width: 8),
                if (item['rating'] != null)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        '${item['rating']}',
                        style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isSelected ? Icons.check_circle : Icons.add_circle_outline,
            color: isSelected ? AppColors.success : AppColors.primary,
          ),
          onPressed: () => _toggleItemSelection(item, type),
        ),
        onTap: () => _toggleItemSelection(item, type),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'activities':
        return Icons.explore;
      case 'accommodations':
        return Icons.hotel;
      case 'flights':
        return Icons.flight;
      case 'restaurants':
        return Icons.restaurant;
      default:
        return Icons.place;
    }
  }

  bool _isItemSelected(Map<String, dynamic> item, String type) {
    switch (type) {
      case 'activities':
        return selectedActivities.contains(item);
      case 'accommodations':
        return selectedAccommodations.contains(item);
      case 'flights':
        return selectedFlights.contains(item);
      case 'restaurants':
        return selectedRestaurants.contains(item);
      default:
        return false;
    }
  }

  void _toggleItemSelection(Map<String, dynamic> item, String type) {
    setState(() {
      switch (type) {
        case 'activities':
          if (selectedActivities.contains(item)) {
            selectedActivities.remove(item);
          } else {
            selectedActivities.add(item);
          }
          break;
        case 'accommodations':
          if (selectedAccommodations.contains(item)) {
            selectedAccommodations.remove(item);
          } else {
            selectedAccommodations.add(item);
          }
          break;
        case 'flights':
          if (selectedFlights.contains(item)) {
            selectedFlights.remove(item);
          } else {
            selectedFlights.add(item);
          }
          break;
        case 'restaurants':
          if (selectedRestaurants.contains(item)) {
            selectedRestaurants.remove(item);
          } else {
            selectedRestaurants.add(item);
          }
          break;
      }
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} ${_isItemSelected(item, type) ? 'added to' : 'removed from'} itinerary'),
        duration: const Duration(seconds: 1),
        backgroundColor: _isItemSelected(item, type) ? AppColors.success : AppColors.error,
      ),
    );
  }

  void _viewItinerary() {
    final totalSelected = selectedActivities.length +
        selectedAccommodations.length +
        selectedFlights.length +
        selectedRestaurants.length;

    if (totalSelected == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one item to create an itinerary'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final itinerary = {
      'activities': selectedActivities,
      'accommodations': selectedAccommodations,
      'flights': selectedFlights,
      'restaurants': selectedRestaurants,
      'preferences': widget.userPreferences,
    };
    
    print('Creating itinerary with $totalSelected items');
    
    // For now, just show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Itinerary Created!',
          style: AppStyles.heading3.copyWith(color: AppColors.primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your trip itinerary has been created with:'),
            const SizedBox(height: 8),
            Text('• ${selectedActivities.length} Activities'),
            Text('• ${selectedAccommodations.length} Accommodations'),
            Text('• ${selectedFlights.length} Flights'),
            Text('• ${selectedRestaurants.length} Restaurants'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to home
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showSwipeFeedback(bool isAdded, String itemName, String category) {
    final color = isAdded ? AppColors.success : AppColors.error;
    final icon = isAdded ? Icons.favorite : Icons.close;
    final message = isAdded ? 'Added to itinerary!' : 'Passed';
    
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 100,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: color.withOpacity(0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                itemName,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}