import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'John Doe';
  String userEmail = 'john.doe@example.com';
  String userAvatar = 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face';
  int totalTrips = 12;
  int totalPosts = 8;
  int totalFollowers = 156;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // Profile Header
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
                  Icons.settings_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => _showSettingsModal(),
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
                    children: [
                      const SizedBox(height: 60),
                      // Profile Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundImage: NetworkImage(userAvatar),
                              onBackgroundImageError: (exception, stackTrace) {
                                // Handle image error
                              },
                              child: const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _showEditProfileModal(),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Color(0xFF0E4F55),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem('Trips', totalTrips.toString()),
                          _buildStatItem('Posts', totalPosts.toString()),
                          _buildStatItem('Followers', totalFollowers.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content Section
          SliverToBoxAdapter(
            child: Container(
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
                    // Quick Actions
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    
                    // Menu Options
                    _buildMenuSection(),
                    const SizedBox(height: 24),
                    
                    // Account Section
                    _buildAccountSection(),
                    const SizedBox(height: 24),
                    
                    // Support Section
                    _buildSupportSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
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
            Expanded(
              child: _buildQuickActionCard(
                Icons.edit_rounded,
                'Edit Profile',
                const Color(0xFF0E4F55),
                () => _showEditProfileModal(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                Icons.luggage_rounded,
                'My Trips',
                const Color(0xFF1976D2),
                () => _navigateToMyTrips(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                Icons.article_rounded,
                'My Posts',
                const Color(0xFF2E7D32),
                () => _navigateToMyPosts(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Account',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
        ),
        const SizedBox(height: 16),
        _buildMenuItem(
          Icons.person_rounded,
          'Personal Information',
          'Update your personal details',
          () => _showPersonalInfoModal(),
        ),
        _buildMenuItem(
          Icons.notifications_rounded,
          'Notifications',
          'Manage your notification preferences',
          () => _showNotificationsModal(),
        ),
        _buildMenuItem(
          Icons.privacy_tip_rounded,
          'Privacy & Security',
          'Control your privacy settings',
          () => _showPrivacyModal(),
        ),
        _buildMenuItem(
          Icons.payment_rounded,
          'Payment Methods',
          'Manage your payment options',
          () => _showPaymentModal(),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Travel Data',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
        ),
        const SizedBox(height: 16),
        _buildMenuItem(
          Icons.history_rounded,
          'Travel History',
          'View your past trips and experiences',
          () => _navigateToTravelHistory(),
        ),
        _buildMenuItem(
          Icons.favorite_rounded,
          'Saved Places',
          'Your bookmarked destinations',
          () => _navigateToSavedPlaces(),
        ),
        _buildMenuItem(
          Icons.analytics_rounded,
          'Travel Statistics',
          'Your travel insights and analytics',
          () => _navigateToStatistics(),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support & More',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
        ),
        const SizedBox(height: 16),
        _buildMenuItem(
          Icons.help_rounded,
          'Help Center',
          'Get help and support',
          () => _navigateToHelpCenter(),
        ),
        _buildMenuItem(
          Icons.info_rounded,
          'About PlanSmith',
          'Learn more about our app',
          () => _navigateToAbout(),
        ),
        _buildMenuItem(
          Icons.star_rounded,
          'Rate App',
          'Rate us on the App Store',
          () => _rateApp(),
        ),
        _buildMenuItem(
          Icons.logout_rounded,
          'Logout',
          'Sign out of your account',
          () => _showLogoutDialog(),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle, VoidCallback onTap, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
                    color: isDestructive 
                        ? Colors.red.withOpacity(0.1)
                        : const Color(0xFF0E4F55).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? Colors.red : const Color(0xFF0E4F55),
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
                          color: isDestructive ? Colors.red : Colors.grey.shade800,
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

  void _showEditProfileModal() {
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
                  'Edit Profile',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0E4F55),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Profile Picture
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(userAvatar),
                        onBackgroundImageError: (exception, stackTrace) {
                          // Handle image error
                        },
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E4F55),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Form fields
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    hintText: 'Tell us about yourself',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.info_rounded),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully!'),
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
                      'Save Changes',
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

  void _showSettingsModal() {
    // TODO: Implement settings modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _showPersonalInfoModal() {
    // TODO: Implement personal info modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Personal information functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _showNotificationsModal() {
    // TODO: Implement notifications modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _showPrivacyModal() {
    // TODO: Implement privacy modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _showPaymentModal() {
    // TODO: Implement payment modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment methods functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _navigateToMyTrips() {
    // TODO: Navigate to my trips
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('My trips functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _navigateToMyPosts() {
    // TODO: Navigate to my posts
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('My posts functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _navigateToTravelHistory() {
    // TODO: Navigate to travel history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Travel history functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _navigateToSavedPlaces() {
    // TODO: Navigate to saved places
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved places functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _navigateToStatistics() {
    // TODO: Navigate to statistics
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Travel statistics functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _navigateToHelpCenter() {
    // TODO: Navigate to help center
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help center functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _navigateToAbout() {
    // TODO: Navigate to about
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('About page functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _rateApp() {
    // TODO: Implement rate app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rate app functionality coming soon!'),
        backgroundColor: Color(0xFF0E4F55),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0E4F55),
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement logout functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully!'),
                    backgroundColor: Color(0xFF0E4F55),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
