import 'package:flutter/material.dart';
import 'dart:io';

class ExpenseTrackingScreen extends StatefulWidget {
  const ExpenseTrackingScreen({super.key});

  @override
  State<ExpenseTrackingScreen> createState() => _ExpenseTrackingScreenState();
}

class _ExpenseTrackingScreenState extends State<ExpenseTrackingScreen> {
  List<Map<String, dynamic>> expenses = [];
  double totalExpenses = 0.0;
  String selectedPeriod = 'This Month';
  List<Map<String, dynamic>> tripPhotos = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // TODO: Replace with actual data from API
    expenses = [
      {
        'id': '1',
        'title': 'Hotel Booking',
        'amount': 450.0,
        'category': 'Accommodation',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'icon': Icons.hotel_rounded,
        'color': const Color(0xFF0E4F55),
      },
      {
        'id': '2',
        'title': 'Flight Tickets',
        'amount': 320.0,
        'category': 'Transportation',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'icon': Icons.flight_rounded,
        'color': const Color(0xFF1976D2),
      },
      {
        'id': '3',
        'title': 'Restaurant Dinner',
        'amount': 85.0,
        'category': 'Food',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'icon': Icons.restaurant_rounded,
        'color': const Color(0xFF2E7D32),
      },
      {
        'id': '4',
        'title': 'Museum Tickets',
        'amount': 25.0,
        'category': 'Entertainment',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'icon': Icons.museum_rounded,
        'color': const Color(0xFF7B1FA2),
      },
      {
        'id': '5',
        'title': 'Taxi Rides',
        'amount': 45.0,
        'category': 'Transportation',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'icon': Icons.local_taxi_rounded,
        'color': const Color(0xFFF57C00),
      },
      {
        'id': '6',
        'title': 'Shopping',
        'amount': 120.0,
        'category': 'Shopping',
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'icon': Icons.shopping_bag_rounded,
        'color': const Color(0xFFE91E63),
      },
    ];
    
    // Mock trip photos data
    tripPhotos = [
      {
        'id': '1',
        'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
        'uploadedBy': 'Alice',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'location': 'Beach Resort',
        'likes': 12,
      },
      {
        'id': '2',
        'imageUrl': 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400',
        'uploadedBy': 'Bob',
        'date': DateTime.now().subtract(const Duration(hours: 5)),
        'location': 'Mountain View',
        'likes': 8,
      },
      {
        'id': '3',
        'imageUrl': 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400',
        'uploadedBy': 'Charlie',
        'date': DateTime.now().subtract(const Duration(hours: 8)),
        'location': 'Restaurant',
        'likes': 15,
      },
    ];
    
