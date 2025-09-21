import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class SwipeableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onTap;

  const SwipeableCard({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onTap,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  Offset _dragStart = Offset.zero;
  double _dragExtent = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _dragStart = details.localPosition;
    _isDragging = true;
    _animationController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    _dragExtent = details.localPosition.dx - _dragStart.dx;
    final screenWidth = MediaQuery.of(context).size.width;
    final dragPercentage = _dragExtent / screenWidth;

    setState(() {
      _dragExtent = details.localPosition.dx - _dragStart.dx;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    _isDragging = false;
    final screenWidth = MediaQuery.of(context).size.width;
    final dragPercentage = _dragExtent / screenWidth;

    if (dragPercentage.abs() > 0.3) {
      // Swipe threshold reached
      if (dragPercentage > 0) {
        // Swipe right
        _animateSwipeRight();
        widget.onSwipeRight?.call();
      } else {
        // Swipe left
        _animateSwipeLeft();
        widget.onSwipeLeft?.call();
      }
    } else {
      // Return to center
      _animateToCenter();
    }
  }

  void _animateSwipeRight() {
    _animation = Tween<double>(
      begin: _dragExtent,
      end: MediaQuery.of(context).size.width,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: _dragExtent / 100,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  void _animateSwipeLeft() {
    _animation = Tween<double>(
      begin: _dragExtent,
      end: -MediaQuery.of(context).size.width,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: _dragExtent / 100,
      end: -0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  void _animateToCenter() {
    _animation = Tween<double>(
      begin: _dragExtent,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: _dragExtent / 100,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final translateX = _isDragging ? _dragExtent : _animation.value;
        final rotation = _isDragging ? _dragExtent / 100 : _rotationAnimation.value;
        final scale = _isDragging ? 1.0 : _scaleAnimation.value;

        return Transform.translate(
          offset: Offset(translateX, 0),
          child: Transform.rotate(
            angle: rotation,
            child: Transform.scale(
              scale: scale,
              child: GestureDetector(
                onTap: widget.onTap,
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Map<String, dynamic> activity;
  final VoidCallback? onAdd;
  final VoidCallback? onReject;

  const ActivityCard({
    super.key,
    required this.activity,
    this.onAdd,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppStyles.spacing16),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppStyles.radius16),
                topRight: Radius.circular(AppStyles.radius16),
              ),
              image: activity['image_url'] != null
                  ? DecorationImage(
                      image: NetworkImage(activity['image_url']),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: activity['image_url'] == null ? AppColors.grey200 : null,
            ),
            child: activity['image_url'] == null
                ? const Center(
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: AppColors.grey500,
                    ),
                  )
                : null,
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppStyles.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity['name'] ?? 'Activity',
                        style: AppStyles.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (activity['rating'] != null) ...[
                      const Icon(
                        Icons.star,
                        color: AppColors.warning,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        activity['rating'].toString(),
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: AppStyles.spacing8),
                
                // Category
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.spacing8,
                    vertical: AppStyles.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppStyles.radius8),
                  ),
                  child: Text(
                    activity['category'] ?? 'Activity',
                    style: AppStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(height: AppStyles.spacing12),
                
                // Description
                Text(
                  activity['description'] ?? 'No description available',
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: AppStyles.spacing16),
                
                // Details Row
                Row(
                  children: [
                    // Duration
                    Expanded(
                      child: _buildDetailItem(
                        Icons.access_time,
                        '${activity['duration_hours'] ?? 2} hrs',
                        AppColors.info,
                      ),
                    ),
                    // Cost
                    Expanded(
                      child: _buildDetailItem(
                        Icons.currency_rupee,
                        '₹${activity['cost_per_person'] ?? 500}',
                        AppColors.success,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppStyles.spacing16),
                
                // Location
                if (activity['location'] != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          activity['location'],
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
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

  Widget _buildDetailItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppStyles.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class AccommodationCard extends StatelessWidget {
  final Map<String, dynamic> accommodation;
  final VoidCallback? onAdd;
  final VoidCallback? onReject;

  const AccommodationCard({
    super.key,
    required this.accommodation,
    this.onAdd,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppStyles.spacing16),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppStyles.radius16),
                topRight: Radius.circular(AppStyles.radius16),
              ),
              image: accommodation['image_url'] != null
                  ? DecorationImage(
                      image: NetworkImage(accommodation['image_url']),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: accommodation['image_url'] == null ? AppColors.grey200 : null,
            ),
            child: accommodation['image_url'] == null
                ? const Center(
                    child: Icon(
                      Icons.hotel,
                      size: 50,
                      color: AppColors.grey500,
                    ),
                  )
                : null,
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppStyles.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        accommodation['name'] ?? 'Accommodation',
                        style: AppStyles.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (accommodation['rating'] != null) ...[
                      const Icon(
                        Icons.star,
                        color: AppColors.warning,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        accommodation['rating'].toString(),
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: AppStyles.spacing8),
                
                // Type
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.spacing8,
                    vertical: AppStyles.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppStyles.radius8),
                  ),
                  child: Text(
                    accommodation['type'] ?? 'Hotel',
                    style: AppStyles.caption.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(height: AppStyles.spacing12),
                
                // Price
                Row(
                  children: [
                    Text(
                      '₹${accommodation['cost_per_night'] ?? 2000}',
                      style: AppStyles.heading3.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/ night',
                      style: AppStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppStyles.spacing12),
                
                // Amenities
                if (accommodation['amenities'] != null)
                  Wrap(
                    spacing: AppStyles.spacing8,
                    runSpacing: AppStyles.spacing4,
                    children: (accommodation['amenities'] as List)
                        .take(4)
                        .map((amenity) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppStyles.spacing8,
                                vertical: AppStyles.spacing4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.grey100,
                                borderRadius: BorderRadius.circular(AppStyles.radius8),
                              ),
                              child: Text(
                                amenity,
                                style: AppStyles.caption,
                              ),
                            ))
                        .toList(),
                  ),
                
                const SizedBox(height: AppStyles.spacing16),
                
                // Location
                if (accommodation['location'] != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          accommodation['location'],
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
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
}

class FlightCard extends StatelessWidget {
  final Map<String, dynamic> flight;
  final VoidCallback? onAdd;
  final VoidCallback? onReject;

  const FlightCard({
    super.key,
    required this.flight,
    this.onAdd,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppStyles.spacing16),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with airline
          Container(
            padding: const EdgeInsets.all(AppStyles.spacing16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppStyles.radius16),
                topRight: Radius.circular(AppStyles.radius16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight['airline'] ?? 'Airline',
                        style: AppStyles.heading3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '${flight['from']} → ${flight['to']}',
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.spacing12,
                    vertical: AppStyles.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppStyles.radius8),
                  ),
                  child: Text(
                    flight['type'] ?? 'Direct',
                    style: AppStyles.labelMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppStyles.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Flight details
                Row(
                  children: [
                    Expanded(
                      child: _buildFlightDetail(
                        'Departure',
                        flight['departure_time'] ?? 'N/A',
                        Icons.flight_takeoff,
                      ),
                    ),
                    Expanded(
                      child: _buildFlightDetail(
                        'Arrival',
                        flight['arrival_time'] ?? 'N/A',
                        Icons.flight_land,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppStyles.spacing16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildFlightDetail(
                        'Duration',
                        flight['duration'] ?? 'N/A',
                        Icons.access_time,
                      ),
                    ),
                    Expanded(
                      child: _buildFlightDetail(
                        'Aircraft',
                        flight['aircraft'] ?? 'N/A',
                        Icons.flight,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppStyles.spacing16),
                
                // Price
                Container(
                  padding: const EdgeInsets.all(AppStyles.spacing16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppStyles.radius12),
                    border: Border.all(color: AppColors.success.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price per person',
                            style: AppStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '₹${flight['price'] ?? 0}',
                            style: AppStyles.heading2.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.currency_rupee,
                        color: AppColors.success,
                        size: 32,
                      ),
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

  Widget _buildFlightDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(height: AppStyles.spacing4),
        Text(
          label,
          style: AppStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppStyles.spacing4),
        Text(
          value,
          style: AppStyles.labelMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final VoidCallback? onAdd;
  final VoidCallback? onReject;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onAdd,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppStyles.spacing16),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppStyles.radius16),
                topRight: Radius.circular(AppStyles.radius16),
              ),
              image: restaurant['image_url'] != null
                  ? DecorationImage(
                      image: NetworkImage(restaurant['image_url']),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: restaurant['image_url'] == null ? AppColors.grey200 : null,
            ),
            child: restaurant['image_url'] == null
                ? const Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 50,
                      color: AppColors.grey500,
                    ),
                  )
                : null,
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppStyles.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        restaurant['name'] ?? 'Restaurant',
                        style: AppStyles.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (restaurant['rating'] != null) ...[
                      const Icon(
                        Icons.star,
                        color: AppColors.warning,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant['rating'].toString(),
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: AppStyles.spacing8),
                
                // Cuisine and Price Range
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppStyles.spacing8,
                        vertical: AppStyles.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppStyles.radius8),
                      ),
                      child: Text(
                        restaurant['cuisine'] ?? 'Cuisine',
                        style: AppStyles.caption.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppStyles.spacing8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppStyles.spacing8,
                        vertical: AppStyles.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppStyles.radius8),
                      ),
                      child: Text(
                        restaurant['price_range'] ?? '₹₹',
                        style: AppStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppStyles.spacing12),
                
                // Description
                Text(
                  restaurant['description'] ?? 'No description available',
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: AppStyles.spacing16),
                
                // Specialties
                if (restaurant['specialties'] != null) ...[
                  Text(
                    'Specialties',
                    style: AppStyles.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppStyles.spacing8),
                  Wrap(
                    spacing: AppStyles.spacing8,
                    runSpacing: AppStyles.spacing4,
                    children: (restaurant['specialties'] as List)
                        .take(3)
                        .map((specialty) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppStyles.spacing8,
                                vertical: AppStyles.spacing4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.grey100,
                                borderRadius: BorderRadius.circular(AppStyles.radius8),
                              ),
                              child: Text(
                                specialty,
                                style: AppStyles.caption,
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: AppStyles.spacing16),
                ],
                
                // Location
                if (restaurant['location'] != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant['location'],
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
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
}
