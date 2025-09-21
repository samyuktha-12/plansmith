import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class ItineraryPreviewScreen extends StatelessWidget {
  final Map<String, dynamic> itinerary;

  const ItineraryPreviewScreen({
    super.key,
    required this.itinerary,
  });

  @override
  Widget build(BuildContext context) {
    final activities = itinerary['activities'] as List<Map<String, dynamic>>? ?? [];
    final accommodations = itinerary['accommodations'] as List<Map<String, dynamic>>? ?? [];
    final flights = itinerary['flights'] as List<Map<String, dynamic>>? ?? [];
    final restaurants = itinerary['restaurants'] as List<Map<String, dynamic>>? ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Your Trip Itinerary',
          style: AppStyles.heading3.copyWith(color: AppColors.primary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.primary),
            onPressed: () => _shareItinerary(context),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: AppColors.primary),
            onPressed: () => _saveItinerary(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Summary
            _buildTripSummary(),
            
            const SizedBox(height: AppStyles.spacing32),
            
            // Selected Items
            if (activities.isNotEmpty) ...[
              _buildSection('Activities', activities, Icons.explore, AppColors.primary),
              const SizedBox(height: AppStyles.spacing24),
            ],
            
            if (accommodations.isNotEmpty) ...[
              _buildSection('Accommodations', accommodations, Icons.hotel, AppColors.secondary),
              const SizedBox(height: AppStyles.spacing24),
            ],
            
            if (flights.isNotEmpty) ...[
              _buildSection('Flights', flights, Icons.flight, AppColors.info),
              const SizedBox(height: AppStyles.spacing24),
            ],
            
            if (restaurants.isNotEmpty) ...[
              _buildSection('Restaurants', restaurants, Icons.restaurant, AppColors.success),
              const SizedBox(height: AppStyles.spacing24),
            ],
            
            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummary() {
    final totalItems = (itinerary['activities'] as List).length +
        (itinerary['accommodations'] as List).length +
        (itinerary['flights'] as List).length +
        (itinerary['restaurants'] as List).length;
    
    final preferences = itinerary['preferences'] as Map<String, dynamic>? ?? {};
    
    return Container(
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
                  Icons.travel_explore,
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
                      'Your Perfect Trip',
                      style: AppStyles.heading3.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      '$totalItems items selected',
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
          
          // Trip details
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Duration',
                  '${preferences['trip_duration'] ?? 5} days',
                  Icons.calendar_today,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Travelers',
                  '${preferences['travelers_count'] ?? 1}',
                  Icons.people,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Budget',
                  '₹${preferences['budget_amount'] ?? 50000}',
                  Icons.account_balance_wallet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.white,
          size: 20,
        ),
        const SizedBox(height: AppStyles.spacing4),
        Text(
          label,
          style: AppStyles.caption.copyWith(
            color: AppColors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: AppStyles.spacing4),
        Text(
          value,
          style: AppStyles.labelMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppStyles.spacing8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppStyles.radius8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: AppStyles.spacing12),
            Text(
              title,
              style: AppStyles.heading3.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(width: AppStyles.spacing8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.spacing8,
                vertical: AppStyles.spacing4,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppStyles.radius8),
              ),
              child: Text(
                '${items.length}',
                style: AppStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppStyles.spacing16),
        
        ...items.map((item) => _buildItemCard(item, color)).toList(),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppStyles.spacing12),
      padding: const EdgeInsets.all(AppStyles.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppStyles.radius12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppStyles.radius12),
            ),
            child: Icon(
              _getItemIcon(item),
              color: color,
              size: 24,
            ),
          ),
          
          const SizedBox(width: AppStyles.spacing16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'Item',
                  style: AppStyles.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppStyles.spacing4),
                Text(
                  item['description'] ?? item['location'] ?? 'Description',
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppStyles.spacing8),
                Row(
                  children: [
                    if (item['cost_per_person'] != null) ...[
                      Text(
                        '₹${item['cost_per_person']}',
                        style: AppStyles.labelMedium.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppStyles.spacing8),
                    ],
                    if (item['rating'] != null) ...[
                      const Icon(
                        Icons.star,
                        color: AppColors.warning,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        item['rating'].toString(),
                        style: AppStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getItemIcon(Map<String, dynamic> item) {
    if (item.containsKey('category')) {
      return Icons.explore;
    } else if (item.containsKey('type')) {
      return Icons.hotel;
    } else if (item.containsKey('airline')) {
      return Icons.flight;
    } else if (item.containsKey('cuisine')) {
      return Icons.restaurant;
    }
    return Icons.place;
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Edit Itinerary Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              // Go back to itinerary builder
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: AppStyles.spacing16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppStyles.radius12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.edit, size: 20),
                const SizedBox(width: AppStyles.spacing8),
                Text(
                  'Edit Itinerary',
                  style: AppStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppStyles.spacing16),
        
        // Book Trip Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _bookTrip(context),
            style: AppStyles.primaryButton,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.credit_card, size: 20, color: AppColors.white),
                const SizedBox(width: AppStyles.spacing8),
                Text(
                  'Book Trip',
                  style: AppStyles.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _shareItinerary(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Itinerary shared successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _saveItinerary(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Itinerary saved to your trips!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _bookTrip(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Book Your Trip',
          style: AppStyles.heading3.copyWith(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ready to book your personalized trip?',
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
                  Text(
                    'Total Estimated Cost',
                    style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppStyles.spacing4),
                  Text(
                    '₹${_calculateTotalCost()}',
                    style: AppStyles.heading2.copyWith(color: AppColors.primary),
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
              'Cancel',
              style: AppStyles.labelLarge.copyWith(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _proceedToPayment(context);
            },
            style: AppStyles.primaryButton,
            child: Text(
              'Proceed to Payment',
              style: AppStyles.labelLarge.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Redirecting to payment gateway...'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  String _calculateTotalCost() {
    int total = 0;
    
    // Calculate activities cost
    for (var activity in itinerary['activities'] as List) {
      final cost = (activity['cost_per_person'] ?? 0) as num;
      final travelers = (itinerary['preferences']?['travelers_count'] ?? 1) as num;
      total += (cost * travelers).round();
    }
    
    // Calculate accommodations cost
    for (var accommodation in itinerary['accommodations'] as List) {
      final costPerNight = (accommodation['cost_per_night'] ?? 0) as num;
      final nights = int.tryParse(itinerary['preferences']?['trip_duration'] ?? '5') ?? 5;
      total += (costPerNight * nights).round();
    }
    
    // Calculate flights cost
    for (var flight in itinerary['flights'] as List) {
      final price = (flight['price'] ?? 0) as num;
      final travelers = (itinerary['preferences']?['travelers_count'] ?? 1) as num;
      total += (price * travelers).round();
    }
    
    return total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}
