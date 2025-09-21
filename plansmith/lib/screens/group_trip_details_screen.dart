import 'package:flutter/material.dart';
import 'user_search_screen.dart';

class GroupTripDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> trip;

  const GroupTripDetailsScreen({
    super.key,
    required this.trip,
  });

  @override
  State<GroupTripDetailsScreen> createState() => _GroupTripDetailsScreenState();
}

class _GroupTripDetailsScreenState extends State<GroupTripDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> groupMembers = [];
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> itinerary = [];
  double totalBudget = 0.0;
  double totalExpenses = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    totalBudget = widget.trip['budget'] ?? 0.0;
    
    // TODO: Replace with actual API calls
    groupMembers = [
      {
        'id': '1',
        'name': 'You',
        'email': 'you@email.com',
        'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        'isAdmin': true,
        'isOnline': true,
        'contribution': 500.0,
      },
      {
        'id': '2',
        'name': 'Sarah Chen',
        'email': 'sarah.chen@email.com',
        'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        'isAdmin': false,
        'isOnline': true,
        'contribution': 500.0,
      },
      {
        'id': '3',
        'name': 'Mike Rodriguez',
        'email': 'mike.rodriguez@email.com',
        'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        'isAdmin': false,
        'isOnline': false,
        'contribution': 500.0,
      },
    ];

    expenses = [
      {
        'id': '1',
        'title': 'Hotel Booking',
        'amount': 800.0,
        'category': 'Accommodation',
        'paidBy': 'You',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'isSettled': true,
      },
      {
        'id': '2',
        'title': 'Flight Tickets',
        'amount': 1200.0,
        'category': 'Transportation',
        'paidBy': 'Sarah Chen',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'isSettled': false,
      },
      {
        'id': '3',
        'title': 'Restaurant Dinner',
        'amount': 150.0,
        'category': 'Food',
        'paidBy': 'Mike Rodriguez',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'isSettled': false,
      },
    ];

    bookings = [
      {
        'id': '1',
        'title': 'Grand Hotel Tokyo',
        'type': 'Hotel',
        'date': 'Dec 15-17, 2024',
        'amount': 800.0,
        'status': 'Confirmed',
        'bookedBy': 'You',
        'confirmationNumber': 'GH-2024-001234',
      },
      {
        'id': '2',
        'title': 'Tokyo City Tour',
        'type': 'Activity',
        'date': 'Dec 16, 2024',
        'amount': 120.0,
        'status': 'Confirmed',
        'bookedBy': 'Sarah Chen',
        'confirmationNumber': 'TC-2024-567890',
      },
    ];

    itinerary = [
      {
        'id': '1',
        'day': 1,
        'title': 'Arrival & City Exploration',
        'activities': [
          {
            'time': '09:00 AM',
            'title': 'Check-in at Hotel',
            'location': 'Grand Hotel Tokyo',
            'duration': '1 hour',
            'cost': 0,
          },
          {
            'time': '10:30 AM',
            'title': 'Tokyo Station Tour',
            'location': 'Tokyo Station',
            'duration': '2 hours',
            'cost': 20,
          },
          {
            'time': '02:00 PM',
            'title': 'Lunch at Local Restaurant',
            'location': 'Ginza District',
            'duration': '1 hour',
            'cost': 50,
          },
        ],
      },
      {
        'id': '2',
        'day': 2,
        'title': 'Cultural Sites & Markets',
        'activities': [
          {
            'time': '08:00 AM',
            'title': 'Senso-ji Temple Visit',
            'location': 'Asakusa',
            'duration': '3 hours',
            'cost': 0,
          },
          {
            'time': '12:00 PM',
            'title': 'Tsukiji Fish Market',
            'location': 'Tsukiji',
            'duration': '2 hours',
            'cost': 80,
          },
        ],
      },
    ];

    _calculateTotals();
  }

  void _calculateTotals() {
    totalExpenses = expenses.fold(0.0, (sum, expense) => sum + expense['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // Trip Header
          SliverAppBar(
            expandedHeight: 300,
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
                  Icons.share_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => _shareTrip(),
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => _showTripOptions(),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Trip Image
                  Image.network(
                    widget.trip['imageUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF0E4F55),
                              const Color(0xFF0E4F55).withOpacity(0.8),
                            ],
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
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Trip Info
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trip['name'],
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.trip['destination'],
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 18,
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
                                    Icons.group_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${groupMembers.length} members',
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
                                    Icons.calendar_today_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDateRange(widget.trip['startDate'], widget.trip['endDate']),
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
                ],
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
                Tab(text: 'Overview'),
                Tab(text: 'Budget'),
                Tab(text: 'Itinerary'),
                Tab(text: 'Members'),
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
                  _buildOverviewTab(),
                  _buildBudgetTab(),
                  _buildItineraryTab(),
                  _buildMembersTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Budget',
                  '\$${totalBudget.toStringAsFixed(0)}',
                  Icons.account_balance_wallet_rounded,
                  const Color(0xFF0E4F55),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Spent',
                  '\$${totalExpenses.toStringAsFixed(0)}',
                  Icons.trending_up_rounded,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Remaining',
                  '\$${(totalBudget - totalExpenses).toStringAsFixed(0)}',
                  Icons.savings_rounded,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Bookings',
                  '${bookings.length}',
                  Icons.book_online_rounded,
                  Colors.blue,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Activity
          const Text(
            'Recent Activity',
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
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildActivityItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Budget Overview
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
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Budget Overview',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${((totalExpenses / totalBudget) * 100).toStringAsFixed(0)}% used',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: totalExpenses / totalBudget,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spent',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          '\$${totalExpenses.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Remaining',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          '\$${(totalBudget - totalExpenses).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Expenses List
          const Text(
            'Recent Expenses',
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
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return _buildExpenseItem(expense);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: itinerary.length,
        itemBuilder: (context, index) {
          final day = itinerary[index];
          return _buildDayCard(day);
        },
      ),
    );
  }

  Widget _buildMembersTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Group Members',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E4F55),
                ),
              ),
              TextButton.icon(
                onPressed: () => _addMembers(),
                icon: const Icon(Icons.person_add_rounded, size: 16),
                label: const Text('Add Members'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0E4F55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              itemCount: groupMembers.length,
              itemBuilder: (context, index) {
                final member = groupMembers[index];
                return _buildMemberCard(member);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              Icons.receipt_rounded,
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
                  'New expense added',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E4F55),
                  ),
                ),
                Text(
                  '2 hours ago',
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

  Widget _buildExpenseItem(Map<String, dynamic> expense) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getCategoryColor(expense['category']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(expense['category']),
              color: _getCategoryColor(expense['category']),
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
                Text(
                  'Paid by ${expense['paidBy']}',
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
                '\$${expense['amount'].toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0E4F55),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: expense['isSettled'] ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  expense['isSettled'] ? 'Settled' : 'Pending',
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(Map<String, dynamic> day) {
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0E4F55),
                  Color(0xFF0E4F55),
                ],
              ),
              borderRadius: BorderRadius.only(
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
                        'Day ${day['day']}',
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        day['title'],
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
              ],
            ),
          ),
          
          // Activities
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: (day['activities'] as List).map((activity) => _buildActivityCard(activity)).toList(),
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
              Icons.schedule_rounded,
              color: Color(0xFF0E4F55),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                activity['duration'],
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              if (activity['cost'] > 0)
                Text(
                  '\$${activity['cost']}',
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E4F55),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member) {
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
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(member['avatar']),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle image error
                },
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              if (member['isOnline'])
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member['name'],
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E4F55),
                      ),
                    ),
                    if (member['isAdmin'])
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E4F55),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Admin',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  member['email'],
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
          Text(
            '\$${member['contribution'].toStringAsFixed(0)}',
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Accommodation':
        return const Color(0xFF0E4F55);
      case 'Transportation':
        return const Color(0xFF1976D2);
      case 'Food':
        return const Color(0xFF2E7D32);
      case 'Activity':
        return const Color(0xFF7B1FA2);
      default:
        return const Color(0xFF0E4F55);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Accommodation':
        return Icons.hotel_rounded;
      case 'Transportation':
        return Icons.flight_rounded;
      case 'Food':
        return Icons.restaurant_rounded;
      case 'Activity':
        return Icons.explore_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }

  String _formatDateRange(DateTime startDate, DateTime endDate) {
    final start = '${startDate.day}/${startDate.month}';
    final end = '${endDate.day}/${endDate.month}';
    return '$start - $end';
  }

  void _shareTrip() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _showTripOptions() {
    // TODO: Implement trip options
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Trip options coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _addMembers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSearchScreen(
          tripId: widget.trip['id'],
          tripName: widget.trip['name'],
        ),
      ),
    );
  }
}