    _calculateTotal();
  }

  void _calculateTotal() {
    totalExpenses = expenses.fold(0.0, (sum, expense) => sum + expense['amount']);
  }

  Map<String, double> _getCategoryTotals() {
    Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      String category = expense['category'];
      categoryTotals[category] = (categoryTotals[category] ?? 0) + expense['amount'];
    }
    return categoryTotals;
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
        title: const Text(
          'Expense Tracking',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Color(0xFF0E4F55),
              size: 20,
            ),
            onSelected: (value) {
              setState(() {
                selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'This Week',
                child: Text('This Week'),
              ),
              const PopupMenuItem(
                value: 'This Month',
                child: Text('This Month'),
              ),
              const PopupMenuItem(
                value: 'This Year',
                child: Text('This Year'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Total Expenses Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
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
                      Text(
                        'Total Expenses',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          selectedPeriod,
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '₹${totalExpenses.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${expenses.length} transactions',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Chart Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    'Expense Breakdown',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0E4F55),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPieChart(),
                  const SizedBox(height: 20),
                  _buildCategoryLegend(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Trip Photos Section
            _buildTripPhotosSection(),

            const SizedBox(height: 20),

            // Expenses List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Expenses',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0E4F55),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddExpenseModal(),
                    icon: const Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: Color(0xFF0E4F55),
                    ),
                    label: const Text(
                      'Add Expense',
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

            const SizedBox(height: 16),

            // Expenses List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return _buildExpenseItem(expense);
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final categoryTotals = _getCategoryTotals();
    final colors = [
      const Color(0xFF0E4F55),
      const Color(0xFF1976D2),
      const Color(0xFF2E7D32),
      const Color(0xFF7B1FA2),
      const Color(0xFFF57C00),
      const Color(0xFFE91E63),
    ];

    return SizedBox(
      height: 200,
      child: Row(
        children: [
          // Pie Chart Placeholder
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
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
                      Icons.pie_chart_rounded,
                      size: 48,
                      color: Color(0xFF0E4F55),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Chart View',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0E4F55),
                      ),
                    ),
                    Text(
                      'Coming Soon',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Category List
          Expanded(
            flex: 3,
            child: Column(
              children: categoryTotals.entries.map((entry) {
                final percentage = (entry.value / totalExpenses * 100).round();
                final colorIndex = categoryTotals.keys.toList().indexOf(entry.key) % colors.length;
                return _buildCategoryItem(
                  entry.key,
                  entry.value,
                  percentage,
                  colors[colorIndex],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category, double amount, int percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0E4F55),
                  ),
                ),
                Text(
                  '$percentage% • ₹${amount.toStringAsFixed(0)}',
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

  Widget _buildCategoryLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: _getCategoryTotals().keys.map((category) {
        final colorIndex = _getCategoryTotals().keys.toList().indexOf(category) % 6;
        final colors = [
          const Color(0xFF0E4F55),
          const Color(0xFF1976D2),
          const Color(0xFF2E7D32),
          const Color(0xFF7B1FA2),
          const Color(0xFFF57C00),
          const Color(0xFFE91E63),
        ];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colors[colorIndex].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors[colorIndex].withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            category,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors[colorIndex],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpenseItem(Map<String, dynamic> expense) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              color: expense['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              expense['icon'],
              color: expense['color'],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense['title'],
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E4F55),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        expense['category'],
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(expense['date']),
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '-₹${expense['amount'].toStringAsFixed(0)}',
            style: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0E4F55),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Add New Expense',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0E4F55),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Form fields
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Expense Title',
                    hintText: 'e.g., Hotel Booking',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.title_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: '0.00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.attach_money_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.category_rounded),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Accommodation', child: Text('Accommodation')),
                    DropdownMenuItem(value: 'Transportation', child: Text('Transportation')),
                    DropdownMenuItem(value: 'Food', child: Text('Food')),
                    DropdownMenuItem(value: 'Entertainment', child: Text('Entertainment')),
                    DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 32),
                
                // Add button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Expense added successfully!'),
                          backgroundColor: Color(0xFF0E4F55),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E4F55),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Add Expense',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTripPhotosSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trip Photos',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E4F55),
                ),
              ),
              TextButton.icon(
                onPressed: _showAddPhotoDialog,
                icon: const Icon(
                  Icons.add_photo_alternate_rounded,
                  color: Color(0xFF0E4F55),
                  size: 18,
                ),
                label: const Text(
                  'Add Photo',
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
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tripPhotos.length,
              itemBuilder: (context, index) {
                final photo = tripPhotos[index];
                return _buildPhotoCard(photo);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(Map<String, dynamic> photo) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${photo['likes']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
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
          ),
          const SizedBox(height: 8),
          Text(
            photo['uploadedBy'],
            style: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0E4F55),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            photo['location'],
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showAddPhotoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add Photo',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
        ),
        content: const Text(
          'Choose a photo to share with your travel group',
          style: TextStyle(
            fontFamily: 'Quicksand',
            color: Colors.grey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Quicksand',
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add mock photo
              setState(() {
                tripPhotos.insert(0, {
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'imageUrl': 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400',
                  'uploadedBy': 'You',
                  'date': DateTime.now(),
                  'location': 'New Location',
                  'likes': 0,
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo added successfully!'),
                  backgroundColor: Color(0xFF0E4F55),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E4F55),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Add Photo',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
